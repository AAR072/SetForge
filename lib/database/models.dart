import 'dart:convert';
import 'dart:ffi';

import 'package:setforge/database/dao/movement_dao.dart'; // For JSON encoding/decoding

class Workout {
  final int? id;
  final String title;
  final DateTime date;
  final String notes;
  final double volume;
  final int? rating;
  final int caloriesBurned;
  List<Exercise> exercises;


  /// The [volume] is in lbs
  /// The [caloriesBurned] are 0 by default;
  Workout({
    this.id,
    this.rating,
    required this.title,
    required this.date,
    required this.volume,
    this.notes = "",
    this.caloriesBurned = 0,
    List<Exercise>? exercises,
  }) : exercises = exercises ?? [];

  // Convert a Workout object into a Map
  Map<String, dynamic> toMap({bool includeId = false})  {
    final map = {
    'title': title,
    'date': date.toIso8601String(),
    'notes': notes,
    'volume': volume,
    'rating': rating,
    'calories_burned': caloriesBurned,
  };
    if (includeId) {
    map['id'] = id as Object;
    }
    return map;
  }

  // Create a Workout object from a Map
  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      id: map['id'],
      title: map['title'],
      date: DateTime.parse(map['date']),
      notes: map['notes'],
      volume: map['volume'],
      rating: map['rating'],
      caloriesBurned: map['calories_burned'],
    );
  }
  Workout copyWith({
    int? id,
    String? title,
    DateTime? date,
    String? notes,
    double? volume,
    int? rating,
    int? caloriesBurned,
    List<Exercise>? exercises,
  }) {
    return Workout(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      volume: volume ?? this.volume,
      rating: rating ?? this.rating,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      exercises: exercises ?? this.exercises,
    );
  }
}

class Movement {
  final String name;
  final String type;
  final double oneRepMax;
  final Map<String, dynamic> muscleGroups;
  final String instructions;
  String imageUrl;
  final double maxWeight;
  final double maxSessionVolume;
  final double maxSetVolume;
  final String equipment;
  final int completionCount;
  final int? id;

  Movement({
    this.id,
    required this.name,
    required this.type,
    required this.oneRepMax,
    required this.muscleGroups,
    required this.instructions,
    this.imageUrl = "",
    required this.maxWeight,
    required this.maxSessionVolume,
    required this.maxSetVolume,
    required this.equipment,
    required this.completionCount,
  });

  // Convert a Movement object into a Map
  Map<String, dynamic> toMap({bool includeId = false}) {
    final map = {
    'name': name,
    'type': type,
    'one_rep_max': oneRepMax,
    'muscleGroups': jsonEncode(muscleGroups),
    'instructions': instructions,
    'imageUrl': imageUrl,
    'maxWeight': maxWeight,
    'maxSessionVolume': maxSessionVolume,
    'maxSetVolume': maxSetVolume,
    'equipment': equipment,
    'completion_count': completionCount,
  };

    if (includeId) {
    map['id'] = id as Object;
  }

    return map;
  }

  // Create a Movement object from a Map
  factory Movement.fromMap(Map<String, dynamic> map) {
    return Movement(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      oneRepMax: map['one_rep_max'],
      muscleGroups: jsonDecode(map['muscleGroups']), // Convert string to JSON
      instructions: map['instructions'],
      imageUrl: map['imageUrl'],
      maxWeight: map['maxWeight'],
      maxSessionVolume: map['maxSessionVolume'],
      maxSetVolume: map['maxSetVolume'],
      equipment: map['equipment'],
      completionCount: map['completion_count'],
    );
  }
}

class Maxes {
  final int? id;
  final int movementId;
  final String metric;
  final double value;
  final DateTime date;

  Maxes({
    this.id,
    required this.movementId,
    required this.metric,
    required this.value,
    required this.date,
  });

  // Convert a Maxes object into a Map
  Map<String, dynamic> toMap({bool includeId = false}) {
    final map = {
      'movement_id': movementId,
      'metric': metric,
      'value': value,
      'date': date.toIso8601String(),
    };
    if (includeId) {
    map['id'] = id as Object;
    }
    return map;
  }

