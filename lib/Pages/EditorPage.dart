import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:journalmax/Pages/ViewerPage.dart';
import 'package:journalmax/Widgets/MultimediaAddDialog.dart';
import 'package:journalmax/Widgets/XAppBar.dart';
import 'package:journalmax/Widgets/XDrawer.dart';
import 'package:journalmax/Widgets/XEntryItem.dart';
import 'package:journalmax/Widgets/XFloatingButton.dart';
import 'package:journalmax/Widgets/XIconLabelButton.dart';
import 'package:journalmax/Widgets/XSnackBar.dart';
import 'package:journalmax/models/EntryModel.dart';
import 'package:journalmax/services/CRUD_Entry.dart';
import 'package:journalmax/services/InsertEntry.dart';

// ignore: must_be_immutable
class EditorPage extends StatefulWidget {
  final bool? createNewEntry;
  int? UpdateId;

  EditorPage({super.key, this.createNewEntry = true, this.UpdateId});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  String currentMood = "Happy";
  Map<String, dynamic> moods = EntryItemMoods.happy;

  Future<void> setUpdateIDForNewEntry() async {
    if (!widget.createNewEntry!) {
      return;
    }
    final result = await getRecentEntries();
    widget.UpdateId = result.last["id"];
    return;
  }

  Future<void> CreateEntry() async {
    await insertEntry(
        "Untitled", "", "Happy", DateTime.now().toString(), null, null, null);
  }

  Future<void> UpdateEntry() async {
    final int id;
    final entries = await getRecentEntries();
    id = widget.createNewEntry ?? true ? entries.last["id"] : widget.UpdateId!;
    await updateEntry(
      id,
      Entry(
        title: _titleController.text,
        Content: _contentController.text,
        mood: currentMood,
        date: DateTime.now().toString(),
      ),
    );
  }

  Future<Map<String, dynamic>> getEntryDetailsById(int id) async {
    final res = await getEntryById(id);
    if (res.isNotEmpty) {
      return res.first; // Return the first entry if it exists
    } else {
      throw Exception("No entry found with ID $id");
    }
  }

  Future<void> fetchExistingEntry(int id) async {
    try {
      final entryDetails = await getEntryDetailsById(id);
      setState(() {
        _titleController.text = entryDetails["title"] ?? "Untitled";
        _contentController.text = entryDetails["content"] ?? "";
        currentMood = entryDetails["mood"] ?? "Happy";
        moods = EntryItemMoods.NameToColor(currentMood);
      });
    } catch (e) {
      if (kDebugMode) debugPrint("Error fetching entry: $e");
    }
  }

  void setCurrentMoodString(String mood) {
    setState(() {
      currentMood = mood;
      moods = EntryItemMoods.NameToColor(mood);
    });
  }

  @override
  void initState() {
    if (widget.createNewEntry!) {
      CreateEntry();
    } else if (widget.UpdateId != null) {
      fetchExistingEntry(widget.UpdateId!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setUpdateIDForNewEntry();
    final ColorScheme colors = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        await UpdateEntry();
        Navigator.pop(context);
      },
      child: Scaffold(
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: XAppBar(title: "Editor Page"),
          ),
          drawer: const XDrawer(currentPage: "editor"),
          onDrawerChanged: (isOpened) => UpdateEntry(),
          backgroundColor: colors.surface,
          body: Column(
            children: [
              XIconLabelButton(
                icon: Icons.mood,
                label: "What's your current mood?",
                customFontSize: 19.0,
                onclick: () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return MoodChangeDialog(
                      returnMood: setCurrentMoodString,
                    );
                  },
                ),
              ),
              XIconLabelButton(
                icon: Icons.image_outlined,
                label: "Add Multimedia",
                onclick: () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const Center(child: XMultimediaAddDialog());
                  },
                ),
              ),
              TitleBar(),
              ContentBox(),
              XIconLabelButton(
                icon: Icons.save_as_rounded,
                label: "Save Entry",
                onclick: () async {
                  await UpdateEntry();
                  showSnackBar("Updated Entry", context);
                },
              ),
            ],
          ),
          floatingActionButton: XFloatingButton(
              icon: Icons.remove_red_eye_outlined,
              onclick: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return ViewerPage(
                    Id: widget.UpdateId ?? 1,
                  );
                }));
              })),
    );
  }

  Expanded ContentBox() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(5.0),
        child: SingleChildScrollView(
          child: TextField(
            controller: _contentController,
            enabled: true,
            style: TextStyle(color: moods["text"]),
            decoration: InputDecoration(
              hintText: "Enter your thoughts here!",
              hintStyle: TextStyle(color: moods["secondary"]),
              filled: true,
              fillColor: moods["surface"],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: moods["secondary"]),
              ),
            ),
            minLines: 12,
            maxLines: 20,
          ),
        ),
      ),
    );
  }

  Padding TitleBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        autofocus: true,
        controller: _titleController,
        style: TextStyle(color: moods["text"]),
        decoration: InputDecoration(
          hintText: "Enter the title here...",
          hintStyle: TextStyle(color: moods["text"]),
          filled: true,
          fillColor: moods["surface"],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: moods["text"]),
          ),
        ),
      ),
    );
  }
}

// Dialog class remains unchanged from your original code

// ignore: must_be_immutable
class MoodChangeDialog extends StatefulWidget {
  void Function(String currentmood) returnMood;
  MoodChangeDialog({super.key, required this.returnMood});

  @override
  State<MoodChangeDialog> createState() => _MoodChangeDialogState();
}

class _MoodChangeDialogState extends State<MoodChangeDialog> {
  String currentMood = "Happy";
  final moods = EntryItemMoods.moods;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return AlertDialog(
        insetPadding: const EdgeInsets.only(top: 85),
        backgroundColor: colors.onSurface,
        actionsAlignment: MainAxisAlignment.start,
        alignment: Alignment.topCenter,
        shape: RoundedRectangleBorder(
            side: BorderSide(width: 2.0, color: colors.outline),
            borderRadius: BorderRadius.circular(15.0)),
        title: Center(
            child: Text(
          "Choose your current Mood",
          style: TextStyle(color: colors.onPrimary),
        )),
        content: Column(
            children: moods.map<Widget>((mood) {
          return Container(
              child: Row(
            children: [
              Radio(
                  activeColor: Colors.red,
                  fillColor: WidgetStatePropertyAll(Colors.grey.shade500),
                  value: mood,
                  groupValue: currentMood,
                  onChanged: (value) {
                    widget.returnMood(currentMood);
                    setState(() {
                      currentMood = value!;
                    });
                  }),
              Text(
                mood,
                style: TextStyle(color: colors.onPrimary, fontSize: 17.0),
              ),
            ],
          ));
        }).toList()),
        actions: [
          ElevatedButton(
              onPressed: () {
                widget.returnMood(currentMood);
                showSnackBar('Changed Entry Mood To $currentMood', context);
                Navigator.pop(context);
              },
              child: const Text("Done!")),
        ]);
  }
}
