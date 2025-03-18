import 'package:flutter/material.dart';

//LightMode theme
ThemeData lightmode = ThemeData(
  fontFamily: "Poppins",
  fontFamilyFallback: const ["Roboto"],
  colorScheme: const ColorScheme.light(
    brightness: Brightness.light,
    surface: Color(0xFFF5F5F5),
    onSurface: Color(0xFF333333),
    primary: Color(0xFF444444),
    onPrimary: Color(0xFFE0E0E0),
    secondary: Color(0xFFCCCCCC),
    tertiary: Color(0xFF666666),
    shadow: Color(0xFF999999),
    outline: Color(0xFFBBBBBB),
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