  // Create a Maxes object from a Map
  factory Maxes.fromMap(Map<String, dynamic> map) {
    return Maxes(
      id: map['id'],
      movementId: map['movement_id'],
      metric: map['metric'],
      value: map['value'],
      date: DateTime.parse(map['date']),
    );
  }
}

class Exercise {
  final int? id;
  /// Warmup, Working, Failure, Injury
  final String category;
  final Movement movement;
  final int workoutId;
  final int orderIndex;
  final int restTime;
  final String notes;
  final DateTime date;
  final double volume;
  List<WorkoutSet> sets;

  Exercise({
    this.id,
    required this.category,
    required this.movement,
    required this.workoutId,
    required this.orderIndex,
    required this.restTime,
    required this.notes,
    required this.date,
    required this.volume,
    List<WorkoutSet>? sets,
  }) : sets = sets ?? [];

  // Convert an Exercise object into a Map
  Map<String, dynamic> toMap({bool includeId = false}) {
    final map = {
      'category': category,
      'movement_id': movement.id,
      'workout_id': workoutId,
      'order_index': orderIndex,
      'restTime': restTime,
      'notes': notes,
      'date': date.toIso8601String(),
      'volume': volume,
    };
    if (includeId) {
    map['id'] = id as Object;
    }
    return map;
  }

  // Create an Exercise object from a Map
  static Future<Exercise> fromMapAsync(Map<String, dynamic> map) async {
    final movement = await MovementDao.instance.getMovement(map['movement_id']);
    return Exercise(
      id: map['id'],
      category: map['category'],
      movement: movement[0],
      workoutId: map['workout_id'],
      orderIndex: map['order_index'],
      restTime: map['restTime'],
      notes: map['notes'],
      date: DateTime.parse(map['date']),
      volume: map['volume'],
    );
  }
  Exercise copyWith({
    int? id,
    String? category,
    Movement? movement,
    int? workoutId,
    int? orderIndex,
    int? restTime,
    String? notes,
    DateTime? date,
    double? volume,
    List<WorkoutSet>? sets,
  }) {
    return Exercise(
      id: id ?? this.id,
      category: category ?? this.category,
      movement: movement ?? this.movement,
      workoutId: workoutId ?? this.workoutId,
      orderIndex: orderIndex ?? this.orderIndex,
      restTime: restTime ?? this.restTime,
      notes: notes ?? this.notes,
      date: date ?? this.date,
      volume: volume ?? this.volume,
      sets: sets ?? this.sets,
    );
  }
}

class WorkoutSet {
  final int? id;
  final String notes;
  final int exerciseId;
  final int reps;
  final double weight;
  final double volume;
  final int time;
  final double distance;
  final int rpe;
  final String type;

  WorkoutSet({
    this.id,
    required this.notes,
    required this.exerciseId,
    required this.reps,
    required this.weight,
    required this.volume,
    required this.time,
    required this.distance,
    required this.rpe,
    required this.type
  });

  // Convert a Set object into a Map
  Map<String, dynamic> toMap({bool includeId = false}) {
    final map = {
      'notes': notes,
      'exercise_id': exerciseId,
      'reps': reps,
      'weight': weight,
      'volume': volume,
      'time': time,
      'distance': distance,
      'rpe': rpe,
      'type': type,
    };
    if (includeId) {
    map['id'] = id as Object;
    }
    return map;
  }

  // Create a Set object from a Map
  factory WorkoutSet.fromMap(Map<String, dynamic> map) {
    return WorkoutSet(
      id: map['id'],
      notes: map['notes'],
      exerciseId: map['exercise_id'],
      reps: map['reps'],
      weight: map['weight'],
      volume: map['volume'],
      time: map['time'],
      distance: map['distance'],
      rpe: map['rpe'],
      type: map['type']
    );
  }
   WorkoutSet copyWith({
    int? id,
    String? notes,
    int? exerciseId,
    int? reps,
    double? weight,
    double? volume,
    int? time,
    double? distance,
    int? rpe,
    String? type,
  }) {
    return WorkoutSet(
      id: id ?? this.id,
      notes: notes ?? this.notes,
      exerciseId: exerciseId ?? this.exerciseId,
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      volume: volume ?? this.volume,
      time: time ?? this.time,
      distance: distance ?? this.distance,
      rpe: rpe ?? this.rpe,
      type: type ?? this.type,
    );
  }
}

