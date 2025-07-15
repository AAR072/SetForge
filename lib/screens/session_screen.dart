import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:setforge/helpers/session_helpers.dart';
import 'package:setforge/notifiers/workout_notifier.dart';
import 'package:setforge/database/models.dart'; // For Workout
import 'package:setforge/styling/colors.dart';
import 'package:setforge/widgets/workout/duration_text.dart';
import 'package:setforge/widgets/workout/exercise_tile.dart';

class SessionScreen extends ConsumerStatefulWidget {
  const SessionScreen({super.key});

  @override
  ConsumerState<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends ConsumerState<SessionScreen> {
  void _showExerciseMenu(BuildContext context, Exercise exercise, int exerciseIndex) {
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
                  leading: const Icon(Icons.swap_horiz), // placeholder icon
                  title: const Text("Replace Exercise"),
                  onTap: () {
                    Navigator.of(context).pop();
                    // No-op for now
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.drag_handle), // placeholder icon
                  title: const Text("Reorder Exercise"),
                  onTap: () {
                    Navigator.of(context).pop();
                    // No-op for now
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete, color: Palette.red,), // placeholder icon, change later
                  title: const Text(
                    "Remove Exercise",
                    style: TextStyle(color: Palette.red)),
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


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final workoutNotifier = ref.read(workoutProvider.notifier);
      final workout = ref.read(workoutProvider);

      if (workout == null) {
        final initialWorkout = Workout(
          id: null,
          title: createWorkoutTitle(DateTime.now()),
          date: DateTime.now(),
          volume: 0,
          exercises: [],
        );
        workoutNotifier.startWorkout(initialWorkout);
      }
    });

  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final workout = ref.watch(workoutProvider);
    final workoutNotifier = ref.read(workoutProvider.notifier);

