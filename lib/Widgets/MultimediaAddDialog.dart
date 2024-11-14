import 'package:flutter/material.dart';
import 'package:journalmax/Widgets/XDialogButton.dart';

class XMultimediaAddDialog extends StatelessWidget {
  const XMultimediaAddDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Center(
      child: AlertDialog(
        insetPadding: const EdgeInsets.only(top: 150),
        backgroundColor: colors.onSurface,
        actionsAlignment: MainAxisAlignment.start,
        alignment: Alignment.topCenter,
        shape: RoundedRectangleBorder(
            side: BorderSide(width: 2.0, color: colors.outline),
            borderRadius: BorderRadius.circular(15.0)),
        title: Center(
            child: Text(
          "Add Multimedia",
          style: TextStyle(color: colors.onPrimary),
        )),
        content: Column(
          mainAxisSize:
              MainAxisSize.min, // Prevents the column from expanding too much
          children: [
            XDialogButton(
                colors: colors,
                icon: Icons.location_on,
                title: "Current Location"),
            XDialogButton(
              colors: colors,
              title: "Record Voice",
              icon: Icons.mic,
            ),
            XDialogButton(
              colors: colors,
              title: "Add Images",
              icon: Icons.image,
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
      ),
    );
  }
}
