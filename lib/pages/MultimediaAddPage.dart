import 'dart:io';
import 'package:flutter/material.dart';
import 'package:journalmax/widgets/dialogs/AudioPlayInEditDialog.dart';
import 'package:journalmax/widgets/dialogs/AudioRecordDialog.dart';
import 'package:journalmax/widgets/dialogs/EnterImageDialog.dart';
import 'package:journalmax/widgets/dialogs/EnterLocationDialog.dart';
import 'package:journalmax/widgets/XAppBar.dart';
import 'package:journalmax/widgets/XIconLabelButton.dart';

class MultimediaAddPage extends StatelessWidget {
  //reporting methods taken from editor page to pass into the dialogs
  final void Function(String location) saveLocation;
  final void Function(List<File> images) saveImages;
  final void Function(String audioFilePath) saveRecording;
  //bool to see if recording is there or not
  final bool alreadyHasRecording;
  //contentId
  final int? contentId;
  const MultimediaAddPage(
      {super.key,
      required this.saveLocation,
      required this.saveImages,
      required this.contentId,
      required this.saveRecording,
      required this.alreadyHasRecording});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: XAppBar(
          title: "Multimedia",
          preventDefaultDrawer: true,
          onDrawer: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: colors.surface,
      body: Column(
        //Opens up Location Dialog
        children: [
          XIconLabelButton(
            icon: Icons.location_on,
            label: "Current Location",
            onclick: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return EnterLocationDialog(
                      reportLocation: saveLocation,
                      contentId: contentId!,
                    );
                  });
            },
          ),

          //Opens up Image dialog
          XIconLabelButton(
              icon: Icons.image,
              label: "Add images",
              onclick: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return EnterImageDialog(
                        reportImages: saveImages,
                        contentId: contentId!,
                      );
                    });
              }),

          //Opens up Voice dialog
          XIconLabelButton(
            icon: Icons.mic,
            label: "Record Voice",
            onclick: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    //check to open recording dialog or playing dialog based on whether the recording is there or not
                    return alreadyHasRecording
                        ? AudioPlayInEditModeDialog(
                            contentId: contentId!,
                            reportRecordingFunction: saveRecording,
                          )
                        : AudioRecordDialog(
                            entryID: contentId!,
                            reportRecordingFile: saveRecording,
                          );
                  });
            },
          ),
          Center(
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(colors.onSurface),
                    elevation: const WidgetStatePropertyAll(2.0)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "OK",
                  style: TextStyle(
                      color: colors.onPrimary, fontWeight: FontWeight.bold),
                )),
          )
        ],
      ),
    );
  }
}
