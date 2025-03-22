import "package:flutter/material.dart";

//reusable elevatedButton used in all dialogs for OK, cancel etc. for consistency and ease of devlopment
ElevatedButton actionButton(
    {required dynamic onclick,
    required String text,
    required bool isForDeleteOrCancel,
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
          //make the button text red if its for canceling or deleting
          color: isForDeleteOrCancel ? Colors.red[900] : colors.primary,
          fontWeight: FontWeight.bold,
          shadows: const [
            Shadow(offset: Offset(1.5, 1.5), color: Colors.grey, blurRadius: 2)
          ]),
    ),
  );
}
