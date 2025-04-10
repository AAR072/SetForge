
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkoutState {
  final bool isActive;
  final DateTime? startTime;
  final String? currentExercise;
  final int currentSet;
  final Duration? duration;

  WorkoutState({
    this.isActive = false,
    this.startTime,
    this.currentExercise,
    this.currentSet = 0,
    this.duration,
  });

  WorkoutState copyWith({
    bool? isActive,
    DateTime? startTime,
    String? currentExercise,
    int? currentSet,
    Duration? duration,
  }) {
    return WorkoutState(
      isActive: isActive ?? this.isActive,
      startTime: startTime ?? this.startTime,
      currentExercise: currentExercise ?? this.currentExercise,
      currentSet: currentSet ?? this.currentSet,
      duration: duration ?? this.duration,
    );
  }
}

class WorkoutNotifier extends StateNotifier<WorkoutState> {
  WorkoutNotifier() : super(WorkoutState());

  void startWorkout(String exercise) {
    state = WorkoutState(
      isActive: true,
      startTime: DateTime.now(),
      currentExercise: exercise,
      currentSet: 1,
      duration: Duration.zero,
    );
  }

  void endWorkout() {
    state = WorkoutState(isActive: false);
  }

  void updateCurrentExercise(String newExercise) {
    state = state.copyWith(currentExercise: newExercise);
  }

  void incrementSet() {
    state = state.copyWith(currentSet: state.currentSet + 1);
  }

  void updateDuration(Duration newDuration) {
    state = state.copyWith(duration: newDuration);
  }
}

final workoutProvider = StateNotifierProvider<WorkoutNotifier, WorkoutState>((ref) => WorkoutNotifier());
