import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:journalmax/widgets/dialogs/DialogElevatedButton.dart';
import 'package:journalmax/services/DataBaseService.dart';

//dialog to open when Entry is to be deleted
Future<dynamic> deleteDialog(
    BuildContext context, int id, dynamic renderParent) {
  final ColorScheme colors = Theme.of(context).colorScheme;
  //vibrate when dialog opens
  HapticFeedback.selectionClick();
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(vertical: 250),
          actionsAlignment: MainAxisAlignment.start,
          alignment: Alignment.topCenter,
          shape: RoundedRectangleBorder(
              side: BorderSide(width: 2.0, color: colors.outline),
              borderRadius: BorderRadius.circular(15.0)),
          title: const Center(
            child: Text(
              "Delete Entry?",
              style: TextStyle(fontSize: 25.0),
            ),
          ),
          content: const Center(
              child: Text(
            'Do you Really want to delete this Entry?',
            style: TextStyle(fontSize: 17.0),
            textAlign: TextAlign.center,
          )),
          actions: [
            Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //Ok button to delete the entry, re-render the parent and close the dialog
                actionButton(
                    onclick: () async {
                      await deleteEntry(id);
                      Navigator.of(context).pop();
                      renderParent();
                    },
                    text: "Yes",
                    isForDeleteOrCancel: true,
                    colors: colors),
                const SizedBox(
                  width: 10.0,
                ),
                //close the dialog
                actionButton(
                    onclick: () {
                      Navigator.of(context).pop();
                    },
                    text: "No",
                    isForDeleteOrCancel: false,
                    colors: colors)
              ],
            )),
          ],
        );
      });
}
