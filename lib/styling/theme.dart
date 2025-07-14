import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'colors.dart'; // Import the colors file

final ThemeData macroFactorDarkTheme = ThemeData(
    useMaterial3: true,
    dividerColor: Colors.transparent,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Palette.primaryBackground, // Main page background
    colorScheme: ColorScheme.dark(
      primary: Palette.blue, // Primary color for various components
      secondary: Palette.yellow, // Secondary color for accents
      surface: Palette.primaryBackground, // Surface color (for cards, etc.)
      onSurface: Colors.white, // Text color on surfaces
      onSecondary: Colors.white, // Text color on secondary color
    ),
    textTheme: GoogleFonts.dmSansTextTheme(
      TextTheme(
        headlineLarge: TextStyle(color: Colors.white),
        headlineMedium: TextStyle(color: Colors.white),
        headlineSmall: TextStyle(color: Colors.white),
        titleLarge: TextStyle(color: Colors.white),
        titleMedium: TextStyle(color: Colors.white),
        titleSmall: TextStyle(color: Colors.white),
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
        bodySmall: TextStyle(color: Colors.white),
        labelLarge: TextStyle(color: Colors.white),
        labelMedium: TextStyle(color: Colors.white),
        labelSmall: TextStyle(color: Colors.white),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: Palette.tertiaryBackground, // Button background
        foregroundColor: Colors.white, // Button text color (white)
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Palette.tertiaryBackground, // Input fields background
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Palette.tertiaryBackground),
      ),
    ),
    cardTheme: CardThemeData(
      color: Palette.secondaryBackground, // Cards use secondary background
      elevation: 0,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor:
            Palette.secondaryBackground, // Bottom navigation bar background
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        selectedLabelStyle: const TextStyle(fontSize: 14),
        unselectedLabelStyle: const TextStyle(fontSize: 14)),
    expansionTileTheme:
        ExpansionTileThemeData(backgroundColor: Palette.secondaryBackground),
    listTileTheme: ListTileThemeData(textColor: Colors.white));

final ThemeData macroFactorLightTheme = ThemeData(
    dividerColor: Colors.transparent,
    appBarTheme: AppBarTheme(
        titleTextStyle: TextStyle(color: Colors.black),
        color: Colors.black,
        iconTheme: IconThemeData(color: Colors.black)),
    brightness: Brightness.light,
    scaffoldBackgroundColor: Palette.primaryBackground, // Main page background
    colorScheme: ColorScheme.light(
      primary: Palette.blue, // Primary color for various components
      secondary: Palette.yellow, // Secondary color for accents
      surface: Palette.primaryBackground, // Surface color (for cards, etc.)
      onSurface: Colors.white, // Text color on surfaces
      onSecondary: Colors.white, // Text color on secondary color
    ),
    textTheme: GoogleFonts.dmSansTextTheme(
      TextTheme(
        headlineLarge: TextStyle(color: Colors.black),
        headlineMedium: TextStyle(color: Colors.black),
        headlineSmall: TextStyle(color: Colors.black),
        titleLarge: TextStyle(color: Colors.black),
        titleMedium: TextStyle(color: Colors.black),
        titleSmall: TextStyle(color: Colors.black),
        bodyLarge: TextStyle(color: Colors.black),
        bodyMedium: TextStyle(color: Colors.black),
        bodySmall: TextStyle(color: Colors.black),
        labelLarge: TextStyle(color: Colors.black),
        labelMedium: TextStyle(color: Colors.black),
        labelSmall: TextStyle(color: Colors.black),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: Palette.tertiaryBackground, // Button background
        foregroundColor: Colors.white, // Button text color (white)
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Palette.tertiaryBackground, // Input fields background
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Palette.tertiaryBackground),
      ),
    ),
    cardTheme: CardThemeData(
      color: Palette.secondaryBackground,
      elevation: 0,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor:
            Palette.secondaryBackground, // Bottom navigation bar background
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontSize: 14),
        unselectedLabelStyle: const TextStyle(fontSize: 14)),
    expansionTileTheme:
        ExpansionTileThemeData(backgroundColor: Palette.secondaryBackground),
    listTileTheme:
        ListTileThemeData(textColor: Colors.black, iconColor: Colors.black));
