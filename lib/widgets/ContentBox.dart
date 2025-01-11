import 'package:flutter/material.dart';

Container contentBox(
    {required Widget child,
    required ColorScheme colors,
    double? width,
    double? height}) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
        gradient: LinearGradient(
            stops: [0.7, 0.95],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colors.onSurface, Colors.grey]),
        color: colors.onSurface,
        border: Border.all(width: 2.0, color: colors.outline),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
              color: colors.shadow,
              offset: Offset(1.5, 1.5),
              blurRadius: 1.0,
              spreadRadius: 1.0),
          BoxShadow(
              color: colors.shadow,
              offset: Offset(-1.0, -1.0),
              blurRadius: 1.5,
              spreadRadius: 1.0)
        ]),
    padding: EdgeInsets.all(2.0),
    margin: EdgeInsets.all(5.0),
    child: child,
  );
}
