import 'package:benchy/screens/control_screen.dart';
import 'package:benchy/styling/colors.dart';
import 'package:flutter/material.dart';
import 'package:benchy/database/db_helper.dart';
import 'package:flutter/services.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:benchy/styling/theme.dart';

Future main() async {
  // Init the DB
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  // Removing all rotations
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
    systemNavigationBarContrastEnforced: false,
    systemNavigationBarIconBrightness: Brightness.light, // Ensure icons are visible on dark backgrounds
    statusBarColor: Colors.transparent, // Optionally, make the status bar transparent
    statusBarBrightness: Brightness.dark, // Adjust the status bar brightness for light/dark status bar
  ));
  await DatabaseHelper.instance.database;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Benchy',
        theme: macroFactorTheme,
        home: const ControlScreen(),
    );
  }
}

