import 'package:setforge/database/models.dart';

String formatMuscles(dynamic muscles) {
  if (muscles == null) return "";
  final List muscleList = muscles as List;
  return muscleList.map((m) {
    if (m is String && m.isNotEmpty) {
      return m[0].toUpperCase() + m.substring(1);
    }
    return m.toString();
  }).join(", ");
}

List<String> uniqueMuscles(List<Movement> movements) {
  final Set<String> unique = {};

  for (var movement in movements) {
    for (var group in movement.muscleGroups.values) {
      for (var muscle in group as List) {
        unique.add(muscle);
      }
    }
  }

  final uniqueList = unique.toList();
  uniqueList.sort(); // Default is ascending lexicographical order

  return uniqueList;
}

List<Map<String, String?>> generateMuscleOptions(List<Movement> allMovements) {
  final muscles = uniqueMuscles(allMovements);

  final options = <Map<String, String?>>[];

  // Add the 'All' option first
  options.add({'label': 'All', 'image': 'assets/all.png'});

  for (final muscle in muscles) {
    final capitalized = muscle[0].toUpperCase() + muscle.substring(1);
    options.add({
      'label': capitalized,
      'image':
          'assets/${muscle.toLowerCase()}.png', // or whatever naming convention
    });
  }

  return options;
}

List<String> uniqueEquipment(List<Movement> movements) {
  final Set<String> unique = {};

  for (var movement in movements) {
    final equipment = movement.equipment;
    if (equipment != null && equipment.trim().isNotEmpty) {
      unique.add(equipment.trim());
    }
  }

  final uniqueList = unique.toList();
  uniqueList.sort();
  return uniqueList;
}

List<Map<String, String?>> generateEquipmentOptions(
    List<Movement> allMovements) {
  final equipmentList = uniqueEquipment(allMovements);

  final options = <Map<String, String?>>[];

  options.add({'label': 'All', 'image': 'assets/all.png'});

  for (final equipment in equipmentList) {
    if (equipment.isEmpty) continue; // extra safety

    final capitalized = equipment[0].toUpperCase() + equipment.substring(1);
    options.add({
      'label': capitalized,
      'image': 'assets/${equipment.toLowerCase()}.png',
    });
  }

  return options;
}
