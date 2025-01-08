// ignore: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:journalmax/Widgets/Dialogs/DialogElevatedButton.dart';

Future<dynamic> viewPageContentDialog(
    BuildContext context, ColorScheme colors) {
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
                onclick: () => {},
              ),
              dialogButton(
                colors: colors,
                icon: Icons.location_on,
                title: "View where you were",
                onclick: () => {},
              ),
              dialogButton(
                colors: colors,
                icon: Icons.mic,
                title: "View Voice Notes",
                onclick: () => {},
              ),
              dialogButton(
                colors: colors,
                icon: Icons.image,
                title: "View Attached Images",
                onclick: () => {},
              )
            ],
          ),
          actions: [
            actionButton(
                onclick: () {
                  Navigator.of(context).pop();
                },
                text: "OK",
                isForDelete: false,
                colors: colors),
            actionButton(
                onclick: () {
                  Navigator.of(context).pop();
                },
                text: "Done",
                isForDelete: false,
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
