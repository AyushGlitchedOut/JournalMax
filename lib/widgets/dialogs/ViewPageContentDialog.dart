import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:journalmax/widgets/XSnackBar.dart';
import 'package:journalmax/widgets/dialogs/AudioPlayInEditDialog.dart';
import 'package:journalmax/widgets/dialogs/DialogElevatedButton.dart';
import 'package:journalmax/widgets/dialogs/EnterImageDialog.dart';
import 'package:url_launcher/url_launcher.dart';

//dialog used in ViewPage to change the content being viewed i.e Data entry, image, location, recording
Future<dynamic> viewPageContentDialog(
    BuildContext context,
    ColorScheme colors,
    //setState method to change the widget in viewer Page
    void Function(Widget contentWidget) contentWidgetChanger,
    Map<String, Object?> content,
    Map<String, Color> mood) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.only(top: 150),
          actionsAlignment: MainAxisAlignment.start,
          alignment: Alignment.topCenter,
          shape: RoundedRectangleBorder(
              side: BorderSide(width: 2.0, color: colors.outline),
              borderRadius: BorderRadius.circular(15.0)),
          title: const Center(
              child: Text(
            "View Memories",
            style: TextStyle(fontSize: 25.0, shadows: [
              Shadow(
                  offset: Offset(1.5, 1.5), color: Colors.grey, blurRadius: 2)
            ]),
          )),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //options to view different stored data
              dialogButton(
                colors: colors,
                icon: Icons.book,
                title: "View Diary Entry",
                onclick: () {
                  contentWidgetChanger(SelectableText(
                    content["content"].toString(),
                    textAlign: TextAlign.left,
                    style: TextStyle(color: mood["secondary"], fontSize: 20.0),
                  ));
                  Navigator.pop(context);
                },
              ),
              //see location
              dialogButton(
                colors: colors,
                icon: Icons.location_on,
                title: "View where you were",
                onclick: () {
                  contentWidgetChanger(
                      LocationWidget(content: content, mood: mood));
                  Navigator.pop(context);
                },
              ),
              //see recording
              dialogButton(
                colors: colors,
                icon: Icons.mic,
                title: "View Voice Notes",
                onclick: () {
                  contentWidgetChanger(RecordingWidget(content: content));
                  Navigator.pop(context);
                },
              ),
              //see images
              dialogButton(
                colors: colors,
                icon: Icons.image,
                title: "View Attached Images",
                onclick: () {
                  contentWidgetChanger(ImagesWidget(content: content));
                  Navigator.pop(context);
                },
              )
            ],
          ),
          actions: [
            //Both do the same thing-> Quit the dialog
            actionButton(
                onclick: () {
                  Navigator.of(context).pop();
                },
                text: "OK",
                isForDeleteOrCancel: false,
                colors: colors),
            actionButton(
                onclick: () {
                  Navigator.of(context).pop();
                },
                text: "Done",
                isForDeleteOrCancel: false,
                colors: colors)
          ],
        );
      });
}

// A reusable button to display items in the dialog
Container dialogButton(
    {required ColorScheme colors,
    required IconData icon,
    required String title,
    required void Function()? onclick}) {
  return Container(
    margin: const EdgeInsets.all(5.0),
    decoration: BoxDecoration(
        color: colors.onSurface,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(color: colors.shadow, offset: const Offset(1.5, 1.5)),
          BoxShadow(color: colors.outline, offset: const Offset(-1.5, -1.5))
        ]),
    child: ElevatedButton(
        style: ButtonStyle(
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                side: BorderSide(color: colors.outline),
                borderRadius: BorderRadius.circular(10.0))),
            padding: WidgetStateProperty.all(const EdgeInsets.all(5.0)),
            alignment: Alignment.topLeft),
        onPressed: onclick,
        child: Row(
          children: [
            Icon(
              icon,
              size: 40.0,
              color: colors.onPrimary,
            ),
            const SizedBox(
              width: 20.0,
            ),
            Text(
              title,
              style: TextStyle(fontSize: 20.0, color: colors.tertiary),
            )
          ],
        )),
  );
}

//Widget in viewerPage to display location
class LocationWidget extends StatelessWidget {
  final Map<String, Object?> content;
  final Map<String, Color> mood;
  const LocationWidget({super.key, required this.content, required this.mood});

  //to open the obtained location in google maps query
  Future<void> openLocationInMaps(String location, BuildContext context) async {
    try {
      final locationEncodedUri = Uri.encodeFull(location);
      final url = Uri.parse(
          "https://www.google.com/maps/search/?api=1&query=$locationEncodedUri");
      launchUrl(url, mode: LaunchMode.externalApplication);
    } on Exception {
      showSnackBar(
          "Sorry, Couldn't open web results for the location", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    //check if location is entered
    final bool locationNotEntered =
        content["location"].toString().trim() == "Not Entered!";
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 10.0,
      children: [
        //red icon for aesthetics
        Center(
          child: Icon(
            Icons.location_pin,
            color: Colors.red,
            size: 100.0,
            shadows: [
              Shadow(color: colors.shadow, offset: const Offset(-2, -2))
            ],
          ),
        ),
        //label
        Center(
            child: Text(
          "On ${content["date"]}, You were at: ",
          style: TextStyle(fontSize: 17.0, color: mood["secondary"], shadows: const [
            Shadow(offset: Offset(1.5, 1.5), color: Colors.grey, blurRadius: 2)
          ]),
        )),
        //THe actual location in format of a link that has onclick to open a maps
        Center(
          child: GestureDetector(
            onTap: () {
              openLocationInMaps(content["location"].toString(), context);
            },
            child: Text(
              content["location"].toString(),
              style: TextStyle(
                  fontSize: 25.0,
                  shadows: const [
                    Shadow(
                        offset: Offset(1.5, 1.5),
                        color: Colors.grey,
                        blurRadius: 2)
                  ],
                  fontWeight: FontWeight.w500,
                  color: locationNotEntered ? mood["text"] : Colors.lightBlue,
                  decoration:
                      locationNotEntered ? null : TextDecoration.underline,
                  decorationColor: Colors.lightBlue),
            ),
          ),
        )
      ],
    );
  }
}

//ImagesWidget to display images
class ImagesWidget extends StatefulWidget {
  final Map<String, Object?> content;
  const ImagesWidget({super.key, required this.content});

  @override
  State<ImagesWidget> createState() => _ImagesWidgetState();
}

class _ImagesWidgetState extends State<ImagesWidget> {
  //loop over jsondecoded list from the entry and convert each one into files
  List<File> fileListFromEntry() {
    if (widget.content["image"].toString() == "null") {
      return [];
    }
    final List imagePaths = jsonDecode(widget.content["image"].toString());
    final List<File> imageFiles = [];
    for (dynamic i in imagePaths) {
      imageFiles.add(File(i));
    }
    return imageFiles;
  }

  @override
  Widget build(BuildContext context) {
    //use the dialog from ImageEditPage dialog to view images
    return ImageViewer(
      images: fileListFromEntry(),
    );
  }
}

//RecordingWidget to display voice recordings in viewer Page
class RecordingWidget extends StatefulWidget {
  final Map<String, Object?> content;
  const RecordingWidget({super.key, required this.content});

  @override
  State<RecordingWidget> createState() => _RecordingWidgetState();
}

class _RecordingWidgetState extends State<RecordingWidget> {
  @override
  Widget build(BuildContext context) {
    //use AudioPlayer from audioplayineditmodedialog to play audio in viewer Page
    return AudioPlayer(contentId: int.parse(widget.content["id"].toString()));
  }
}
