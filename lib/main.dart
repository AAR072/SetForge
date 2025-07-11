import 'package:setforge/database/dao/movement_dao.dart';
import 'package:setforge/database/models.dart';
import 'package:setforge/prefs.dart';
import 'package:setforge/router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:setforge/database/db_helper.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:setforge/styling/theme.dart';
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
  await DatabaseHelper.instance.deleteDatabaseFile();
  await DatabaseHelper.instance.database;

  await SharedPrefsHelper.init();
    runApp(
    Phoenix(
      child: ProviderScope(child:
      MyApp(),
      )
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SetForge',
      theme: SharedPrefsHelper.isDarkMode? macroFactorDarkTheme : macroFactorLightTheme,
      routerConfig: router,
    );
  }
}

