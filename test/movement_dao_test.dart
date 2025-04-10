import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:setforge/database/dao/exercise_dao.dart';
import 'package:setforge/database/models.dart';
import 'package:setforge/database/db_helper.dart';
import 'package:setforge/database/dao/workout_dao.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';



void main() {

  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  final dbHelper = DatabaseHelper.instance;
  final workoutDao = WorkoutDao.instance;
  final exerciseDao = ExerciseDao.instance;
  final testMovement = Movement(
    id: 0,
    name: "Bench",
    type: "Weight",
    oneRepMax: 0,
    muscleGroups: {
    'chest': {'importance': 'high', 'target_area': 'upper body'},
    'shoulders': {'importance': 'medium', 'target_area': 'upper body'},
  },
    instructions: "Don't die",
    imageUrl: "/",
    maxWeight: 100,
    maxSessionVolume: 100,
    maxSetVolume: 100,
    equipment: "bench",
    completionCount: 10,
  );

  // Before each test, delete any existing database file so that
  // we start with a fresh copy of the database.
  setUp(() async {
    await dbHelper.deleteDatabaseFile();
    // Reinitialize the database (this will create the tables again)
    await dbHelper.database;
  });


  // After each test, delete the database file.
  tearDown(() async {
  });

  group('Model Conversion Tests', () {
    const MethodChannel channel = MethodChannel('plugins.flutter.io/path_provider');
    TestDefaultBinaryMessengerBinding.instance?.defaultBinaryMessenger
    .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      return ".";
    });
    test('Movement toMap and fromMap', () {
      final muscleGroups = {
      'primary': 'Chest',
      'secondary': 'Triceps',
    };
      final movement = Movement(
        id: 10,
        name: 'Bench Press',
        type: 'Strength',
        oneRepMax: 200.0,
        muscleGroups: muscleGroups,
        instructions: 'Keep your elbows tucked in.',
        imageUrl: 'http://example.com/bench.png',
        maxWeight: 250.0,
        maxSessionVolume: 1000.0,
        maxSetVolume: 250.0,
        equipment: 'Barbell',
        completionCount: 15,
      );

      final map = movement.toMap();
      expect(map['name'], equals(movement.name));
      expect(map['type'], equals(movement.type));
      expect(map['one_rep_max'], equals(movement.oneRepMax));
      // The muscle groups are stored as a JSON string.
      expect(jsonDecode(map['muscleGroups']), equals(muscleGroups));

      final movementFromMap = Movement.fromMap(map);
      expect(movementFromMap.name, equals(movement.name));
      expect(movementFromMap.type, equals(movement.type));
      expect(movementFromMap.oneRepMax, equals(movement.oneRepMax));
      expect(movementFromMap.muscleGroups, equals(muscleGroups));
    });
  });
}
