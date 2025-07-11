import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:setforge/helpers/session_helpers.dart';
import 'package:setforge/notifiers/workout_notifier.dart';
import 'package:setforge/database/models.dart';  // For Workout
import 'package:setforge/styling/colors.dart';

class SessionScreen extends ConsumerStatefulWidget {
  const SessionScreen({super.key});

  @override
  ConsumerState<SessionScreen> createState() => _SessionScreenState();
}
class _SessionScreenState extends ConsumerState<SessionScreen> {
  Timer? _timer;

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

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {}); // rebuild every second for live duration update
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String timeConverter(DateTime start) {
    final now = DateTime.now();
    final duration = now.difference(start);

    if (duration.inHours >= 24) {
      return "24h+";
    }

    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    // If hours and minutes both zero, only show seconds
    if (hours == 0 && minutes == 0) {
      return "${seconds}s";
    }

    final buffer = StringBuffer();
    if (hours > 0) {
      buffer.write("${hours}h ");
    }
    if (minutes > 0 || hours > 0) {
      buffer.write("${minutes}min ");
    }
    buffer.write("${seconds}s");

    return buffer.toString().trim();
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

    final durationText = timeConverter(workout.date);
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
                color: Palette.inverseThemeColor,
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
        color: Palette.inverseThemeColor.withOpacity(0.2), // subtle line color
      ),

      // Your existing bar container
      Container(
        color: Palette.primaryBackground,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Duration - flush left
            Column(
              mainAxisSize: MainAxisSize.min,
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
                Text(
                  durationText,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Palette.inverseThemeColor,
                  ),
                ),
              ],
            ),

            const SizedBox(width: 40),

            Row(
              children: [
                SizedBox(
                  width: 80,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                        "0 lbs",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Palette.inverseThemeColor,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 24),

                SizedBox(
                  width: 60,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                        "0",
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
      child: ListView(
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

          ElevatedButton(
            onPressed: () {
              // Add a dummy exercise for example
              final updatedExercises = List.of(workout.exercises)
              ..add(
                Exercise(
                  id: null,
                  category: "Working",
                  movement: Movement(
                    id: null,
                    name: "New Movement",
                    type: "Strength",
                    oneRepMax: 100,
                    muscleGroups: {},
                    instructions: "",
                    maxWeight: 0,
                    maxSessionVolume: 0,
                    maxSetVolume: 0,
                    equipment: "",
                    completionCount: 0,
                  ),
                  workoutId: workout.id ?? 0,
                  orderIndex: workout.exercises.length,
                  restTime: 60,
                  notes: "",
                  date: DateTime.now(),
                  volume: 0,
                ),
              );

              final updatedWorkout = workout.copyWith(exercises: updatedExercises);
              workoutNotifier.updateWorkout(updatedWorkout);
            },
            child: const Text("Add Exercise"),
          ),

          const SizedBox(height: 12),
        ],
      ),
    ),
    );
  }
}
