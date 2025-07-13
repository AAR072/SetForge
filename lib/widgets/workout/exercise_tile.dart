import 'package:flutter/material.dart';
import 'package:setforge/database/models.dart';
import 'package:setforge/styling/colors.dart';

class ExerciseTile extends StatefulWidget {
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
  State<ExerciseTile> createState() => _ExerciseTileState();
}

class _ExerciseTileState extends State<ExerciseTile> {

  late final TextEditingController _notesController;
  final Map<int, TextEditingController> _weightControllers = {};
  final Map<int, FocusNode> _weightFocusNodes = {};

  final Map<int, TextEditingController> _repsControllers = {};
  final Map<int, FocusNode> _repsFocusNodes = {};

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: widget.exercise.notes);
  }

  @override
  void dispose() {
    _notesController.dispose();
    _weightControllers.values.forEach((c) => c.dispose());
    _weightFocusNodes.values.forEach((n) => n.dispose());
    _repsControllers.values.forEach((c) => c.dispose());
    _repsFocusNodes.values.forEach((n) => n.dispose());
    super.dispose();
  }



  @override
  void didUpdateWidget(covariant ExerciseTile oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.exercise.notes != widget.exercise.notes &&
      _notesController.text != widget.exercise.notes) {
    _notesController.text = widget.exercise.notes;
  }
  }


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
                  onTap: widget.onOpenDetails,
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        child: Icon(Icons.fitness_center),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        widget.exercise.movement.name,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: widget.onOpenMenu,
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ROW 2 — Notes input
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                hintText: "Add notes...",
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              onChanged: widget.onNotesChanged,
              maxLines: 1,
            ),

            const SizedBox(height: 12),

            // ROW 3 — Rest timer button
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: widget.onRestTimerPressed,
                child: Text("Rest: ${widget.exercise.restTime}s"),
              ),
            ),

            const SizedBox(height: 12),

            // ROW 4+ — Sets list with swipe-to-delete
            Column(
              children: widget.workoutSets.asMap().entries.map((entry) {
                final i = entry.key;
                final set = entry.value;

                if (set.type != "working") {
                  return const SizedBox.shrink();
                }

                final workingNumber =
                    widget.workoutSets.take(i + 1).where((s) => s.type == "working").length;
                final weightController = _weightControllers.putIfAbsent(i, () {
  return TextEditingController(text: set.weight.toString());
});
final weightFocus = _weightFocusNodes.putIfAbsent(i, () {
  final focusNode = FocusNode();
  focusNode.addListener(() {
    if (!focusNode.hasFocus) {
      final newWeight = double.tryParse(weightController.text) ?? 0.0;
      // grab the latest set by index:
      final baseSet = widget.workoutSets[i];
      final updated = baseSet.copyWith(weight: newWeight);
      widget.onSetChanged(i, updated);
    }
  });
  return focusNode;
});

final repsController = _repsControllers.putIfAbsent(i, () {
  return TextEditingController(text: set.reps.toString());
});

final repsFocus = _repsFocusNodes.putIfAbsent(i, () {
  final focusNode = FocusNode();
  focusNode.addListener(() {
    if (!focusNode.hasFocus) {
      final newReps = int.tryParse(repsController.text) ?? 0;
      final baseSet = widget.workoutSets[i];
      final updated = baseSet.copyWith(reps: newReps);
      widget.onSetChanged(i, updated);
    }
  });
  return focusNode;
});


                return Dismissible(
                  key: ValueKey(set.id ?? '$i-${set.hashCode}'),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    color: Palette.red,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => widget.onDeleteSet(i),
child: Padding(
  padding: const EdgeInsets.symmetric(vertical: 4),
  child: Row(
    children: [
      // Set number - small fixed width
      Container(
        width: 30,
        alignment: Alignment.center,
        child: Text("$workingNumber"),
      ),

      const SizedBox(width: 8),

      // Previous text - flex 1
      Expanded(
        flex: 3,
        child: TextButton(
          onPressed: () {},
          child: const Text("prev lbs x"),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            alignment: Alignment.centerLeft,
            textStyle: const TextStyle(fontSize: 14),
          ),
        ),
      ),

      const SizedBox(width: 8),

// Weight input
Expanded(
  flex: 3,
  child: TextField(
    controller: weightController,
    focusNode: weightFocus,
    textAlign: TextAlign.center,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
      hintText: "10",
      border: InputBorder.none,
      isDense: true,
      contentPadding: EdgeInsets.symmetric(vertical: 8),
      hintStyle: TextStyle(color: Colors.grey.shade400),
    ),
    style: TextStyle(color: Colors.grey.shade400),
  ),
),

const SizedBox(width: 8),

// Reps input
Expanded(
  flex: 3,
  child: TextField(
    controller: repsController,
    focusNode: repsFocus,
    textAlign: TextAlign.center,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
      hintText: "10",
      border: InputBorder.none,
      isDense: true,
      contentPadding: EdgeInsets.symmetric(vertical: 8),
      hintStyle: TextStyle(color: Colors.grey.shade400),
    ),
    style: TextStyle(color: Colors.grey.shade400),
  ),
),

      const SizedBox(width: 8),

      // Check button - small fixed width
      Container(
        width: 30,
        alignment: Alignment.center,
        child: IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(Icons.check_circle_outline),
          onPressed: () {},
        ),
      ),
    ],
  ),
),
                );
              }).toList(),
            ),

Align(
  alignment: Alignment.centerLeft,
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8), // adjust padding as you want
    child: SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: widget.onAddSet,
        icon: const Icon(Icons.add),
        label: const Text("Add Set"),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 1),
          backgroundColor: Palette.tertiaryBackground,
        ),
      ),
    ),
  ),
),
          ],
        ),
      ),
    );
  }
}
