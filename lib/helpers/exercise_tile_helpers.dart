import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:setforge/database/models.dart';
import 'package:setforge/helpers/session_helpers.dart';
import 'package:setforge/notifiers/workout_notifier.dart';
import 'package:setforge/styling/colors.dart';

void showExerciseMenu({
  required BuildContext context,
  required WidgetRef ref,
  required Exercise exercise,
  required int exerciseIndex,
}) {
  final workoutNotifier = ref.read(workoutProvider.notifier);
  final workout = ref.read(workoutProvider);
  if (workout == null) return;

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.swap_horiz),
                title: const Text("Replace Exercise"),
                onTap: () {
                  Navigator.of(context).pop();
                  // No-op for now
                },
              ),
              ListTile(
                leading: const Icon(Icons.drag_handle),
                title: const Text("Reorder Exercise"),
                onTap: () {
                  Navigator.of(context).pop();
                  // No-op for now
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Palette.red),
                title: const Text(
                  "Remove Exercise",
                  style: TextStyle(color: Palette.red),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  final updatedExercises = List<Exercise>.from(workout.exercises)
                    ..removeAt(exerciseIndex);
                  final updatedWorkout = workout.copyWith(exercises: updatedExercises);
                  workoutNotifier.updateWorkout(updatedWorkout);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

void handleNotesChanged({
  required WidgetRef ref,
  required Exercise exercise,
  required String newNotes,
}) {
  final workoutNotifier = ref.read(workoutProvider.notifier);
  final workout = ref.read(workoutProvider);

  if (workout == null) return;

  final updatedExercise = exercise.copyWith(notes: newNotes);

  final updatedExercises = workout.exercises.map((ex) {
    return ex.id == exercise.id ? updatedExercise : ex;
  }).toList();

  final updatedWorkout = workout.copyWith(exercises: updatedExercises);

  workoutNotifier.updateWorkout(updatedWorkout);
}

Future<void> handleRestTimerPressed({
  required BuildContext context,
  required WidgetRef ref,
  required Exercise exercise,
}) async {
  final selected = await showModalBottomSheet<int>(
    context: context,
    builder: (context) {
      int tempRestTime = exercise.restTime;
      return SafeArea(
        child: Container(
          height: 200,
          child: Column(
            children: [
              const SizedBox(height: 12),
              const Text(
                "Select Rest Time (seconds)",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              Expanded(
                child: CupertinoPicker(
                  scrollController:
                      FixedExtentScrollController(
                    initialItem: exercise.restTime ~/ 5,
                  ),
                  itemExtent: 50,
                  onSelectedItemChanged: (index) {
                    tempRestTime = index * 5;
                  },
                  children: List.generate(241, (index) {
                    final totalSeconds = index * 5;
                    final formatted =
                        secondsParser(totalSeconds);

                    return Center(child: Text(formatted));
                  }),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(tempRestTime);
                },
                child: const Text("Done"),
              ),
            ],
          ),
        ),
      );
    },
  );

  if (selected == null) return;

  final workoutNotifier =
      ref.read(workoutProvider.notifier);
  final workout = ref.read(workoutProvider);
  if (workout == null) return;

  final updatedExercise =
      exercise.copyWith(restTime: selected);
  final updatedExercises = workout.exercises.map((ex) {
    return ex.id == exercise.id ? updatedExercise : ex;
  }).toList();

  final updatedWorkout =
      workout.copyWith(exercises: updatedExercises);
  workoutNotifier.updateWorkout(updatedWorkout);
}


void handleSetChanged({
  required WidgetRef ref,
  required Exercise exercise,
  required int setIndex,
  required WorkoutSet updatedSet,
}) {
  final workoutNotifier = ref.read(workoutProvider.notifier);
  final workout = ref.read(workoutProvider);

  if (workout == null) return;

  final updatedSets = List<WorkoutSet>.from(exercise.sets);
  updatedSets[setIndex] = updatedSet;

  final updatedExercise = exercise.copyWith(sets: updatedSets);

  final updatedExercises = workout.exercises
      .map((ex) => ex.id == exercise.id ? updatedExercise : ex)
      .toList();

  final updatedWorkout = workout.copyWith(exercises: updatedExercises);
  workoutNotifier.updateWorkout(updatedWorkout);
}

void handleAddSet({
  required WidgetRef ref,
  required Exercise exercise,
}) {
  final workoutNotifier = ref.read(workoutProvider.notifier);
  final workout = ref.read(workoutProvider);

  if (workout == null) return;

  final newSet = WorkoutSet(
    notes: "",
    completed: false,
    id: generateTempId(),
    exerciseId: exercise.id ?? 0,
    reps: 0,
    weight: 0,
    time: 0,
    distance: 0,
    rpe: 0,
    type: "working",
  );

  final updatedSets = List<WorkoutSet>.from(exercise.sets)..add(newSet);

  final updatedExercise = exercise.copyWith(sets: updatedSets);

  final updatedExercises = workout.exercises
      .map((ex) => ex.id == exercise.id ? updatedExercise : ex)
      .toList();

  final updatedWorkout = workout.copyWith(exercises: updatedExercises);
  workoutNotifier.updateWorkout(updatedWorkout);
}

void handleDeleteSet({
  required WidgetRef ref,
  required Exercise exercise,
  required int setIndex,
}) {
  final workoutNotifier = ref.read(workoutProvider.notifier);
  final workout = ref.read(workoutProvider);

  if (workout == null) return;

  final updatedSets = List<WorkoutSet>.from(exercise.sets)..removeAt(setIndex);

  final updatedExercise = exercise.copyWith(sets: updatedSets);

  final updatedExercises = workout.exercises
      .map((ex) => ex.id == exercise.id ? updatedExercise : ex)
      .toList();

  final updatedWorkout = workout.copyWith(exercises: updatedExercises);
  workoutNotifier.updateWorkout(updatedWorkout);
}


Future<void> handleAddExercisesPressed({
  required BuildContext context,
  required WidgetRef ref,
  required Workout workout,
}) async {
  final workoutNotifier = ref.read(workoutProvider.notifier);

  final result = await context.push<List<Movement>>('/select-exercises');

  if (result != null && result.isNotEmpty) {
    final updatedExercises = List.of(workout.exercises);

    for (var i = 0; i < result.length; i++) {
      final movement = result[i];

      updatedExercises.add(
        Exercise(
          id: generateTempId(),
          category: "Working",
          movement: movement,
          workoutId: workout.id ?? 0,
          orderIndex: updatedExercises.length,
          restTime: 60,
          notes: "",
          date: DateTime.now(),
          volume: 0,
        ),
      );
    }

    final updatedWorkout = workout.copyWith(exercises: updatedExercises);
    workoutNotifier.updateWorkout(updatedWorkout);
  }
}
