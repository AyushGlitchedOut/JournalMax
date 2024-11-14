import 'package:flutter/material.dart';

ThemeData lightmode = ThemeData(
    colorScheme: ColorScheme.light(
        brightness: Brightness.light,
        surface: Colors.grey.shade200,
        onSurface: Colors.grey.shade600,
        primary: Colors.grey.shade800,
        onPrimary: Colors.white,
        secondary: Colors.black87,
        tertiary: Colors.grey.shade400,
        outline: Colors.grey.shade900,
        shadow: Colors.black38));

ThemeData darkmode = ThemeData(
    colorScheme: ColorScheme.dark(
        brightness: Brightness.dark,
        surface: Colors.grey.shade800,
        onSurface: Colors.grey.shade300,
        primary: Colors.grey.shade300,
        onPrimary: Colors.black54,
        secondary: Colors.white38,
        tertiary: Colors.grey.shade500,
        outline: Colors.grey.shade800,
        shadow: Colors.white38));
