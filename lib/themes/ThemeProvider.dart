import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'Themes.dart';

//Method using Provider's notify listeners to store and toggle themes
class Themeprovider extends ChangeNotifier {
  ThemeData _themeData = lightmode;
  ThemeData get themeData => _themeData;
  bool get isDarkMode => _themeData == darkmode;

  //set method to change theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  //method to toggle themes
  void toggleThemes() {
    if (_themeData == lightmode) {
      if (kDebugMode) print("Switched to Dark Mode");
      themeData = darkmode;
    } else {
      if (kDebugMode) print("Switched to Light Mode");
      themeData = lightmode;
    }
  }
}
