import 'package:flutter/material.dart';

ThemeData lightmode = ThemeData(
  fontFamily: "Poppins",
  fontFamilyFallback: const ["Roboto"],
  colorScheme: const ColorScheme.light(
    brightness: Brightness.light,
    surface: Color(0xFFFAF3F0),
    onSurface: Color(0xFF222831),
    primary: Color(0xFF965EA9),
    onPrimary: Color(0xFFE8D7E0),
    secondary: Color(0xFF283B34),
    tertiary: Color(0xFF9CC2A2),
    shadow: Color(0xFF666666),
    outline: Color(0xFF8B3DC5),
  ),
);
//DarkMode theme
ThemeData darkmode = ThemeData(
    fontFamily: "Poppins",
    fontFamilyFallback: const ["Roboto"],
    colorScheme: ColorScheme.dark(
        brightness: Brightness.light,
        surface: const Color(0xFF071013),
        onSurface: Colors.grey.shade300,
        primary: const Color.fromARGB(255, 150, 118, 178),
        onPrimary: const Color.fromARGB(255, 59, 40, 40),
        secondary: const Color(0xFFE6E8E6),
        tertiary: const Color(0xFF566C5E),
        shadow: Colors.grey.shade400,
        outline: const Color.fromARGB(255, 135, 27, 230)));
