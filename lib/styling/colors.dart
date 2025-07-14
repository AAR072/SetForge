import 'package:setforge/prefs.dart';
import 'package:flutter/material.dart';

class Palette {
  static const Color blue = Color(0xFF0056D4);
  static const Color yellow = Color(0xFFFFC012);
  static const Color green = Color(0xFF4CA479);
  static const Color purple = Color(0xFF937EE7);
  static const Color pink = Color(0xFFFF4D80);
  static const Color red = Color(0xFFFD855F);
  static Color get primaryBackground {
    return SharedPrefsHelper.isDarkMode ? Color(0xFF141413) : Color(0xFFF6F6F6);
  }

  static Color get secondaryBackground {
    return SharedPrefsHelper.isDarkMode ? Color(0xFF1F1F1F) : Colors.white;
  }

  static const Color tertiaryBackground = Color(0xFF333333);

  // #### For switches in the prefs ####
  static Color get inverseThemeColor {
    return SharedPrefsHelper.isDarkMode ? Colors.white : Colors.black;
  }

  static Color get inverseDimThemeColor {
    return SharedPrefsHelper.isDarkMode ? Color(0XFF8A8888) : Color(0XFF8A8888);
  }

  static Color get themeColor {
    return !SharedPrefsHelper.isDarkMode ? Colors.white : Colors.black;
  }

  static Color get inactiveBgColor {
    return SharedPrefsHelper.isDarkMode ? Color(0xFF333333) : Color(0xFFF6F6F6);
  }
}
