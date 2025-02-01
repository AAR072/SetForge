import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:benchy/database/models.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('benchy.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
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
  /// Inserts a [workout]
  /// Example: 
  /// ```dart
  /// final workout = Workout(
  /// id: null, // Auto-incremented by the database
  /// title: 'Morning Workout',
  /// date: DateTime.now().millisecondsSinceEpoch 
  /// duration: 60,
  /// notes: 'Great session!',
  /// volume: 1500.0,
  /// rating: 9,
  /// caloriesBurned: 300,
  /// );
  /// final id = await DatabaseHelper.instance.insertWorkout(workout);
  /// print('Inserted workout with ID: $id');
  /// ```
  Future<int> insertWorkout(Workout workout) async {
    final db = await database;
    return await db.insert('Workouts', workout.toMap());
  }

  /// Returns a [List] of all the user's [Workout]s 
  /// Ex:
  /// ```dart
  /// final workouts = await DatabaseHelper.instance.getAllWorkouts();
  /// workouts.forEach((workout) {
  /// print('Workout: ${workout.title}, Date: ${workout.date}');
  /// });
  /// ```
Future<List<Workout>> getAllWorkouts() async {
  final db = await database;
  final List<Map<String, dynamic>> maps = await db.query('Workouts');

  return List.generate(maps.length, (i) {
    return Workout(
      id: maps[i]['id'],
      title: maps[i]['title'],
      date: DateTime.tryParse(maps[i]['date']) ?? DateTime(1970, 1, 1), // Fixed here
      duration: maps[i]['duration'],
      notes: maps[i]['notes'],
      volume: maps[i]['volume'],
      rating: maps[i]['rating'],
      caloriesBurned: maps[i]['calories_burned'],
    );
  });
}
Future<void> deleteDatabaseFile() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'benchy.db');

  // Close the existing database connection
  if (_database != null) {
    await _database!.close();
    _database = null;
  }

  // Delete the database file
  await deleteDatabase(path);
}
}
