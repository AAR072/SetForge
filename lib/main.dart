import 'package:benchy/prefs.dart';
import 'package:benchy/router.dart';
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
    // Make the bar transparent
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarContrastEnforced: false,
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.dark,
  ));
  await DatabaseHelper.instance.database;
  await SharedPrefsHelper.init();
  print(SharedPrefsHelper.setBoolean("darkMode", true));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Benchy',
      theme: SharedPrefsHelper.isDarkMode? macroFactorDarkTheme : macroFactorLightTheme,
      routerConfig: router,
    );
  }
}

