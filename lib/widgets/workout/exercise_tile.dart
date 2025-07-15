import 'package:flutter/material.dart';
import 'package:setforge/database/models.dart';
import 'package:setforge/helpers/session_helpers.dart';
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
  final void Function(int setIndex, bool newValue)? onToggleCompleted;
  final void Function(int setIndex) onDeleteSet;

  final String weightHint;
  final String repsHint;

  const ExerciseTile({
    super.key,
    required this.exercise,
    required this.onOpenDetails,
    required this.onOpenMenu,
    required this.onNotesChanged,
    required this.onRestTimerPressed,
    required this.onToggleCompleted,
    required this.workoutSets,
    required this.onSetChanged,
    required this.onAddSet,
    required this.onDeleteSet,
    this.weightHint = '10',
    this.repsHint = '10',
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
      color: Colors.transparent,
      child: Column(
        children: [
          // ROW 1 — Avatar + Title + 3-dot menu
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(widget.exercise.movement.imageUrl),
                backgroundColor: Colors.transparent, // optional: remove default color
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.exercise.movement.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Palette.blue
                  ),
                  softWrap: true,
                  maxLines: null,
                  overflow: TextOverflow.visible,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: widget.onOpenMenu,
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ROW 2 — Notes input
          TextField(
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            controller: _notesController,
            decoration: InputDecoration(
              filled: false,
              hintText: "Notes...",
              border: InputBorder.none,
              isDense: true,
              hintStyle: TextStyle(color: Colors.grey.shade400),
            ),
            style: TextStyle(color: Palette.inverseThemeColor),
            onChanged: widget.onNotesChanged,
            maxLines: null,
          ),

          const SizedBox(height: 12),

          // ROW 3 — Rest timer button
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: widget.onRestTimerPressed,
              behavior: HitTestBehavior.opaque,
              child: Text(
                "Rest: ${secondsParser(widget.exercise.restTime)}",
                style: TextStyle(
                  fontSize: 16,
                  color: Palette.blue,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ROW 4+ — Sets list with swipe-to-delete
          Column(children: [
            if (widget.workoutSets.any((s) => s.type == "working")) ...[
              // ✅ HEADER ROW
              Container(
                color: Palette.primaryBackground, // optional, adjust as needed
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Row(
                  children: const [
                    SizedBox(
                      width: 30,
                      child: Text(
                        "#",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: Text(
                          "Previous",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: Text(
                          "Weight",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: Text(
                          "Reps",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    SizedBox(
                      width: 30,
                      child: Center(
                        child: Text(
                          "✓",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ...widget.workoutSets.asMap().entries.map((entry) {
                final i = entry.key;
                final set = entry.value;

                if (set.type != "working") {
                  return const SizedBox.shrink();
                }

                final workingNumber = widget.workoutSets
                    .take(i + 1)
                    .where((s) => s.type == "working")
                    .length;
                final weightController = _weightControllers.putIfAbsent(i, () {
                  return TextEditingController(text: '');
                });
                final repsController = _repsControllers.putIfAbsent(i, () {
                  return TextEditingController(text: '');
                });

                final weightFocus = _weightFocusNodes.putIfAbsent(i, () {
                  final focusNode = FocusNode();
                  focusNode.addListener(() {
                    if (!focusNode.hasFocus) {
                      final newWeight =
                          double.tryParse(weightController.text) ?? 0.0;
                      final baseSet = widget.workoutSets[i];
                      final updated = baseSet.copyWith(weight: newWeight);
                      widget.onSetChanged(i, updated);
                    }
                  });
                  return focusNode;
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

                // ONLY update controller text if NOT focused
                if (!weightFocus.hasFocus) {
                  final weightText = formatWeight(set.weight);
                  if (weightController.text != weightText) {
                    weightController.text = weightText;
                  }
                }

                if (!repsFocus.hasFocus) {
                  final repsText = set.reps > 0 ? set.reps.toString() : '';
                  if (repsController.text != repsText) {
                    repsController.text = repsText;
                  }
                }

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
                  child: Container(
                    color: set.completed
                        ? const Color(0xFF0A8A0E) // solid
                        : (workingNumber % 2 == 0
                            ? Palette.secondaryBackground
                            : Palette.primaryBackground),
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        // Set number
                        Container(
                          width: 30,
                          alignment: Alignment.center,
                          child: Text("$workingNumber"),
                        ),
                        const SizedBox(width: 8),

                        // Previous text
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
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            controller: weightController,
                            focusNode: weightFocus,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              filled: false,
                              hintText: widget.weightHint,
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 8),
                              hintStyle: TextStyle(color: Colors.grey.shade400),
                            ),
                            style: TextStyle(color: Palette.inverseThemeColor),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Reps input
                        Expanded(
                          flex: 3,
                          child: TextField(
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            controller: repsController,
                            focusNode: repsFocus,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              filled: false,
                              hintText: widget.repsHint,
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 8),
                              hintStyle: TextStyle(color: Colors.grey.shade400),
                            ),
                            style: TextStyle(color: Palette.inverseThemeColor),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Check button
                        Container(
                          width: 30,
                          alignment: Alignment.center,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: Icon(
                              set.completed
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              color: set.completed ? Colors.green : Colors.grey,
                            ),
                            onPressed: () {
                              final updatedSet =
                                  set.copyWith(completed: !set.completed);
                              widget.onSetChanged(i, updatedSet);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ]
          ]),

          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8), // adjust padding as you want
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: widget.onAddSet,
                  icon: const Icon(Icons.add),
                  label: const Text("Add Set"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    backgroundColor: Palette.secondaryBackground,
                    foregroundColor: Palette.inverseThemeColor
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
