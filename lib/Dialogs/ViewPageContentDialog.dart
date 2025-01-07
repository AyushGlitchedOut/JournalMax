// ignore: non_constant_identifier_names
import 'package:flutter/material.dart';

import 'XDialogButton.dart';

Future<dynamic> ViewPageContentDialog(
    BuildContext context, ColorScheme colors) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.only(top: 150),
          backgroundColor: colors.onSurface,
          actionsAlignment: MainAxisAlignment.start,
          alignment: Alignment.topCenter,
          shape: RoundedRectangleBorder(
              side: BorderSide(width: 2.0, color: colors.outline),
              borderRadius: BorderRadius.circular(15.0)),
          title: Center(
              child: Text(
            "View Memories",
            style: TextStyle(
                color: colors.onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 30.0),
          )),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              XDialogButton(
                colors: colors,
                icon: Icons.book,
                title: "View Diary Entry",
                onclick: () => {},
              ),
              XDialogButton(
                colors: colors,
                icon: Icons.location_on,
                title: "View where you were",
                onclick: () => {},
              ),
              XDialogButton(
                colors: colors,
                icon: Icons.mic,
                title: "View Voice Notes",
                onclick: () => {},
              ),
              XDialogButton(
                colors: colors,
                icon: Icons.image,
                title: "View Attached Images",
                onclick: () => {},
              )
            ],
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"))
          ],
        );
      });
}
