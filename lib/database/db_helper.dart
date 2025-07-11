import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path_provider_linux/path_provider_linux.dart';
import 'package:setforge/database/dao/movement_dao.dart';
import 'package:setforge/database/movement_population.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    final movements = await loadAllMovementsFromAssets();
    print('Loaded ${movements.length} movements.');
    if (_database != null) return _database!;
    _database = await _initDB('setforge.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    if (Platform.isLinux) PathProviderLinux.registerWith();
    final dbPath = await getApplicationDocumentsDirectory();
    final path = join(dbPath.path, filePath);
      // Check if the directory exists, if not, create it
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Get a list of all table names
    List<Map<String, dynamic>> tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'");

    // Drop each table
    for (var table in tables) {
    String tableName = table['name'];
    await db.execute("DROP TABLE IF EXISTS $tableName");
  }
    // Create Workouts table
    await db.execute('''
      CREATE TABLE Workouts (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      date INTEGER NOT NULL,
      duration INTEGER NOT NULL,
      notes TEXT,
      volume REAL,
      rating INTEGER,
      calories_burned INTEGER
      )
      ''');

    // Create Movements table
    await db.execute('''
      CREATE TABLE Movements (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      type TEXT NOT NULL,
      one_rep_max REAL,
      muscleGroups TEXT,
      instructions TEXT,
      imageUrl TEXT,
      maxWeight REAL,
      maxSessionVolume REAL,
      maxSetVolume REAL,
      equipment TEXT,
      completion_count INTEGER
      )
      ''');

    // Create Maxes table
    await db.execute('''
      CREATE TABLE Maxes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      movement_id INTEGER NOT NULL,
      metric TEXT NOT NULL,
      value REAL NOT NULL,
      date INTEGER NOT NULL,
      FOREIGN KEY (movement_id) REFERENCES Movements (id) ON DELETE CASCADE
      )
      ''');

    // Create Exercise table
    await db.execute('''
      CREATE TABLE Exercise (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      category TEXT NOT NULL,
      movement_id INTEGER NOT NULL,
      workout_id INTEGER NOT NULL,
      order_index INTEGER NOT NULL,
      restTime INTEGER,
      notes TEXT,
      date INTEGER NOT NULL,
      volume REAL,
      FOREIGN KEY (movement_id) REFERENCES Movements (id) ON DELETE CASCADE,
      FOREIGN KEY (workout_id) REFERENCES Workouts (id) ON DELETE CASCADE
      )
      ''');

    // Create Set table
    await db.execute('''
      CREATE TABLE WorkoutSet(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      notes TEXT,
      exercise_id INTEGER NOT NULL,
      reps INTEGER,
      weight REAL,
      volume REAL,
      time INTEGER,
      distance REAL,
      rpe INTEGER,
      FOREIGN KEY (exercise_id) REFERENCES Exercise (id) ON DELETE CASCADE
      )
      ''');

    // Create WorkoutTemplates table
    await db.execute('''
      CREATE TABLE WorkoutTemplates (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      notes TEXT,
      exercises TEXT NOT NULL
      )
      ''');

    // Create Goals table
    await db.execute('''
      CREATE TABLE Goals (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      movement_id INTEGER NOT NULL,
      target_value REAL NOT NULL,
      target_date INTEGER NOT NULL,
      notes TEXT,
      achieved INTEGER NOT NULL DEFAULT 0, -- 0 for false, 1 for true
      FOREIGN KEY (movement_id) REFERENCES Movements (id) ON DELETE CASCADE
      )
      ''');

    // Create BodyMeasurements table
    await db.execute('''
      CREATE TABLE BodyMeasurements (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      unit TEXT NOT NULL,
      notes TEXT
      )
      ''');

    // Create BodyMetrics table
    await db.execute('''
      CREATE TABLE BodyMetrics (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      measurement_id INTEGER NOT NULL,
      value REAL NOT NULL,
      date INTEGER NOT NULL,
      notes TEXT,
      FOREIGN KEY (measurement_id) REFERENCES BodyMeasurements (id) ON DELETE CASCADE
      )
      ''');
  }
/// Deletes the entire [Database]. It must be reinitialized with a getter.
Future<void> deleteDatabaseFile() async {
  final dbPath = await getApplicationDocumentsDirectory();
  final path = join(dbPath.path, 'setforge.db');

  // Close the existing database connection
  if (_database != null) {
    await _database!.close();
    _database = null;
  }

  // Delete the database file
  await deleteDatabase(path);
}
}
