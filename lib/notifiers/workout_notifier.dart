import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:setforge/database/models.dart'; // Your Workout model

class WorkoutNotifier extends StateNotifier<Workout?> {
  WorkoutNotifier() : super(null);  // null means no active workout

  void startWorkout(Workout workout) {
    state = workout;
  }

  void endWorkout() {
    state = null;
  }

  void updateWorkout(Workout workout) {
    state = workout;
  }

  Workout? get currentWorkout => state;
}
final workoutProvider = StateNotifierProvider<WorkoutNotifier, Workout?>(
  (ref) => WorkoutNotifier(),
);

