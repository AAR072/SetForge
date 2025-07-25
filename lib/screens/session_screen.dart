import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:setforge/helpers/exercise_tile_helpers.dart';
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


  void _onReorder(int oldIndex, int newIndex) {

    final workoutNotifier = ref.read(workoutProvider.notifier);
    final workout = ref.read(workoutProvider);

    if (workout == null) return;


    final exercises = List.of(workout.exercises);
    final exercise = exercises.removeAt(oldIndex);
    exercises.insert(newIndex, exercise);

    workoutNotifier.updateWorkout(
      workout.copyWith(exercises: exercises),
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

    ScrollController _scrollController = PrimaryScrollController.of(context) ?? ScrollController();

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
          preferredSize: const Size.fromHeight(74),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 1,
                color: Palette.inverseThemeColor.withOpacity(0.2),
              ),
              Container(
                color: Palette.primaryBackground,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
      child: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                  ],
                ),
              ),
            ),
            ReorderableSliverList(
              delegate: ReorderableSliverChildBuilderDelegate(
              (BuildContext context, int index) {
                  final exercise = workout.exercises[index];
                  return ExerciseTile(
                    key: ValueKey(exercise.id),
                    weightHint: "15",
                    repsHint: "12",
                    exercise: exercise,
                    onOpenDetails: () { /* your existing code */ },
                    onOpenMenu: () {
                      showExerciseMenu(
                        context: context,
                        ref: ref,
                        exercise: exercise,
                        exerciseIndex: index,
                      );
                    },
                    onNotesChanged: (val) {
                      handleNotesChanged(
                        ref: ref,
                        exercise: exercise,
                        newNotes: val,
                      );
                    },
                    onRestTimerPressed: () {
                      handleRestTimerPressed(
                        context: context,
                        ref: ref,
                        exercise: exercise,
                      );
                    },
                    workoutSets: exercise.sets,
                    onToggleCompleted: (setIndex, toggleValue) {
                      // your existing code
                    },
                    onSetChanged: (setIndex, updatedSet) {
                      handleSetChanged(
                        ref: ref,
                        exercise: exercise,
                        setIndex: setIndex,
                        updatedSet: updatedSet,
                      );
                    },
                    onAddSet: () {
                      handleAddSet(
                        ref: ref,
                        exercise: exercise,
                      );
                    },
                    onDeleteSet: (setIndex) {
                      handleDeleteSet(
                        ref: ref,
                        exercise: exercise,
                        setIndex: setIndex,
                      );
                    },
                  );
                },
                childCount: workout.exercises.length,
              ),
              onReorder: _onReorder             ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text("Add Exercise"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        Palette.blue, // <-- sets the button’s fill color
                        elevation: 0),
                      onPressed: () {
                        handleAddExercisesPressed(
                          context: context,
                          ref: ref,
                          workout: workout,
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Palette.secondaryBackground,
                      ),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Palette.primaryBackground,
                            title: const Text("Discard Workout?"),
                            content: const Text(
                              "Are you sure you want to discard this workout? This cannot be undone.",
                            ),
                            actions: [
                              TextButton(
                                child: const Text("Cancel", style: TextStyle(color: Palette.blue)),
                                onPressed: () => Navigator.of(context).pop(false),
                              ),
                              TextButton(
                                child: const Text("Discard", style: TextStyle(color: Palette.red)),
                                onPressed: () => Navigator.of(context).pop(true),
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
                      child: const Text("Discard Workout", style: TextStyle(color: Palette.red)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }}