class WorkoutTemplates {
  final int? id;
  final String title;
  final String notes;
  final List<dynamic> exercises; // Array of exercise IDs with order, sets, reps, etc.

  WorkoutTemplates({
    this.id,
    required this.title,
    required this.notes,
    required this.exercises,
  });

  // Convert a WorkoutTemplates object into a Map
  Map<String, dynamic> toMap({bool includeId = false}) {
    final map = {
      'title': title,
      'notes': notes,
      'exercises': jsonEncode(exercises), // Convert JSON to string
    };
    if (includeId) {
    map['id'] = id as String;
    }
    return map;
  }

  // Create a WorkoutTemplates object from a Map
  factory WorkoutTemplates.fromMap(Map<String, dynamic> map) {
    return WorkoutTemplates(
      id: map['id'],
      title: map['title'],
      notes: map['notes'],
      exercises: jsonDecode(map['exercises']), // Convert string to JSON
    );
  }
}

class Goals {
  final int? id;
  final int movementId;
  final double targetValue;
  final DateTime targetDate;
  final String notes;
  final bool achieved;

  Goals({
    this.id,
    required this.movementId,
    required this.targetValue,
    required this.targetDate,
    required this.notes,
    required this.achieved,
  });

  // Convert a Goals object into a Map
  Map<String, dynamic> toMap({bool includeId = false}) {
    final map = {
      'movement_id': movementId,
      'target_value': targetValue,
      'target_date': targetDate.toIso8601String(),
      'notes': notes,
      'achieved': achieved ? 1 : 0, // Store as integer (1 for true, 0 for false)
    };
    if (includeId) {
    map['id'] = id as Object;
    }
    return map;
  }

  // Create a Goals object from a Map
  factory Goals.fromMap(Map<String, dynamic> map) {
    return Goals(
      id: map['id'],
      movementId: map['movement_id'],
      targetValue: map['target_value'],
      targetDate: DateTime.parse(map['target_date']),
      notes: map['notes'],
      achieved: map['achieved'] == 1, // Convert integer back to boolean
    );
  }
}

class BodyMeasurements {
  final int? id;
  final String name;
  final String unit;
  final String notes;

  BodyMeasurements({
    this.id,
    required this.name,
    required this.unit,
    required this.notes,
  });

  // Convert a BodyMeasurements object into a Map
  Map<String, dynamic> toMap({bool includeId = false}) {
    final map = {
      'name': name,
      'unit': unit,
      'notes': notes,
    };
    if (includeId) {
    map['id'] = id as String;
    }
    return map;
  }

  // Create a BodyMeasurements object from a Map
  factory BodyMeasurements.fromMap(Map<String, dynamic> map) {
    return BodyMeasurements(
      id: map['id'],
      name: map['name'],
      unit: map['unit'],
      notes: map['notes'],
    );
  }
}

class BodyMetrics {
  final int? id;
  final int measurementId;
  final double value;
  final DateTime date;
  final String notes;

  BodyMetrics({
    this.id,
    required this.measurementId,
    required this.value,
    required this.date,
    required this.notes,
  });

  // Convert a BodyMetrics object into a Map
  Map<String, dynamic> toMap({bool includeId = false}) {
    final map = {
      'measurement_id': measurementId,
      'value': value,
      'date': date.toIso8601String(),
      'notes': notes,
    };
    if (includeId) {
    map['id'] = id as Object;
    }
    return map;
  }

  // Create a BodyMetrics object from a Map
  factory BodyMetrics.fromMap(Map<String, dynamic> map) {
    return BodyMetrics(
      id: map['id'],
      measurementId: map['measurement_id'],
      value: map['value'],
      date: DateTime.parse(map['date']),
      notes: map['notes'],
    );
  }
}