    if (workout == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Palette.secondaryBackground,
          title: const Text("No Active Workout"),
        ),
        body: const Center(
          child: Text("No workout in progress."),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.secondaryBackground,
        elevation: 0,
        centerTitle: false,
        toolbarHeight: 60,
        surfaceTintColor: Colors.transparent,
        leadingWidth: 200,
        leading: Row(
          children: [
            const SizedBox(width: 4),
            Transform.translate(
              offset: const Offset(0, -4),
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.keyboard_arrow_left_sharp),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                splashRadius: 20,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              "Log Workout",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 16,
                color: Palette.inverseThemeColor,
              ),
            ),
          ],
        ),
        title: const SizedBox(),
        actions: [
          IconButton(
            onPressed: () {
              // Timer or other functionality here
            },
            icon: const Icon(Icons.alarm_sharp),
            splashRadius: 20,
            padding: const EdgeInsets.symmetric(horizontal: 8),
          ),
          TextButton(
            onPressed: () {
              workoutNotifier.endWorkout();
              Navigator.of(context).pop();
            },
            child: Text(
              "Finish",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            style: TextButton.styleFrom(
              minimumSize: const Size(75, 35),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              backgroundColor: Palette.blue,
            ),
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(74), // a bit taller to fit lines
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top thin line
              Container(
                height: 1,
                color: Palette.inverseThemeColor
                .withOpacity(0.2), // subtle line color
              ),

              // Your existing bar container
              Container(
                color: Palette.primaryBackground,
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Duration block
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Duration",
                            style: TextStyle(
                              fontSize: 14,
                              color: Palette.inverseThemeColor.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 4),
                          DurationText(startTime: workout.date),
                        ],
                      ),
                    ),
                    // Volume block
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Volume",
                            style: TextStyle(
                              fontSize: 14,
                              color: Palette.inverseThemeColor.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            calculateTotalVolume(workout).toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Palette.inverseThemeColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Sets block
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Sets",
                            style: TextStyle(
                              fontSize: 14,
                              color: Palette.inverseThemeColor.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            calculateTotalSets(workout).toString(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Palette.inverseThemeColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Bottom thin line
              Container(
                height: 1,
                color: Palette.inverseThemeColor.withOpacity(0.2),
              ),
            ],
          ),
        ),
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowIndicator();
        return true;
      },
      child: SafeArea(child:
        ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              "Workout: ${workout.title}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              "Notes: ${workout.notes.isEmpty ? "None" : workout.notes}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              "Exercises: ${workout.exercises.length}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Column(
              children: workout.exercises.asMap().entries.map((exerciseEntry) {
                final exerciseIndex = exerciseEntry.key;
                final exercise = exerciseEntry.value;
                return ExerciseTile(
                  weightHint: "15", // or whatever default you want
                  repsHint: "12",

                  exercise: exercise,
                  onOpenDetails: () {
                    // your existing code
                  },
                  onOpenMenu: () {
                    _showExerciseMenu(context, exercise, exerciseIndex);
                  },

                  onNotesChanged: (val) {
                    final workoutNotifier = ref.read(workoutProvider.notifier);
                    final workout = ref.read(workoutProvider);

                    if (workout == null) return;

                    // Create updated exercise with new notes but keep sets
                    final updatedExercise = exercise.copyWith(notes: val);

                    // Replace the exercise in the workout's exercise list
                    final updatedExercises = workout.exercises.map((ex) {
                      return ex.id == exercise.id ? updatedExercise : ex;
                    }).toList();

                    // Update the workout with the new exercises list
                    final updatedWorkout =
                    workout.copyWith(exercises: updatedExercises);

                    // Push the updated workout back to state
                    workoutNotifier.updateWorkout(updatedWorkout);
                  },
                  onRestTimerPressed: () async {
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

                    if (selected != null) {
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
                  },
                  workoutSets: exercise.sets,

                  onToggleCompleted: (setIndex, toggleValue) {
                    // we start a timer here
                  },

                  onSetChanged: (setIndex, updatedSet) {
                    final workoutNotifier = ref.read(workoutProvider.notifier);
                    final workout = ref.read(workoutProvider);

                    if (workout == null) return;

                    final updatedSets = List<WorkoutSet>.from(exercise.sets);
                    updatedSets[setIndex] = updatedSet;

                    final updatedExercise =
                    exercise.copyWith(sets: updatedSets);
                    final updatedExercises = workout.exercises
                    .map(
                    (ex) => ex.id == exercise.id ? updatedExercise : ex)
                    .toList();

                    final updatedWorkout =
                    workout.copyWith(exercises: updatedExercises);
                    workoutNotifier.updateWorkout(updatedWorkout);
                  },
                  onAddSet: () {
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

                    final updatedSets = List<WorkoutSet>.from(exercise.sets)
                    ..add(newSet);

                    final updatedExercise =
                    exercise.copyWith(sets: updatedSets);
                    final updatedExercises = workout.exercises
                    .map(
                    (ex) => ex.id == exercise.id ? updatedExercise : ex)
                    .toList();

                    final updatedWorkout =
                    workout.copyWith(exercises: updatedExercises);
                    workoutNotifier.updateWorkout(updatedWorkout);
                  },
                  onDeleteSet: (setIndex) {
                    final workoutNotifier = ref.read(workoutProvider.notifier);
                    final workout = ref.read(workoutProvider);

                    if (workout == null) return;

                    final updatedSets = List<WorkoutSet>.from(exercise.sets)
                    ..removeAt(setIndex);

                    final updatedExercise =
                    exercise.copyWith(sets: updatedSets);
                    final updatedExercises = workout.exercises
                    .map(
                    (ex) => ex.id == exercise.id ? updatedExercise : ex)
                    .toList();

                    final updatedWorkout =
                    workout.copyWith(exercises: updatedExercises);
                    workoutNotifier.updateWorkout(updatedWorkout);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                Palette.blue, // <-- sets the button’s fill color
                elevation: 0),
              onPressed: () async {
                // Push and wait for result (assumed to be a List<Movement>)
                final result =
                await context.push<List<Movement>>('/select-exercises');

                if (result != null && result.isNotEmpty) {
                  // Start from existing exercises, add new exercises for each movement from result
                  final updatedExercises = List.of(workout.exercises);

                  for (var i = 0; i < result.length; i++) {
                    final movement = result[i];

                    updatedExercises.add(
                      Exercise(
                        id: generateTempId(),
                        category: "Working",
                        movement: movement,
                        workoutId: workout.id ?? 0,
                        orderIndex:
                            updatedExercises.length, // or i + existing length
                        restTime: 60,
                        notes: "",
                        date: DateTime.now(),
                        volume: 0,
                      ),
                    );
                  }

                  final updatedWorkout =
                      workout.copyWith(exercises: updatedExercises);
                  workoutNotifier.updateWorkout(updatedWorkout);
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize
                .min, // this keeps the button tight around its content
                children: [
                  Icon(Icons.add), // this is the plus icon
                  SizedBox(width: 8), // space between icon and text
                  Text("Add Exercise"),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Palette
                .secondaryBackground, // <-- sets the button’s fill color
              ),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                context: context,
                barrierDismissible: false, // force the user to pick
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Palette.primaryBackground,
                    title: const Text("Discard Workout?"),
                    content: const Text(
                      "Are you sure you want to discard this workout? This cannot be undone.",
                    ),
                    actions: [
                      TextButton(
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Palette.blue),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                      TextButton(
                        child: const Text(
                          "Discard",
                          style: TextStyle(color: Palette.red),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                      ),
                    ],
                  );
                },
              );
                if (confirm == true) {
                  workoutNotifier.endWorkout();
                  Navigator.of(context).pop();
                }
              },
              child: const Text(
                "Discard Workout",
                style: TextStyle(color: Palette.red),
              ),
            ),
          ],
        ),
      )
    ),
    );
  }
}
