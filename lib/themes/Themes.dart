import 'package:flutter/material.dart';

ThemeData lightmode = ThemeData(
  fontFamily: "Poppins",
  fontFamilyFallback: const ["Roboto"],
  colorScheme: const ColorScheme.light(
    brightness: Brightness.light,
    surface: Color(0xFFF5F5F5), // Light grey for surface backgrounds
    onSurface: Color(0xFF333333), // Dark grey for text on surfaces
    primary: Color(0xFF444444), // Medium grey for primary elements
    onPrimary: Color(0xFFE0E0E0), // Light grey for text on primary
    secondary: Color(0xFFCCCCCC), // Light grey for secondary elements
    tertiary: Color(0xFF666666), // Dark grey for tertiary elements
    shadow: Color(0xFF999999), // Mid-grey for shadows
    outline: Color(0xFFBBBBBB), // Light grey for outlines
  ),
);

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
