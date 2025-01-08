import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:journalmax/services/CRUD_Entry.dart';

Future<dynamic> DeleteDialog(
    BuildContext context, int id, dynamic renderParent) {
  final ColorScheme colors = Theme.of(context).colorScheme;
  HapticFeedback.selectionClick();
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.only(top: 200),
          contentPadding: const EdgeInsets.all(20.0),
          actionsPadding: const EdgeInsets.all(20.0),
          backgroundColor: colors.onSurface,
          actionsAlignment: MainAxisAlignment.start,
          alignment: Alignment.topCenter,
          shape: RoundedRectangleBorder(
              side: BorderSide(width: 2.0, color: colors.outline),
              borderRadius: BorderRadius.circular(15.0)),
          title: Center(
              child: Text(
            'Do you Really want to delete this Entry? {id:$id}',
            style: TextStyle(color: colors.onPrimary),
            textAlign: TextAlign.center,
          )),
          actions: [
            Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(colors.onPrimary)),
                    onPressed: () {
                      deleteEntry(id);
                      Navigator.of(context).pop();
                      renderParent();
                    },
                    child: Text(
                      "Yes",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red[900]),
                    )),
                const SizedBox(
                  width: 10.0,
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Cancel"))
              ],
            )),
          ],
        );
      });
}
