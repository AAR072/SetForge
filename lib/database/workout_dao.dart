import 'package:benchy/database/db_helper.dart';
import 'package:benchy/database/models.dart';

/// A Data Access Object (DAO) for managing [Workout] entities in the database.
class WorkoutDao {
  // Private constructor
  WorkoutDao._();

  /// Singleton instance of [WorkoutDao].
  static final WorkoutDao instance = WorkoutDao._();

  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  /// Inserts a [Workout] into the database.
  ///
  /// Returns the ID of the newly inserted workout.
  ///
  /// Throws a [DatabaseException] if the insertion fails.
  Future<int> insertWorkout(Workout workout) async {
    final db = await _dbHelper.database;
    return await db.insert('Workouts', workout.toMap());
  }

  /// Retrieves all [Workout]s from the database.
  ///
  /// Returns a list of [Workout] objects.
  ///
  /// Throws a [DatabaseException] if the query fails.
  Future<List<Workout>> getAllWorkouts() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('Workouts');
    return List.generate(maps.length, (i) => Workout.fromMap(maps[i]));
  }

  /// Updates a [Workout] in the database.
  ///
  /// Returns the number of rows affected (1 if successful, 0 otherwise).
  ///
  /// Throws a [DatabaseException] if the update fails.
  Future<int> updateWorkout(Workout workout) async {
    final db = await _dbHelper.database;
    return await db.update(
      'Workouts',
      workout.toMap(),
      where: 'id = ?',
      whereArgs: [workout.id],
    );
  }

  /// Deletes a [Workout] from the database by its ID.
  ///
  /// Returns the number of rows affected (1 if successful, 0 otherwise).
  ///
  /// Throws a [DatabaseException] if the deletion fails.
  Future<int> deleteWorkout(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'Workouts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Gets a specific [Workout] from the database from its ID.
  /// 
  /// Returns an empty list if none found
  Future<List<Workout>> getWorkout(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, Object?>> maps = await db.query(
      'Workouts',
      where: 'id = ?',
      whereArgs: [id],
    );
    return List.generate(maps.length, (i) => Workout.fromMap(maps[i]));
  }
}
