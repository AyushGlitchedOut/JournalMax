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
      themeData = darkmode;
    } else {
      themeData = lightmode;
    }
  }
}
