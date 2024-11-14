import 'package:flutter/material.dart';

class MultimediaAddDialog extends StatelessWidget {
  const MultimediaAddDialog({super.key});

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
            DialogButton(
                colors: colors,
                icon: Icons.location_on,
                title: "Current Location"),
            DialogButton(
              colors: colors,
              title: "Record Voice",
              icon: Icons.mic,
            ),
            DialogButton(
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

class DialogButton extends StatelessWidget {
  const DialogButton(
      {super.key,
      required this.colors,
      required this.icon,
      required this.title,
      this.onclick});

  final ColorScheme colors;
  final String title;
  final IconData icon;
  final void Function()? onclick;

  @override
  Widget build(BuildContext context) {
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
                color: colors.primary,
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
}
