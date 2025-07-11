import 'package:flutter/material.dart';
import 'package:setforge/database/models.dart';
import 'package:setforge/styling/colors.dart';

class ExerciseTile extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onOpenDetails;
  final VoidCallback onOpenMenu;
  final Function(String) onNotesChanged;
  final VoidCallback onRestTimerPressed;
  final List<WorkoutSet> workoutSets;
  final void Function(int setIndex, WorkoutSet updatedSet) onSetChanged;
  final VoidCallback onAddSet;
  final void Function(int setIndex) onDeleteSet;

  const ExerciseTile({
    super.key,
    required this.exercise,
    required this.onOpenDetails,
    required this.onOpenMenu,
    required this.onNotesChanged,
    required this.onRestTimerPressed,
    required this.workoutSets,
    required this.onSetChanged,
    required this.onAddSet,
    required this.onDeleteSet,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // ROW 1 — Avatar + Title + 3-dot menu
            Row(
              children: [
                GestureDetector(
                  onTap: onOpenDetails,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        child: Icon(Icons.fitness_center),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        exercise.movement.name,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: onOpenMenu,
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ROW 2 — Notes input
            TextField(
              decoration: const InputDecoration(
                hintText: "Add notes...",
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              onChanged: onNotesChanged,
              maxLines: 1,
              controller: TextEditingController(text: exercise.notes),
            ),

            const SizedBox(height: 12),

            // ROW 3 — Rest timer button
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: onRestTimerPressed,
                child: Text("Rest: ${exercise.restTime}s"),
              ),
            ),

            const SizedBox(height: 12),

            // ROW 4+ — Sets list with swipe-to-delete
            Column(
              children: workoutSets.asMap().entries.map((entry) {
                final i = entry.key;
                final set = entry.value;

                if (set.type != "working") {
                  return const SizedBox.shrink();
                }

                final workingNumber =
                    workoutSets.take(i + 1).where((s) => s.type == "working").length;

                return Dismissible(
                  key: ValueKey(set.id ?? '$i-${set.hashCode}'),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    color: Palette.red,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => onDeleteSet(i),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        // Set number
                        InkWell(
                          onTap: () {
                            // Optional: open set type drawer
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Text("$workingNumber"),
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Previous weight x reps (placeholder)
                        TextButton(
                          onPressed: () {
                            // Optional: fill weight & reps from previous set
                          },
                          child: Text("prev lbs x "),
                        ),

                        const SizedBox(width: 8),

                        // Weight input
                        SizedBox(
                          width: 50,
                          child: TextFormField(
                            initialValue: set.weight.toString(),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: "Weight",
                              isDense: true,
                            ),
                            onChanged: (val) {
                              final weight = double.tryParse(val) ?? 0;
                              final updatedSet = set.copyWith(weight: weight);
                              onSetChanged(i, updatedSet);
                            },
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Reps input
                        SizedBox(
                          width: 50,
                          child: TextFormField(
                            initialValue: set.reps.toString(),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: "Reps",
                              isDense: true,
                            ),
                            onChanged: (val) {
                              final reps = int.tryParse(val) ?? 0;
                              final updatedSet = set.copyWith(reps: reps);
                              onSetChanged(i, updatedSet);
                            },
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Check button (mark complete)
                        IconButton(
                          icon: const Icon(Icons.check_circle_outline),
                          onPressed: () {
                            // Optional: mark set complete
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton.icon(
                onPressed: onAddSet,
                icon: const Icon(Icons.add),
                label: const Text("Add Set"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  backgroundColor: Palette.tertiaryBackground
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
