import 'package:flutter/material.dart';

ThemeData lightmode = ThemeData(
    fontFamily: "Poppins",
    fontFamilyFallback: const ["Roboto"],
    colorScheme: ColorScheme.dark(
        brightness: Brightness.dark,
        surface: Colors.grey.shade800,
        onSurface: Colors.grey.shade300,
        primary: Colors.grey.shade300,
        onPrimary: Colors.black54,
        secondary: Colors.white38,
        tertiary: Colors.grey.shade500,
        outline: Colors.grey.shade800,
        shadow: Colors.black38));

ThemeData darkmode = ThemeData(
    fontFamily: "Poppins",
    fontFamilyFallback: const ["Roboto"],
    colorScheme: ColorScheme.light(
        brightness: Brightness.light,
        surface: const Color(0xFF071013),
        onSurface: Colors.grey.shade300,
        primary: const Color.fromARGB(255, 150, 118, 178),
        onPrimary: const Color.fromARGB(255, 59, 40, 40),
        secondary: const Color(0xFFE6E8E6),
        tertiary: const Color(0xFF566C5E),
        shadow: Colors.grey.shade700,
        outline: Colors.black));
