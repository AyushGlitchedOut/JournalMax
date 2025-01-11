import "package:flutter/material.dart";

ElevatedButton actionButton(
    {required dynamic onclick,
    required String text,
    required bool isForDelete,
    required ColorScheme colors}) {
  return ElevatedButton(
    onPressed: onclick,
    style: ButtonStyle(
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
            side: BorderSide(color: colors.outline),
            borderRadius: const BorderRadius.all(Radius.elliptical(10, 10)))),
        backgroundColor: WidgetStatePropertyAll(colors.secondary),
        elevation: const WidgetStatePropertyAll(5.0),
        shadowColor: WidgetStatePropertyAll(colors.shadow)),
    child: Text(
      text,
      style: TextStyle(
          color: isForDelete ? Colors.red[900] : colors.primary,
          fontWeight: FontWeight.bold),
    ),
  );
}
