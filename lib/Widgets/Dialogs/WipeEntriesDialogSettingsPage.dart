import 'package:flutter/material.dart';
import 'package:journalmax/services/CRUD_Entry.dart';

Future<void> wipeEntriesDialog(BuildContext context, ColorScheme colors) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              side: BorderSide(width: 2.0, color: colors.outline),
              borderRadius: BorderRadius.circular(15.0)),
          title: const Row(children: [
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
          content: const Text(
              "This action will permanently delete all the Entries. Do you really wanna do it?"),
          actions: [
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(colors.secondary),
                  elevation: const WidgetStatePropertyAll(5.0),
                ),
                onPressed: () async {
                  wipeOrdeleteAllEntry();
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Yes",
                  style: TextStyle(color: Colors.red),
                )),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(colors.secondary),
                  elevation: const WidgetStatePropertyAll(5.0),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("No"))
          ],
        );
      });
}
