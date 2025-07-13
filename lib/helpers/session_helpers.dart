// This computes the time elapsed since a date
// and makes it human readable
import 'package:setforge/database/models.dart';

String timeConverter(DateTime start) {
  final now = DateTime.now();
  final duration = now.difference(start);

  if (duration.inHours > 24) {
    // Special case: cap display and show 24h+
    return "24h+";
  }

  final hours = duration.inHours;
  final minutes = duration.inMinutes % 60;
  final seconds = duration.inSeconds % 60;

  if (hours == 0 && minutes == 0) {
    return "${seconds}sec";
  }

  final buffer = StringBuffer();

  if (hours > 0) {
    buffer.write("${hours}h ");
  }

  if (minutes > 0 || hours > 0) {
    buffer.write("${minutes}min ");
  }

  buffer.write("${seconds}sec");

  return buffer.toString().trim();
}

String createWorkoutTitle(DateTime dateTime) {
  final hour = dateTime.hour;

  if (hour >= 21 || hour <= 2) {
    return 'Late Night Workout 😴';
  } else if (hour >= 3 && hour <= 9) {
    return 'Early Morning Workout 🫩';
  } else if (hour >= 10 && hour <= 17) {
    return 'Mid Day Workout 😃';
  } else if (hour >= 18 && hour <= 20) {
    return 'Evening Workout 🥱';
  } else {
    return 'Workout 🏋️'; // fallback, shouldn't hit
  }
}

double calculateTotalVolume(Workout workout) {
  double totalVolume = 0;
  for (var exercise in workout.exercises) {
    for (var set in exercise.sets?? []) { // Use workoutSets property from Exercise
      totalVolume += (set.reps * set.weight);
    }
  }
  return totalVolume;
}

int calculateTotalSets(Workout workout) {
  int totalSets = 0;
  for (var exercise in workout.exercises) {
    totalSets += (exercise.sets?.length ?? 0);
  }
  return totalSets;
}
int generateTempId() => DateTime.now().microsecondsSinceEpoch;

String formatWeight(double weight) {
  if (weight == 0) return '';

  // If it’s a whole number, drop the .0
  if (weight % 1 == 0) {
    return weight.toInt().toString();
  }

  // Else, keep decimals up to 2 if you want
  return weight.toString();
}

