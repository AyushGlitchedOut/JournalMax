import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:journalmax/models/EntryItemMoods.dart';
import 'package:journalmax/services/AudioService.dart';
import 'package:journalmax/services/ImageService.dart';
import 'package:journalmax/widgets/dialogs/DialogElevatedButton.dart';
import 'package:journalmax/widgets/dialogs/MoodChangeDialogEditorPage.dart';
import 'package:journalmax/pages/ViewerPage.dart';
import 'package:journalmax/pages/MultimediaAddPage.dart';
import 'package:journalmax/widgets/XAppBar.dart';
import 'package:journalmax/widgets/XDrawer.dart';
import 'package:journalmax/widgets/XFloatingButton.dart';
import 'package:journalmax/widgets/XIconLabelButton.dart';
import 'package:journalmax/widgets/XProgress.dart';
import 'package:journalmax/widgets/XSnackBar.dart';
import 'package:journalmax/models/EntryModel.dart';
import 'package:journalmax/services/DataBaseService.dart';
import 'package:journalmax/services/InsertEntry.dart';

// ignore: must_be_immutable
class EditorPage extends StatefulWidget {
  final bool? createNewEntry;
  int? updateId;

  EditorPage({super.key, this.createNewEntry = true, this.updateId});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  //Initialising variables
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  String currentMood = "Neutral";
  String location = "Not Entered";
  bool isLoading = false;
  List<File>? tempImages;
  String? tempRecordingFilePath;
  Map<String, dynamic> moods = EntryItemMoods.neutral;

