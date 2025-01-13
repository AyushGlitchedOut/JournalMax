import 'dart:io';

import 'package:flutter/material.dart';
import 'package:journalmax/widgets/dialogs/DialogElevatedButton.dart';
import 'package:journalmax/widgets/dialogs/EnterImageDialog.dart';
import 'package:journalmax/widgets/dialogs/EnterLocationDialog.dart';
import 'package:journalmax/widgets/XAppBar.dart';
import 'package:journalmax/widgets/XDrawer.dart';
import 'package:journalmax/widgets/XIconLabelButton.dart';

class MultimediaAddPage extends StatelessWidget {
  final void Function(String location) saveLocation;
  final void Function(List<File> images) saveImages;
  final int? contentId;
  const MultimediaAddPage(
      {super.key,
      required this.saveLocation,
      required this.saveImages,
      required this.contentId});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    if (contentId == null) {
      showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return PopScope(
              onPopInvokedWithResult: (didPop, results) {
                Navigator.pop(context);
              },
              child: AlertDialog(
                title: const Text(
                  "No Id Found",
                  style: TextStyle(fontSize: 25.0),
                ),
                content: const Text(
                  "Couldn't detect Entry. Try first Saving the Entry in Editor Page",
                  style: TextStyle(fontSize: 17.0),
                ),
                actions: [
                  actionButton(
                      onclick: () {
                        Navigator.pop(dialogContext);
                        Navigator.pop(context);
                      },
                      text: "OK",
                      isForDelete: false,
                      colors: colors)
                ],
              ),
            );
          });
    }
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: XAppBar(title: "Multimedia"),
      ),
      drawer: const XDrawer(currentPage: "editor"),
      backgroundColor: colors.surface,
      body: Column(
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
          const XIconLabelButton(icon: Icons.mic, label: "Record Voice"),
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
