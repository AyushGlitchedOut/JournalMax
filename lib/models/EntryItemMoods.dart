import 'package:flutter/material.dart';

//The model for the Moods Feature of the Application
final class EntryItemMoods {
  //The function to convert the String representation of colors into the corresponding List of color schemes
  static Map<String, Color> nameToColor(String name) {
    switch (name) {
      case "Neutral":
        return neutral;
      case "Happy":
        return happy;
      case "Sad":
        return sad;
      case "Angry":
        return angry;
      case "Excited":
        return excited;
      case "Mundane":
        return mundane;
      case "Surprised":
        return surprised;
      case "Frustrated":
        return frustrated;
      case "Doubtful":
        return doubtful;
      case "Anxious":
        return anxious;
      default:
        return neutral;
    }
  }
  //Neutral is the default one, black and white, used as the basic and default if nothing is selected

  //String list of all the implemented moods
  static List<String> moods = [
    "Neutral",
    "Happy",
    "Sad",
    "Angry",
    "Excited",
    "Mundane",
    "Surprised",
    "Frustrated",
    "Doubtful",
    "Anxious"
  ];

  //definition of all mood-based color schemes as Maps of String and Color including a surface
  //a text and a secondary for things like borders
  static Map<String, Color> neutral = {
    "surface": Colors.white,
    "text": Colors.black,
    "secondary": Colors.grey
  };

  static Map<String, Color> angry = {
    "surface": Colors.red.shade200,
    "text": Colors.blue.shade800,
    "secondary": Colors.purple.shade900
  };

  static Map<String, Color> sad = {
    "surface": Colors.blueGrey.shade300,
    "text": Colors.blue.shade600,
    "secondary": Colors.indigo.shade900
  };

  static Map<String, Color> happy = {
    "surface": Colors.yellow[900]!,
    "text": Colors.blue.shade800,
    "secondary": Colors.green.shade700
  };

  static Map<String, Color> excited = {
    "surface": Colors.orange.shade300,
    "text": Colors.deepOrange.shade600,
    "secondary": Colors.redAccent.shade700
  };

  static Map<String, Color> mundane = {
    "surface": Colors.grey.shade300,
    "text": Colors.black87,
    "secondary": Colors.brown.shade700
  };

  static Map<String, Color> surprised = {
    "surface": Colors.purple.shade200,
    "text": Colors.indigo.shade700,
    "secondary": Colors.deepPurple.shade900
  };

  static Map<String, Color> frustrated = {
    "surface": Colors.redAccent.shade100,
    "text": Colors.red.shade700,
    "secondary": Colors.deepOrange.shade900
  };

  static Map<String, Color> doubtful = {
    "surface": Colors.blueGrey.shade200,
    "text": Colors.blue.shade700,
    "secondary": Colors.indigo.shade900
  };

  static Map<String, Color> anxious = {
    "surface": Colors.orange.shade100,
    "text": Colors.brown.shade800,
    "secondary": Colors.red.shade700
  };
}
