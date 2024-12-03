import 'package:flutter/material.dart';

void showSnackBar(String message, BuildContext context) {
  final ColorScheme colors = Theme.of(context).colorScheme;
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    elevation: 10.0,
    margin: EdgeInsets.all(7.0),
    behavior: SnackBarBehavior.floating,
    backgroundColor: colors.onPrimary,
    content: Container(
      child: Text(
        message,
        style: TextStyle(color: colors.primary, fontWeight: FontWeight.bold),
        textAlign: TextAlign.left,
      ),
    ),
  ));
}
