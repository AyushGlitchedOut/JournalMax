import 'package:flutter/material.dart';
import 'package:journalmax/widgets/dialogs/DialogElevatedButton.dart';
import 'package:journalmax/services/CRUD_Entry.dart';

Future<void> wipeEntriesDialog(BuildContext context, ColorScheme colors) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
              side: BorderSide(width: 2.0, color: colors.outline),
              borderRadius: BorderRadius.circular(15.0)),
          title:
              const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(
              Icons.warning_amber_outlined,
              color: Colors.red,
            ),
            SizedBox(
              width: 10.0,
            ),
            Text(
              "Wipe All Entries!!",
              style: TextStyle(fontSize: 20.0),
            )
          ]),
          content: const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Text(
              "This action will permanently delete all the Entries. Do you really wanna do it?",
              style: TextStyle(fontSize: 17.0),
            ),
          ),
          actions: [
            actionButton(
                onclick: () async {
                  wipeOrdeleteAllEntry();
                  Navigator.of(context).pop();
                },
                text: "Yes",
                isForDelete: true,
                colors: colors),
            actionButton(
                onclick: () {
                  Navigator.of(context).pop();
                },
                text: "Cancel",
                isForDelete: false,
                colors: colors)
          ],
        );
      });
}
