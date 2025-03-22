import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:journalmax/widgets/dialogs/DialogElevatedButton.dart';

//Dialog to exit the app
Future<void> XExitDialog(BuildContext context) {
  final ColorScheme colors = Theme.of(context).colorScheme;
  HapticFeedback.heavyImpact();
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 0.0),
          shape: RoundedRectangleBorder(
              side: BorderSide(width: 2.0, color: colors.outline),
              borderRadius: BorderRadius.circular(15.0)),
          title: const Center(
              child: Text(
            "Exit App",
            style: TextStyle(fontSize: 25.0, shadows: [
              Shadow(
                  offset: Offset(1.5, 1.5), color: Colors.grey, blurRadius: 2)
            ]),
          )),
          content: const Text(
            "Do you really want to exit the App?",
            style: TextStyle(fontSize: 17.0, shadows: [
              Shadow(
                  offset: Offset(1.5, 1.5), color: Colors.grey, blurRadius: 2)
            ]),
          ),
          actions: [
            //To close the entire app
            actionButton(
                onclick: () {
                  SystemNavigator.pop();
                },
                text: "OK",
                isForDeleteOrCancel: true,
                colors: colors),
            //to just close the dialog
            actionButton(
                onclick: () {
                  Navigator.of(context).pop();
                },
                text: "Cancel",
                isForDeleteOrCancel: false,
                colors: colors)
          ],
        );
      });
}
