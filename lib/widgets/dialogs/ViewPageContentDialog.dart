import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:journalmax/widgets/XSnackBar.dart';
import 'package:journalmax/widgets/dialogs/AudioPlayInEditDialog.dart';
import 'package:journalmax/widgets/dialogs/DialogElevatedButton.dart';
import 'package:journalmax/widgets/dialogs/EnterImageDialog.dart';
import 'package:url_launcher/url_launcher.dart';

Future<dynamic> viewPageContentDialog(
    BuildContext context,
    ColorScheme colors,
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
            style: TextStyle(fontSize: 25.0),
          )),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              dialogButton(
                colors: colors,
                icon: Icons.book,
                title: "View Diary Entry",
                onclick: () {
                  contentWidgetChanger(SelectableText(
                    content["content"].toString(),
                    style: TextStyle(color: mood["secondary"], fontSize: 20.0),
                  ));
                  Navigator.pop(context);
                },
              ),
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
              dialogButton(
                colors: colors,
                icon: Icons.mic,
                title: "View Voice Notes",
                onclick: () {
                  contentWidgetChanger(RecordingWidget(content: content));
                  Navigator.pop(context);
                },
              ),
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

class LocationWidget extends StatelessWidget {
  final Map<String, Object?> content;
  final Map<String, Color> mood;
  const LocationWidget({super.key, required this.content, required this.mood});

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
    final bool locationNotEntered =
        content["location"].toString().trim() == "Not Entered!";
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 10.0,
      children: [
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
        Center(
            child: Text(
          "On ${content["date"]}, You were at: ",
          style: TextStyle(fontSize: 17.0, color: mood["secondary"]),
        )),
        Center(
          child: GestureDetector(
            onTap: () {
              openLocationInMaps(content["location"].toString(), context);
            },
            child: Text(
              content["location"].toString(),
              style: TextStyle(
                  fontSize: 25.0,
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

class ImagesWidget extends StatefulWidget {
  final Map<String, Object?> content;
  const ImagesWidget({super.key, required this.content});

  @override
  State<ImagesWidget> createState() => _ImagesWidgetState();
}

class _ImagesWidgetState extends State<ImagesWidget> {
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
    return ImageViewer(
      images: fileListFromEntry(),
    );
  }
}

class RecordingWidget extends StatefulWidget {
  final Map<String, Object?> content;
  const RecordingWidget({super.key, required this.content});

  @override
  State<RecordingWidget> createState() => _RecordingWidgetState();
}

class _RecordingWidgetState extends State<RecordingWidget> {
  @override
  Widget build(BuildContext context) {
    return AudioPlayer(contentId: int.parse(widget.content["id"].toString()));
  }
}
