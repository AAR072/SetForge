import 'dart:convert';

import 'package:setforge/database/models.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<List<Movement>> loadAllMovementsFromAssets() async {
  final List<Movement> movements = [];

  // Load index.json to get all exercise filenames
  final indexJson = await rootBundle.loadString('assets/exercises/index.json');
  final List<dynamic> fileNamesDynamic = jsonDecode(indexJson);
  final List<String> fileNames = List<String>.from(fileNamesDynamic);

  for (final fileName in fileNames) {
    final jsonString =
        await rootBundle.loadString('assets/exercises/$fileName');
    final Map<String, dynamic> data = jsonDecode(jsonString);
  String imagePath = '';
    if (data['images'] != null && data['images'].isNotEmpty) {
      imagePath = 'assets/images/${data['images'][0]}';
    }

    Movement movement = Movement(
      name: data['name'] ?? '',
      type: data['force'] ?? '',
      oneRepMax: 0,
      muscleGroups: {
        'primary': List<String>.from(data['primaryMuscles'] ?? []),
        'secondary': List<String>.from(data['secondaryMuscles'] ?? []),
      },
      instructions: (data['instructions'] as List<dynamic>?)?.join('\n') ?? '',
      imageUrl: imagePath,
      maxWeight: 0,
      maxSessionVolume: 0,
      maxSetVolume: 0,
      equipment: data['equipment'] ?? '',
      completionCount: 0,
    );

    movements.add(movement);
  }

  return movements;
}