  //CREATE
  Future<void> createEntry() async {
    try {
      await insertEntry("Untitled", "", "Neutral", DateTime.now().toString(),
          null, null, null);
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  // Get and process an entry by Id
  Future<Map<String, dynamic>> getEntryDetailsById(int id) async {
    try {
      final res = await getEntryById(id);
      if (res.isNotEmpty) {
        return res.first; // Return the first entry if it exists
      } else {
        throw Exception("No entry found with ID $id");
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
      throw Exception(e);
    }
  }

  //Read the entry opened or created and put its details in the UI elements
  Future<void> fetchExistingEntry(int id) async {
    try {
      final entryDetails = await getEntryDetailsById(id);

      //decode stored Image Paths
      final List imagePaths = jsonDecode(entryDetails["image"] ?? "[]");
      final List<File> imagesFromPaths = imagePaths.map((value) {
        return File(value);
      }).toList();

      setState(() {
        _titleController.text = entryDetails["title"] ?? "Untitled";
        _contentController.text = entryDetails["content"] ?? "";
        currentMood = entryDetails["mood"] ?? "Neutral";
        moods = EntryItemMoods.nameToColor(currentMood);
        location = entryDetails["location"] ?? "Not Given";
        tempImages = imagesFromPaths;
        tempRecordingFilePath = entryDetails["audio_record"];
      });
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  //Update the Entry when required to save the changes
  Future<void> callUpdateEntry() async {
    try {
      final int id;
      final entries = await getRecentEntries();

      //determine the Id on which update to be pushed
      id = widget.createNewEntry ?? true
          ? entries.first["id"]
          : widget.updateId!;

      // obtain the imagePaths to save after writing the images
      final storedImagesPathsJSON = await writeTempImagesToFile(
          tempImages: tempImages ?? [], entryId: id);

      //Obtain the audioPaths to save after writing the recordings
      final savedAudioFilePath = await saveTempAudioToFile(
          tempAudioFile: tempRecordingFilePath ?? "null", entryId: id);
      await updateEntry(
        id,
        Entry(
            //check if the title is even there before capitalisation
            title: _titleController.text == ""
                ? "Untitled"
                : _titleController.text.replaceFirst(_titleController.text[0],
                    _titleController.text[0].toUpperCase()),
            /* Capitalise the first letter*/
            content: _contentController.text,
            mood: currentMood,
            date: DateTime.now().toString(),
            location: location,
            image: storedImagesPathsJSON,
            audioRecord: savedAudioFilePath),
      );
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  Future<void> setUpdateIDForNewEntry() async {
    try {
      if (!widget.createNewEntry!) {
        return; // return if not to create new entry as updateId already given
      }
      final result = await getRecentEntries();
      widget.updateId =
          result.first["id"]; //get the id of the most recently (new) entry
      return;
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  //reporting method passed into Location dialog
  void getLocationFromDialog(String obtainedLocation) {
    location = obtainedLocation;
    if (kDebugMode) print("Got Location: $obtainedLocation");
  }

  //reporting method passed into Images dialog
  void getImagesFromDialog(List<File> obtainedImages) {
    tempImages = obtainedImages;
  }

  //reporting method passed into Recording dialog
  void getAudioFilePathFromDialog(String obtainedAudioFilePath) {
    tempRecordingFilePath = obtainedAudioFilePath;
    if (kDebugMode) print("Got Audio File: $obtainedAudioFilePath");
  }

  //Method to change the STring form of stored current mood
  void setCurrentMoodString(String mood) {
    setState(() {
      currentMood = mood;
      moods = EntryItemMoods.nameToColor(mood);
    });
  }

  @override
  void initState() {
    super.initState();

    //upon initialkising, create new entry if needed and set the update Id based on that
    try {
      //start loading
      setState(() {
        isLoading = true;
      });

      //to create new entry or to use existing entry Id
      if (widget.createNewEntry ?? true) {
        createEntry();
      } else if (widget.updateId != null) {
        fetchExistingEntry(widget.updateId!);
      }
      setUpdateIDForNewEntry();

      //stop loading
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    //initiliase state-based variables
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    final ColorScheme colors = Theme.of(context).colorScheme;

    return PopScope(
      //popscope to initialise autosave on exiting the editor page
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        await callUpdateEntry();
      },
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: XAppBar(title: "Editor Page"),
          ),
          drawer: const XDrawer(currentPage: "editor"),
          //save called on drawer open to prevent changes being discarded
          onDrawerChanged: (isOpened) => callUpdateEntry(),
          backgroundColor: colors.surface,
          body: Column(
            children: [
              titleBar(),
              contentBox(context),

              //display the buttons at bottom only if keyboard isn't open
              isKeyboardOpen
                  ? Container()
                  : XIconLabelButton(
                      icon: Icons.add_link_rounded,
                      label: "More Ways to Store Memories",
                      customFontSize: 17.0,
                      onclick: () => showDialog(
                          context: context,
                          builder: (context) {
                            return memoriesTabDialog(colors, context);
                          }),
                    ),
              isKeyboardOpen
                  ? Container()
                  : XIconLabelButton(
                      icon: Icons.save_as_rounded,
                      label: "Save Entry",
                      onclick: () async {
                        await callUpdateEntry();
                        showSnackBar("Updated Entry", context);
                      },
                    ),
            ],
          ),
          floatingActionButton: XFloatingButton(
              //floating button to view the current entry in Viewer Page
              icon: Icons.remove_red_eye_outlined,
              onclick: () async {
                await callUpdateEntry();
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return ViewerPage(
                    providedEntryId: widget.updateId ?? 1,
                  );
                }));
              })),
    );
  }

//made a method instead of widget as it wont re-render many times, will only be built when the dialog is opened
//and turning into widget would introduce unnecesary complications
  AlertDialog memoriesTabDialog(ColorScheme colors, BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 0.0),
      shape: RoundedRectangleBorder(
          side: BorderSide(width: 2.0, color: colors.outline),
          borderRadius: BorderRadius.circular(15.0)),
      title: const Center(
        child: Text(
          textAlign: TextAlign.center,
          "More Ways to Store Memories",
          style: TextStyle(fontSize: 25.0, shadows: [
            Shadow(offset: Offset(1.5, 1.5), color: Colors.grey, blurRadius: 2)
          ]),
        ),
      ),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.25,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            XIconLabelButton(
              icon: Icons.mood,
              label: "What's your current mood?",
              customFontSize: 15.5,
              onclick: () => showDialog(
                context: context,
                builder: (BuildContext context) {
                  return MoodChangeDialog(
                    returnMood: setCurrentMoodString,
                    currentmood: currentMood,
                  );
                },
              ),
            ),
            XIconLabelButton(
                icon: Icons.image_outlined,
                label: "Add Multimedia",
                onclick: () => Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return MultimediaAddPage(
                        saveLocation: getLocationFromDialog,
                        saveImages: getImagesFromDialog,
                        saveRecording: getAudioFilePathFromDialog,
                        contentId: widget.updateId,
                        alreadyHasRecording:
                            tempRecordingFilePath.toString() != "null" &&
                                tempRecordingFilePath.toString() != "",
                      );
                    }))),
          ],
        ),
      ),
      actions: [
        actionButton(
            onclick: () => Navigator.pop(context),
            text: "Done",
            isForDeleteOrCancel: false,
            colors: colors)
      ],
    );
  }

  //contentBox to display diary entry
  Expanded contentBox(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: isLoading
            ? XProgress(colors: Theme.of(context).colorScheme)
            : Container(
                child: TextField(
                  controller: _contentController,
                  onTap: () => setState(() {}),
                  enabled: true,
                  style: TextStyle(color: moods["text"]),
                  decoration: InputDecoration(
                    hintText: "Enter your thoughts here!",
                    hintStyle: TextStyle(color: moods["secondary"]),
                    filled: true,
                    fillColor: moods["surface"],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: BorderSide(color: moods["secondary"]),
                    ),
                  ),
                  minLines: 20,
                  maxLines: 20,
                ),
              ),
      ),
    );
  }

//TitleBar
  Padding titleBar() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: TextField(
        autofocus: true,
        onTap: () => setState(() {}),
        controller: _titleController,
        style: TextStyle(color: moods["text"]),
        decoration: InputDecoration(
          hintText: "Enter the title here...",
          hintStyle: TextStyle(color: moods["text"]),
          filled: true,
          fillColor: moods["surface"],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: BorderSide(color: moods["text"]),
          ),
        ),
      ),
    );
  }
}
