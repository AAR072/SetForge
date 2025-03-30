// theme.dart
import 'package:flutter/material.dart';
import 'colors.dart'; // Import the colors file

final ThemeData macroFactorTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: primaryBackground, // Main page background
  colorScheme: ColorScheme.dark(
    primary: blue, // Primary color for various components
    secondary: yellow, // Secondary color for accents
    surface: purple, // Surface color (for cards, etc.)
    onSurface: Colors.white, // Text color on surfaces
    onSecondary: Colors.white, // Text color on secondary color
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: secondaryBackground, // AppBar background color
    iconTheme: IconThemeData(color: Colors.white), // AppBar icon color
  ),
  textTheme: TextTheme(
    headlineLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
    bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
    bodyMedium: TextStyle(fontSize: 14, color: Colors.white), // Slightly lighter text
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: tertiaryBackground, // Button background
      foregroundColor: Colors.white, // Button text color (white)
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: tertiaryBackground, // Input fields background
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: tertiaryBackground),
    ),
  ),
  cardTheme: CardTheme(
    color: secondaryBackground, // Cards use secondary background
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: tertiaryBackground, // Bottom navigation bar background
    selectedItemColor: blue,
    unselectedItemColor: Colors.white70,
  ),
  expansionTileTheme: ExpansionTileThemeData(
    backgroundColor: secondaryBackground
  ),
);
