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

  // You can add helper methods to update parts of the workout,
  // but since Workout isn’t immutable, you’ll need to create a new Workout object each time.

  Workout? get currentWorkout => state;
}
final workoutProvider = StateNotifierProvider<WorkoutNotifier, Workout?>(
  (ref) => WorkoutNotifier(),
);

