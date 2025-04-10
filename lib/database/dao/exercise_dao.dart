// lib/database/exercise_dao.dart
import 'package:setforge/database/db_helper.dart';
import 'package:setforge/database/models.dart';

/// A Data Access Object (DAO) for managing [Exercise] entities in the database.
class ExerciseDao {
  // Private constructor
  ExerciseDao._();

  /// Singleton instance of [ExerciseDao].
  static final ExerciseDao instance = ExerciseDao._();

  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  /// Inserts an [Exercise] into the database.
  ///
  /// Parameters:
  /// - [exercise]: The exercise to insert.
  ///
  /// Returns the ID of the newly inserted exercise.
  ///
  /// Throws a [DatabaseException] if the insertion fails.
  Future<int> insertExercise(Exercise exercise) async {
    final db = await _dbHelper.database;
    return await db.insert('Exercise', exercise.toMap());
  }

  /// Retrieves all [Exercise]s from the database.
  ///
  /// Returns a list of [Exercise] objects sorted by date in descending order.
  ///
  /// Throws a [DatabaseException] if the query fails.
  Future<List<Exercise>> getAllExercises() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Exercise',
      orderBy: 'date DESC',
    );
    // Convert each map to a Future<Exercise>, then await them all
    final exercises = await Future.wait(
      maps.map((map) => Exercise.fromMapAsync(map)),
    );

    return exercises;
  }

  /// Retrieves [Exercise]s for a specific workout.
  ///
  /// Parameters:
  /// - [workoutId]: The ID of the workout to fetch exercises for.
  ///
  /// Returns a list of [Exercise] objects sorted by order index.
  ///
  /// Throws a [DatabaseException] if the query fails.
  Future<List<Exercise>> getExercisesForWorkout(int workoutId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Exercise',
      where: 'workout_id = ?',
      whereArgs: [workoutId],
      orderBy: 'order_index ASC',
    );
    // Convert each map to a Future<Exercise>, then await them all
    final exercises = await Future.wait(
      maps.map((map) => Exercise.fromMapAsync(map)),
    );

    return exercises;
  }

  /// Retrieves [Exercise]s for a specific movement.
  ///
  /// Parameters:
  /// - [movementId]: The ID of the movement to fetch exercises for.
  ///
  /// Returns a list of [Exercise] objects sorted by date.dao
  ///
  /// Throws a [DatabaseException] if the query fails.
  Future<List<Exercise>> getExercisesForMovement(int movementId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Exercise',
      where: 'movement_id = ?',
      whereArgs: [movementId],
      orderBy: 'date DESC',
    );
    // Convert each map to a Future<Exercise>, then await them all
    final exercises = await Future.wait(
      maps.map((map) => Exercise.fromMapAsync(map)),
    );

    return exercises;
  }

  /// Updates an [Exercise] in the database.
  ///
  /// Parameters:
  /// - [exercise]: The exercise to update.
  ///
  /// Returns the number of rows affected (1 if successful, 0 otherwise).
  ///
  /// Throws a [DatabaseException] if the update fails.
  Future<int> updateExercise(Exercise exercise) async {
    final db = await _dbHelper.database;
    return await db.update(
      'Exercise',
      exercise.toMap(),
      where: 'id = ?',
      whereArgs: [exercise.id],
    );
  }

  /// Deletes an [Exercise] from the database by its ID.
  ///
  /// Parameters:
  /// - [id]: The ID of the exercise to delete.
  ///
  /// Returns the number of rows affected (1 if successful, 0 otherwise).
  ///
  /// Throws a [DatabaseException] if the deletion fails.
  Future<int> deleteExercise(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'Exercise',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Gets a specific [Exercise] from the database from its ID.
  ///
  /// Returns an empty list if none found
  Future<List<Exercise>> getExercise(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, Object?>> maps = await db.query(
      'Exercise',
      where: 'id = ?',
      whereArgs: [id],
    );

    // Convert each map to a Future<Exercise>, then await them all
    final exercises = await Future.wait(
      maps.map((map) => Exercise.fromMapAsync(map)),
    );

    return exercises;
  }
}
