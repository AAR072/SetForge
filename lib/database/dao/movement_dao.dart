import 'package:setforge/database/db_helper.dart';
import 'package:setforge/database/models.dart';

/// A Data Access Object (DAO) for managing [Movement] entities in the database.
class MovementDao {
  // Private constructor
  MovementDao._();

  /// Singleton instance of [MovementDao].
  static final MovementDao instance = MovementDao._();

  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  /// Inserts an [Movement] into the database.
  ///
  /// Parameters:
  /// - [Movement]: The Movement to insert.
  ///
  /// Returns the ID of the newly inserted movement.
  ///
  /// Throws a [DatabaseException] if the insertion fails.
  Future<int> insertMovement(Movement movement) async {
    final db = await _dbHelper.database;
    return await db.insert('Movements', movement.toMap());
  }

  /// Retrieves all [Movement]s from the database.
  ///
  /// Returns a list of [Movement] objects sorted by name in ascending order.
  ///
  /// Throws a [DatabaseException] if the query fails.
  Future<List<Movement>> getAllMovements() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Movements',
      orderBy: 'name ASC',
    );
    return List.generate(maps.length, (i) => Movement.fromMap(maps[i]));
  }

  /// Retrieves [Exercise]s for a specific Movement.
  ///
  /// Parameters:
  /// - [movementId]: The Id of the movement to fetch exercises for.
  ///
  /// Returns a list of [Exercise] objects sorted by order index.
  ///
  /// Throws a [DatabaseException] if the query fails.
  Future<List<Exercise>> getMovementsForExercise(int movementId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Exercise',
      where: 'movement_id = ?',
      whereArgs: [movementId],
      orderBy: 'order_index ASC',
    );
    // Convert each map to a Future<Exercise>, then await them all
    final exercises = await Future.wait(
      maps.map((map) => Exercise.fromMapAsync(map)),
    );

    return exercises;
  }

  /// Retrieves [Maxes]s for a specific movement.
  ///
  /// Parameters:
  /// - [movementId]: The ID of the movement to fetch maxes for.
  ///
  /// Returns a list of [maxes] objects sorted by date
  ///
  /// Throws a [DatabaseException] if the query fails.
  Future<List<Maxes>> getMaxesForMovement(int movementId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Maxes',
      where: 'movement_id = ?',
      whereArgs: [movementId],
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) => Maxes.fromMap(maps[i]));
  }

  /// Updates a [Movement] in the database.
  ///
  /// Parameters:
  /// - [Movement]: The movement to update.
  ///
  /// Returns the number of rows affected (1 if successful, 0 otherwise).
  ///
  /// Throws a [DatabaseException] if the update fails.
  Future<int> updateMovement(Movement movement) async {
    final db = await _dbHelper.database;
    return await db.update(
      'Movements',
      movement.toMap(),
      where: 'id = ?',
      whereArgs: [movement.id],
    );
  }

  /// Deletes a [Movement] from the database by its ID.
  ///
  /// Parameters:
  /// - [id]: The ID of the movement to delete.
  ///
  /// Returns the number of rows affected (1 if successful, 0 otherwise).
  ///
  /// Throws a [DatabaseException] if the deletion fails.
  Future<int> deleteMovement(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'Movements',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Gets a specific [Movement] from the database from its ID.
  ///
  /// Returns an empty list if none found
  Future<List<Movement>> getMovement(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, Object?>> maps = await db.query(
      'Movements',
      where: 'id = ?',
      whereArgs: [id],
    );
    return List.generate(maps.length, (i) => Movement.fromMap(maps[i]));
  }
}
