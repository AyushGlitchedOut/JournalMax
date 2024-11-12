import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> ExitDialog(BuildContext context) {
  final ColorScheme colors = Theme.of(context).colorScheme;
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              side: BorderSide(width: 2.0, color: colors.outline),
              borderRadius: BorderRadius.circular(15.0)),
          title: const Text("Exit App"),
          content: const Text("Do you really want to exit the App"),
          actions: [
            ElevatedButton(
                onPressed: () {
                  SystemNavigator.pop();
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
