import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:setforge/database/dao/exercise_dao.dart';
import 'package:setforge/database/dao/movement_dao.dart';
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
  MovementDao.instance.insertMovement(testMovement);
  // Before each test, delete any existing database file so that
  // we start with a fresh copy of the database.
  setUp(() async {
    await dbHelper.database;
    // Reinitialize the database (this will create the tables again)
  });


  // After each test, delete the database file.
  tearDown(() async {
    await dbHelper.deleteDatabaseFile();
  });

  group('Database Integration Tests', () {
    const MethodChannel channel = MethodChannel('plugins.flutter.io/path_provider');
TestDefaultBinaryMessengerBinding.instance?.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
    return ".";
  });
    test('Inserting and retrieving a Workout', () async {
      // Create a Workout instance
      final now = DateTime.now();
      final workout = Workout(
        title: 'Test Workout',
        date: now,
        duration: 60,
        notes: 'Test notes',
        volume: 1000.0,
        rating: 7,
        caloriesBurned: 250,
      );

      // Insert the workout into the database
      final insertedId = await workoutDao.insertWorkout(workout);
      expect(insertedId, isNonZero);

      // Retrieve all workouts from the database
      final workouts = await workoutDao.getAllWorkouts();
      expect(workouts, isNotEmpty);

      final garbageWorkout = Workout(
        title: 'Garbage Workout',
        date: now,
        duration: 60,
        notes: 'Garbage notes',
        volume: 1000.0,
        rating: 7,
        caloriesBurned: 250,
      );

      await workoutDao.insertWorkout(garbageWorkout);

      final results = await workoutDao.getWorkout(1);
      final retrievedWorkout = results[0];
      expect(retrievedWorkout.title, equals(workout.title));
      expect(retrievedWorkout.duration, equals(workout.duration));
      expect(retrievedWorkout.notes, equals(workout.notes));
      expect(retrievedWorkout.volume, equals(workout.volume));
      expect(retrievedWorkout.rating, equals(workout.rating));
      expect(retrievedWorkout.caloriesBurned, equals(workout.caloriesBurned));
      // Because of type conversion (storing dates as ISO strings vs integers), you may want to compare dates
      expect(
        retrievedWorkout.date.toIso8601String(),
        equals(workout.date.toIso8601String()),
      );
    });
  });

  group('Model Conversion Tests', () {
    const MethodChannel channel = MethodChannel('plugins.flutter.io/path_provider');
TestDefaultBinaryMessengerBinding.instance?.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
    return ".";
  });
    test('Workout toMap and fromMap', () {
      final now = DateTime.now();
      final workout = Workout(
        id: 1,
        title: 'Morning Workout',
        date: now,
        duration: 45,
        notes: 'Felt great!',
        volume: 500.0,
        rating: 8,
        caloriesBurned: 300,
      );

      final map = workout.toMap();
      // When converting to map, the date becomes an ISO8601 string.
      expect(map['title'], workout.title);
      expect(map['duration'], workout.duration);
      expect(map['notes'], workout.notes);
      expect(map['volume'], workout.volume);
      expect(map['rating'], workout.rating);
      expect(map['calories_burned'], workout.caloriesBurned);
      expect(map['date'], workout.date.toIso8601String());

      // Convert back to a Workout instance.
      final workoutFromMap = Workout.fromMap(map);
      expect(workoutFromMap.title, equals(workout.title));
      expect(workoutFromMap.duration, equals(workout.duration));
      expect(workoutFromMap.notes, equals(workout.notes));
      expect(workoutFromMap.volume, equals(workout.volume));
      expect(workoutFromMap.rating, equals(workout.rating));
      expect(workoutFromMap.caloriesBurned, equals(workout.caloriesBurned));
      expect(
        workoutFromMap.date.toIso8601String(),
        equals(workout.date.toIso8601String()),
      );
    });
  });
}
