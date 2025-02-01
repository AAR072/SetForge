// test/database_test.dart
import 'dart:convert';
import 'package:benchy/database/models.dart';
import 'package:benchy/database/db_helper.dart';
import 'package:benchy/database/workout_dao.dart';
import 'package:benchy/database/exercise_dao.dart'; // Import the ExerciseDao
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  sqfliteFfiInit();

  databaseFactory = databaseFactoryFfi;
  final dbHelper = DatabaseHelper.instance;
  final workoutDao = WorkoutDao.instance;

  // Before each test, delete any existing database file so that
  // we start with a fresh copy of the database.
  setUp(() async {
    await dbHelper.deleteDatabaseFile();
    // Reinitialize the database (this will create the tables again)
    await dbHelper.database;
  });

  // After each test, delete the database file.
  tearDown(() async {
    // Optionally, you could clean up the database file here.
  });

  group('Database Integration Tests', () {
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
        movementId: 10,
        workoutId: 1,
        orderIndex: 2,
        restTime: 90,
        notes: 'Focus on form',
        date: now,
        volume: 300.0,
      );

      final map = exercise.toMap();
      expect(map['category'], equals(exercise.category));
      expect(map['movement_id'], equals(exercise.movementId));
      expect(map['workout_id'], equals(exercise.workoutId));
      expect(map['order_index'], equals(exercise.orderIndex));
      expect(map['restTime'], equals(exercise.restTime));
      expect(map['notes'], equals(exercise.notes));
      expect(map['date'], equals(now.toIso8601String()));
      expect(map['volume'], equals(exercise.volume));

      final exerciseFromMap = Exercise.fromMap(map);
      expect(exerciseFromMap.category, equals(exercise.category));
      expect(exerciseFromMap.movementId, equals(exercise.movementId));
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

  group('Exercise DAO Tests', () {
    // Obtain a reference to the ExerciseDao singleton
    final exerciseDao = ExerciseDao.instance;
    // We'll use a consistent DateTime for our tests.
    final now = DateTime.now();

    test('insertExercise returns non-zero id', () async {
      final exercise = Exercise(
        category: 'Strength',
        movementId: 1,
        workoutId: 1,
        orderIndex: 1,
        restTime: 60,
        notes: 'Test exercise insert',
        date: now,
        volume: 100.0,
      );
      final id = await exerciseDao.insertExercise(exercise);
      expect(id, isNonZero);
    });

    test('getAllExercises retrieves all inserted exercises', () async {
      // Insert two exercises
      final exercise1 = Exercise(
        category: 'Strength',
        movementId: 1,
        workoutId: 1,
        orderIndex: 1,
        restTime: 60,
        notes: 'Exercise 1',
        date: now,
        volume: 100.0,
      );
      final exercise2 = Exercise(
        category: 'Cardio',
        movementId: 2,
        workoutId: 2,
        orderIndex: 2,
        restTime: 90,
        notes: 'Exercise 2',
        date: now.subtract(Duration(days: 1)),
        volume: 200.0,
      );
      await exerciseDao.insertExercise(exercise1);
      await exerciseDao.insertExercise(exercise2);
      final exercises = await exerciseDao.getAllExercises();
      expect(exercises.length, greaterThanOrEqualTo(2));
    });

    test('getExercisesForWorkout retrieves exercises sorted by order_index', () async {
      // Insert exercises for workoutId = 10 with out-of-order order indexes.
      final workoutId = 10;
      final exerciseA = Exercise(
        category: 'Strength',
        movementId: 1,
        workoutId: workoutId,
        orderIndex: 2,
        restTime: 60,
        notes: 'Exercise A',
        date: now,
        volume: 150.0,
      );
      final exerciseB = Exercise(
        category: 'Strength',
        movementId: 2,
        workoutId: workoutId,
        orderIndex: 1,
        restTime: 60,
        notes: 'Exercise B',
        date: now,
        volume: 150.0,
      );
      await exerciseDao.insertExercise(exerciseA);
      await exerciseDao.insertExercise(exerciseB);
      final exercises = await exerciseDao.getExercisesForWorkout(workoutId);
      expect(exercises.length, equals(2));
      // Check that they are sorted in ascending order by order_index.
      expect(exercises[0].orderIndex, lessThan(exercises[1].orderIndex));
      expect(exercises[0].notes, equals('Exercise B'));
      expect(exercises[1].notes, equals('Exercise A'));
    });

    test('getExercisesForMovement retrieves exercises sorted by date descending', () async {
      // Insert exercises for movementId = 20 with different dates.
      final movementId = 20;
      final exercise1 = Exercise(
        category: 'Strength',
        movementId: movementId,
        workoutId: 1,
        orderIndex: 1,
        restTime: 60,
        notes: 'Older Exercise',
        date: now.subtract(Duration(days: 2)),
        volume: 120.0,
      );
      final exercise2 = Exercise(
        category: 'Strength',
        movementId: movementId,
        workoutId: 1,
        orderIndex: 2,
        restTime: 60,
        notes: 'Newer Exercise',
        date: now,
        volume: 130.0,
      );
      await exerciseDao.insertExercise(exercise1);
      await exerciseDao.insertExercise(exercise2);
      final exercises = await exerciseDao.getExercisesForMovement(movementId);
      expect(exercises.length, equals(2));
      // The exercises should be sorted by date descending: exercise2 first.
      expect(exercises[0].notes, equals('Newer Exercise'));
      expect(exercises[1].notes, equals('Older Exercise'));
    });

    test('updateExercise modifies an existing exercise', () async {
      final exercise = Exercise(
        category: 'Strength',
        movementId: 3,
        workoutId: 3,
        orderIndex: 1,
        restTime: 60,
        notes: 'Before update',
        date: now,
        volume: 110.0,
      );
      final id = await exerciseDao.insertExercise(exercise);
      // Retrieve the inserted exercise
      final fetchedExercises = await exerciseDao.getExercise(id);
      expect(fetchedExercises, isNotEmpty);
      final insertedExercise = fetchedExercises[0];

      // Update notes and volume
      final updatedExercise = Exercise(
        id: insertedExercise.id,
        category: insertedExercise.category,
        movementId: insertedExercise.movementId,
        workoutId: insertedExercise.workoutId,
        orderIndex: insertedExercise.orderIndex,
        restTime: insertedExercise.restTime,
        notes: 'After update',
        date: insertedExercise.date,
        volume: 150.0,
      );
      final count = await exerciseDao.updateExercise(updatedExercise);
      expect(count, equals(1));

      final updatedList = await exerciseDao.getExercise(id);
      expect(updatedList, isNotEmpty);
      expect(updatedList[0].notes, equals('After update'));
      expect(updatedList[0].volume, equals(150.0));
    });

    test('deleteExercise removes an exercise', () async {
      final exercise = Exercise(
        category: 'Cardio',
        movementId: 4,
        workoutId: 4,
        orderIndex: 1,
        restTime: 90,
        notes: 'To be deleted',
        date: now,
        volume: 200.0,
      );
      final id = await exerciseDao.insertExercise(exercise);
      final countDeleted = await exerciseDao.deleteExercise(id);
      expect(countDeleted, equals(1));

      final fetched = await exerciseDao.getExercise(id);
      expect(fetched, isEmpty);
    });

    test('getExercise retrieves a specific exercise by id', () async {
      final exercise = Exercise(
        category: 'Flexibility',
        movementId: 5,
        workoutId: 5,
        orderIndex: 1,
        restTime: 30,
        notes: 'Specific exercise',
        date: now,
        volume: 80.0,
      );
      final id = await exerciseDao.insertExercise(exercise);
      final fetched = await exerciseDao.getExercise(id);
      expect(fetched, isNotEmpty);
      expect(fetched[0].notes, equals('Specific exercise'));
      expect(fetched[0].movementId, equals(5));
      expect(fetched[0].workoutId, equals(5));
    });
  });
}
