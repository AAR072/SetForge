import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static SharedPreferences? _prefs;

  /// Initialize SharedPreferences (must be called before use)
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    if (_prefs?.get("darkMode") == null) {
      var brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
      bool isDarkMode = brightness == Brightness.dark;
      await _prefs?.setBool("darkMode", isDarkMode);
    } else {
      print(_prefs?.get("darkMode"));
    }
    return;
  }

  /// Check if we are in dark mode
  /// Assumes that it is defined
  static bool get isDarkMode {
    final dark = getBoolean("darkMode");
    if (dark == false) {
      return false;
    }
    return true;
  }

  /// Set a string
  static Future<void> setString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  /// Get a string
  static String? getString(String key) {
    return _prefs?.getString(key);
  }

  /// Set an int
  static Future<void> setInt(String key, int value) async {
    await _prefs?.setInt(key, value);
  }

  /// Get an int
  static int? getInt(String key) {
    return _prefs?.getInt(key);
  }

  /// Set a bool
  static Future<void> setBoolean(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  /// Get a bool
  static bool? getBoolean(String key) {
    return _prefs?.getBool(key);
  }

  /// Set a double
  static Future<void> setDouble(String key, double value) async {
    await _prefs?.setDouble(key, value);
  }

  /// Get a double
  static double? getDouble(String key) {
    return _prefs?.getDouble(key);
  }

  /// Set a list of strings
  static Future<void> setStringList(String key, List<String> value) async {
    await _prefs?.setStringList(key, value);
  }

  /// Get a list of strings
  static List<String>? getStringList(String key) {
    return _prefs?.getStringList(key);
  }

  /// Remove a key
  static Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }


  /// Clear all preferences
  static Future<void> clearAll() async {
    await _prefs?.clear();
  }
}
