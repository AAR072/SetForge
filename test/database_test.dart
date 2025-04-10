// test/database_test.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:setforge/database/exercise_dao.dart';
import 'package:setforge/database/models.dart';
import 'package:setforge/database/db_helper.dart';
import 'package:setforge/database/workout_dao.dart';
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
      print(workout.toMap());

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

    test('Maxes toMap and fromMap', () {
      final now = DateTime.now();
      final max = Maxes(
        id: 5,
        movementId: 10,
        metric: '1RM',
        value: 220.0,
        date: now,
      );

      final map = max.toMap();
      expect(map['movement_id'], equals(max.movementId));
      expect(map['metric'], equals(max.metric));
      expect(map['value'], equals(max.value));
      expect(map['date'], equals(now.toIso8601String()));

      final maxFromMap = Maxes.fromMap(map);
      expect(maxFromMap.movementId, equals(max.movementId));
      expect(maxFromMap.metric, equals(max.metric));
      expect(maxFromMap.value, equals(max.value));
      expect(maxFromMap.date.toIso8601String(), equals(now.toIso8601String()));
    });

    test('Exercise toMap and fromMap', () {
      final now = DateTime.now();
      final exercise = Exercise(
        id: 3,
        category: 'Strength',
        movement: testMovement,
        workoutId: 1,
        orderIndex: 2,
        restTime: 90,
        notes: 'Focus on form',
        date: now,
        volume: 300.0,
      );

      final map = exercise.toMap();
      expect(map['category'], equals(exercise.category));
      expect(map['movement_id'], equals(exercise.movement.id));
      expect(map['workout_id'], equals(exercise.workoutId));
      expect(map['order_index'], equals(exercise.orderIndex));
      expect(map['restTime'], equals(exercise.restTime));
      expect(map['notes'], equals(exercise.notes));
      expect(map['date'], equals(now.toIso8601String()));
      expect(map['volume'], equals(exercise.volume));

      final exerciseFromMap = Exercise.fromMap(map);
      expect(exerciseFromMap.category, equals(exercise.category));
      expect(exerciseFromMap.movement.id, equals(exercise.movement.id));
      expect(exerciseFromMap.workoutId, equals(exercise.workoutId));
      expect(exerciseFromMap.orderIndex, equals(exercise.orderIndex));
      expect(exerciseFromMap.restTime, equals(exercise.restTime));
      expect(exerciseFromMap.notes, equals(exercise.notes));
      expect(exerciseFromMap.date.toIso8601String(), equals(now.toIso8601String()));
      expect(exerciseFromMap.volume, equals(exercise.volume));
    });

    test('WorkoutSet toMap and fromMap', () {
      final set = WorkoutSet(
        id: 1,
        notes: 'Set notes',
        exerciseId: 3,
        reps: 10,
        weight: 100.0,
        volume: 1000.0,
        time: 60,
        distance: 0.0,
        rpe: 8,
      );

      final map = set.toMap();
      expect(map['notes'], equals(set.notes));
      expect(map['exercise_id'], equals(set.exerciseId));
      expect(map['reps'], equals(set.reps));
      expect(map['weight'], equals(set.weight));
      expect(map['volume'], equals(set.volume));
      expect(map['time'], equals(set.time));
      expect(map['distance'], equals(set.distance));
      expect(map['rpe'], equals(set.rpe));

      final setFromMap = WorkoutSet.fromMap(map);
      expect(setFromMap.notes, equals(set.notes));
      expect(setFromMap.exerciseId, equals(set.exerciseId));
      expect(setFromMap.reps, equals(set.reps));
      expect(setFromMap.weight, equals(set.weight));
      expect(setFromMap.volume, equals(set.volume));
      expect(setFromMap.time, equals(set.time));
      expect(setFromMap.distance, equals(set.distance));
      expect(setFromMap.rpe, equals(set.rpe));
    });

    test('WorkoutTemplates toMap and fromMap', () {
      final template = WorkoutTemplates(
        id: 2,
        title: 'Template 1',
        notes: 'Template notes',
        exercises: [
        {'exerciseId': 1, 'order': 1},
        {'exerciseId': 2, 'order': 2},
        ],
      );

      final map = template.toMap();
      expect(map['title'], equals(template.title));
      expect(map['notes'], equals(template.notes));
      // The exercises are stored as a JSON string.
      expect(jsonDecode(map['exercises']), equals(template.exercises));

      final templateFromMap = WorkoutTemplates.fromMap(map);
      expect(templateFromMap.title, equals(template.title));
      expect(templateFromMap.notes, equals(template.notes));
      expect(templateFromMap.exercises, equals(template.exercises));
    });

    test('Goals toMap and fromMap', () {
      final now = DateTime.now();
      final goal = Goals(
        id: 4,
        movementId: 10,
        targetValue: 220.0,
        targetDate: now,
        notes: 'Increase max weight',
        achieved: false,
      );

      final map = goal.toMap();
      expect(map['movement_id'], equals(goal.movementId));
      expect(map['target_value'], equals(goal.targetValue));
      expect(map['target_date'], equals(now.toIso8601String()));
      expect(map['notes'], equals(goal.notes));
      // Achieved is stored as 0 (false)
      expect(map['achieved'], equals(0));

      final goalFromMap = Goals.fromMap(map);
      expect(goalFromMap.movementId, equals(goal.movementId));
      expect(goalFromMap.targetValue, equals(goal.targetValue));
      expect(goalFromMap.targetDate.toIso8601String(), equals(now.toIso8601String()));
      expect(goalFromMap.notes, equals(goal.notes));
      expect(goalFromMap.achieved, isFalse);
    });

    test('BodyMeasurements toMap and fromMap', () {
      final measurement = BodyMeasurements(
        id: 1,
        name: 'Chest',
        unit: 'inches',
        notes: 'Measured at pectorals',
      );

      final map = measurement.toMap();
      expect(map['name'], equals(measurement.name));
      expect(map['unit'], equals(measurement.unit));
      expect(map['notes'], equals(measurement.notes));

      final measurementFromMap = BodyMeasurements.fromMap(map);
      expect(measurementFromMap.name, equals(measurement.name));
      expect(measurementFromMap.unit, equals(measurement.unit));
      expect(measurementFromMap.notes, equals(measurement.notes));
    });

    test('BodyMetrics toMap and fromMap', () {
      final now = DateTime.now();
      final metric = BodyMetrics(
        id: 1,
        measurementId: 1,
        value: 38.5,
        date: now,
        notes: 'Morning measurement',
      );

      final map = metric.toMap();
      expect(map['measurement_id'], equals(metric.measurementId));
      expect(map['value'], equals(metric.value));
      expect(map['date'], equals(now.toIso8601String()));
      expect(map['notes'], equals(metric.notes));

      final metricFromMap = BodyMetrics.fromMap(map);
      expect(metricFromMap.measurementId, equals(metric.measurementId));
      expect(metricFromMap.value, equals(metric.value));
      expect(metricFromMap.date.toIso8601String(), equals(now.toIso8601String()));
      expect(metricFromMap.notes, equals(metric.notes));
    });
  });
  // Add this group inside the main() function's groups

  group('Exercise DAO Tests', () {
    late Database db;

    setUp(() async {
      db = await dbHelper.database;
    });

    Future<int> createWorkout() async {
      final workout = Workout(
        title: 'Test Workout',
        date: DateTime.now(),
        duration: 60,
        notes: 'Test notes',
        volume: 1000.0,
        rating: 7,
        caloriesBurned: 250,
      );
      return await workoutDao.insertWorkout(workout);
    }

    Future<int> createMovement() async {
      final movement = Movement(
        name: 'Test Movement',
        type: 'Strength',
        oneRepMax: 100.0,
        muscleGroups: {'primary': 'Chest'},
        instructions: 'Test instructions',
        imageUrl: '',
        maxWeight: 100.0,
        maxSessionVolume: 1000.0,
        maxSetVolume: 200.0,
        equipment: 'Barbell',
        completionCount: 0,
      );
      return await db.insert('Movements', movement.toMap());
    }

    test('Inserting and retrieving an Exercise', () async {
      final workoutId = await createWorkout();
      final movementId = await createMovement();

      final exercise = Exercise(
        category: 'Strength',
        movement: testMovement,
        workoutId: workoutId,
        orderIndex: 1,
        restTime: 90,
        notes: 'Test exercise notes',
        date: DateTime.now(),
        volume: 2000.0,
      );

      final insertedId = await exerciseDao.insertExercise(exercise);
      expect(insertedId, isNonZero);

      final exercises = await exerciseDao.getAllExercises();
      expect(exercises.length, 1);

      final retrievedExercise = exercises[0];
      expect(retrievedExercise.category, equals(exercise.category));
      expect(retrievedExercise.movement.id, equals(movementId));
      expect(retrievedExercise.workoutId, equals(workoutId));
    });

    test('getAllExercises returns exercises sorted by date descending', () async {
      final workoutId = await createWorkout();
      final movementId = await createMovement();

      final now = DateTime.now();
      final yesterday = now.subtract(Duration(days: 1));

      await exerciseDao.insertExercise(Exercise(
        category: 'Strength',
        movement: testMovement,
        workoutId: workoutId,
        orderIndex: 1,
        date: yesterday,
        restTime: 90,
        notes: '',
        volume: 1000.0,
      ));

      await exerciseDao.insertExercise(Exercise(
        category: 'Cardio',
        movement: testMovement,
        workoutId: workoutId,
        orderIndex: 2,
        date: now,
        restTime: 120,
        notes: '',
        volume: 2000.0,
      ));

      final exercises = await exerciseDao.getAllExercises();
      expect(exercises[0].date.toIso8601String(), now.toIso8601String());
      expect(exercises[1].date.toIso8601String(), yesterday.toIso8601String());
    });

    test('getExercisesForWorkout returns exercises sorted by order index', () async {
      final workoutId1 = await createWorkout();
      final workoutId2 = await createWorkout();
      final movementId = await createMovement();

      await exerciseDao.insertExercise(Exercise(
        category: 'Strength',
        movement: testMovement,
        workoutId: workoutId1,
        orderIndex: 2,
        restTime: 90,
        notes: '',
        date: DateTime.now(),
        volume: 1000.0,
      ));

      await exerciseDao.insertExercise(Exercise(
        category: 'Strength',
        movement: testMovement,
        workoutId: workoutId1,
        orderIndex: 1,
        restTime: 90,
        notes: '',
        date: DateTime.now(),
        volume: 1000.0,
      ));

      await exerciseDao.insertExercise(Exercise(
        category: 'Cardio',
        movement: testMovement,
        workoutId: workoutId2,
        orderIndex: 1,
        restTime: 60,
        notes: '',
        date: DateTime.now(),
        volume: 800.0,
      ));

      final exercisesWorkout1 = await exerciseDao.getExercisesForWorkout(workoutId1);
      expect(exercisesWorkout1[0].orderIndex, 1);
      expect(exercisesWorkout1[1].orderIndex, 2);
    });

    test('getExercisesForMovement returns exercises sorted by date descending', () async {
      final movementId1 = await createMovement();
      final movementId2 = await createMovement();
      final workoutId = await createWorkout();

      final now = DateTime.now();
      final yesterday = now.subtract(Duration(days: 1));

      await exerciseDao.insertExercise(Exercise(
        category: 'Strength',
        movement: testMovement,
        workoutId: workoutId,
        orderIndex: 1,
        date: yesterday,
        restTime: 90,
        notes: '',
        volume: 1000.0,
      ));

      await exerciseDao.insertExercise(Exercise(
        category: 'Strength',
        movement: testMovement,
        workoutId: workoutId,
        orderIndex: 2,
        date: now,
        restTime: 90,
        notes: '',
        volume: 1000.0,
      ));

      await exerciseDao.insertExercise(Exercise(
        category: 'Cardio',
        movement: testMovement,
        workoutId: workoutId,
        orderIndex: 1,
        date: now,
        restTime: 60,
        notes: '',
        volume: 800.0,
      ));

      final exercisesMovement1 = await exerciseDao.getExercisesForMovement(movementId1);
      expect(exercisesMovement1[0].date.toIso8601String(), now.toIso8601String());
      expect(exercisesMovement1[1].date.toIso8601String(), yesterday.toIso8601String());
    });

    test('updateExercise modifies existing exercise', () async {
      final workoutId = await createWorkout();
      final movementId = await createMovement();

      final exerciseId = await exerciseDao.insertExercise(Exercise(
        category: 'Strength',
        movement: testMovement,
        workoutId: workoutId,
        orderIndex: 1,
        restTime: 90,
        notes: 'Original',
        date: DateTime.now(),
        volume: 1000.0,
      ));

      final rowsUpdated = await exerciseDao.updateExercise(Exercise(
        id: exerciseId,
        category: 'Cardio',
        movement: testMovement,
        workoutId: workoutId,
        orderIndex: 2,
        restTime: 120,
        notes: 'Updated',
        date: DateTime.now().add(Duration(days: 1)),
        volume: 2000.0,
      ));

      expect(rowsUpdated, 1);

      final updatedExercise = (await exerciseDao.getExercise(exerciseId))[0];
      expect(updatedExercise.category, 'Cardio');
      expect(updatedExercise.notes, 'Updated');
    });

    test('deleteExercise removes the exercise', () async {
      final workoutId = await createWorkout();
      final movementId = await createMovement();

      final exerciseId = await exerciseDao.insertExercise(Exercise(
        category: 'Strength',
        movement: testMovement,
        workoutId: workoutId,
        orderIndex: 1,
        restTime: 90,
        notes: '',
        date: DateTime.now(),
        volume: 1000.0,
      ));

      final rowsDeleted = await exerciseDao.deleteExercise(exerciseId);
      expect(rowsDeleted, 1);

      final result = await exerciseDao.getExercise(exerciseId);
      expect(result.isEmpty, isTrue);
    });

    test('getExercise retrieves correct exercise by ID', () async {
      final workoutId1 = await createWorkout();
      final movementId1 = await createMovement();
      final exerciseId1 = await exerciseDao.insertExercise(Exercise(
        category: 'Strength',
        movement: testMovement,
        workoutId: workoutId1,
        orderIndex: 1,
        restTime: 90,
        notes: 'Exercise 1',
        date: DateTime.now(),
        volume: 1000.0,
      ));

      final workoutId2 = await createWorkout();
      final exerciseId2 = await exerciseDao.insertExercise(Exercise(
        category: 'Cardio',
        movement: testMovement,
        workoutId: workoutId2,
        orderIndex: 1,
        restTime: 60,
        notes: 'Exercise 2',
        date: DateTime.now(),
        volume: 800.0,
      ));

      final result1 = await exerciseDao.getExercise(exerciseId1);
      expect(result1[0].id, exerciseId1);

      final result2 = await exerciseDao.getExercise(exerciseId2);
      expect(result2[0].id, exerciseId2);
    });
  });
}
