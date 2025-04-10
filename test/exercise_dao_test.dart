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

  group('Model Conversion Tests', () {
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
    id: 1,
  );
  dbHelper.database;
  MovementDao.instance.insertMovement(testMovement);

    const MethodChannel channel = MethodChannel('plugins.flutter.io/path_provider');
    TestDefaultBinaryMessengerBinding.instance?.defaultBinaryMessenger
    .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      return ".";
    });
    test('Exercise toMap and fromMap', () async {
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
        volume: 300,
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

      final exerciseFromMap = await Exercise.fromMapAsync(map);
      expect(exerciseFromMap.category, equals(exercise.category));
      expect(exerciseFromMap.movement.id, equals(exercise.movement.id));
      expect(exerciseFromMap.workoutId, equals(exercise.workoutId));
      expect(exerciseFromMap.orderIndex, equals(exercise.orderIndex));
      expect(exerciseFromMap.restTime, equals(exercise.restTime));
      expect(exerciseFromMap.notes, equals(exercise.notes));
      expect(exerciseFromMap.date.toIso8601String(), equals(now.toIso8601String()));
      expect(exerciseFromMap.volume, equals(exercise.volume));
    });


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
          id: 1,
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
  });
}
