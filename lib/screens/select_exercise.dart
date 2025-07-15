import 'package:flutter/material.dart';
import 'package:setforge/database/dao/movement_dao.dart';
import 'package:setforge/database/models.dart';
import 'package:setforge/helpers/movement_helpers.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:setforge/styling/colors.dart';

class SelectExercise extends StatefulWidget {
  const SelectExercise({super.key});

  @override
  State<SelectExercise> createState() => _SelectExerciseState();
}

class _SelectExerciseState extends State<SelectExercise> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _fetchMovements();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String? selectedEquipment; // null means "All"
  String? selectedMuscle; // null means "All"
  List<Movement> allMovements = [];
  List<Movement> filteredMovements = [];
  String searchQuery = '';
  Set<int> _selectedIndices = {};

  void _onCreatePressed() {
    // Do nothing
  }

  void _fetchMovements() async {
    allMovements = await MovementDao.instance.getAllMovements();
    _filterMovements();
  }

  void _filterMovements() {
    setState(() {
      // Capitalize first letter if selectedMuscle is not null
      final capitalizedMuscle = selectedMuscle == null
          ? null
          : selectedMuscle![0].toLowerCase() + selectedMuscle!.substring(1);
      final capitalizedEquipment = selectedEquipment == null
          ? null
          : selectedEquipment![0].toLowerCase() +
              selectedEquipment!.substring(1);

      filteredMovements = allMovements.where((m) {
        final matchesEquipment =
            capitalizedEquipment == null || m.equipment == capitalizedEquipment;

        final matchesMuscle = capitalizedMuscle == null ||
            m.muscleGroups.values.any((list) =>
                (list as List).any((muscle) => muscle == capitalizedMuscle));

        final lowerName = m.name.toLowerCase();
        final contains = lowerName.contains(searchQuery);
        final fuzzy = tokenSetRatio(searchQuery, m.name) > 70;

        final matchesSearch = searchQuery.isEmpty || contains || fuzzy;

        return matchesEquipment && matchesMuscle && matchesSearch;
      }).toList();
      if (capitalizedMuscle != null) {
        filteredMovements.sort((a, b) {
          bool aPrimary = (a.muscleGroups['primary'] as List?)
                  ?.contains(capitalizedMuscle) ??
              false;
          bool bPrimary = (b.muscleGroups['primary'] as List?)
                  ?.contains(capitalizedMuscle) ??
              false;
          if (aPrimary && !bPrimary) return -1; // a before b
          if (!aPrimary && bPrimary) return 1; // b before a

          bool aSecondary = (a.muscleGroups['secondary'] as List?)
                  ?.contains(capitalizedMuscle) ??
              false;
          bool bSecondary = (b.muscleGroups['secondary'] as List?)
                  ?.contains(capitalizedMuscle) ??
              false;
          if (aSecondary && !bSecondary) return -1;
          if (!aSecondary && bSecondary) return 1;

          return 0; // keep relative order
        });
      }
    });
  }

  void _openMuscleDrawer() async {
    final List<Map<String, String?>> options =
        generateMuscleOptions(allMovements);

    final result = await showModalBottomSheet<String?>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        String? tempSelected = selectedMuscle;

        return SafeArea(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  "Select Muscle",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options[index];
                      final label = option['label']!;
                      final image = option['image'];
                      final isSelected =
                          (tempSelected == null && label == 'All') ||
                              tempSelected == label;

                      return ListTile(
                        onTap: () {
                          Navigator.pop(
                            context,
                            label == 'All' ? null : label,
                          );
                        },
                        leading: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (image != null)
                              Container(
                                width: 36,
                                height: 36,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey,
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Image.asset(
                                  image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            const SizedBox(width: 12),
                            Text(
                              label,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check, color: Colors.blue)
                            : null,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    setState(() {
      selectedMuscle = result;
      _filterMovements();
    });
  }

  void _openEquipmentDrawer() async {
    final List<Map<String, String?>> options =
        generateEquipmentOptions(allMovements);
    final result = await showModalBottomSheet<String?>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        String? tempSelected = selectedEquipment;

        return SafeArea(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  "Select Equipment",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options[index];
                      final label = option['label']!;
                      final image = option['image'];
                      final isSelected =
                          (tempSelected == null && label == 'All') ||
                              tempSelected == label;

                      return ListTile(
                        onTap: () {
                          Navigator.pop(
                            context,
                            label == 'All' ? null : label,
                          );
                        },
                        leading: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (image != null)
                              Container(
                                width: 36,
                                height: 36,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey,
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Image.asset(
                                  image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            const SizedBox(width: 12),
                            Text(
                              label,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check, color: Colors.blue)
                            : null,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    setState(() {
      selectedEquipment = result;
      _filterMovements();
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    final isAllEquipmentSelected = selectedEquipment == null;
    final equipmentLabel =
        isAllEquipmentSelected ? 'All Equipment' : selectedEquipment!;
    final isAllMusclesSelected = selectedMuscle == null;
    final muscleLabel = isAllMusclesSelected ? 'All Muscles' : selectedMuscle!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.secondaryBackground,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 40,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          "Add Exercise",
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: _onCreatePressed,
              behavior: HitTestBehavior.opaque,
              child: const Text(
                "Create",
                style: TextStyle(
                  fontSize: 16,
                  color: Palette.blue,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                  style: TextStyle(),
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value.trim().toLowerCase();
                        _filterMovements();
                      });
                    },
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    decoration: InputDecoration(
                      hintText: "Search exercise",
                    hintStyle: TextStyle(color: Palette.inverseThemeColor.withOpacity(0.8)),
                      filled: true,
                      fillColor: Palette.secondaryBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      suffixIcon: searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close, color: Palette.red),
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                  searchQuery = '';
                                  _filterMovements();
                                });
                              },
                            )
                          : null,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 16.0),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _openEquipmentDrawer,
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: isAllEquipmentSelected
                                ? Palette.secondaryBackground
                                : Palette.blue,
                          foregroundColor: Palette.inverseThemeColor
                          ),
                          child: Text(
                            equipmentLabel,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _openMuscleDrawer,
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: isAllMusclesSelected
                                ? Palette.secondaryBackground
                                : Palette.blue,
                              foregroundColor: Palette.inverseThemeColor

                        ),
                        child: Text(
                          muscleLabel,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredMovements.length,
                      itemBuilder: (context, index) {
                        final movement = filteredMovements[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: _selectedIndices.contains(index)
                                ? Palette.blue.withOpacity(0.2)
                                : Palette.secondaryBackground,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            leading: Container(
                              width: 60,
                              height: 60,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey[300],
                              ),
                          child: () {
                              final img = movement.imageUrl;
                              return img.isNotEmpty
                                  ? Image.asset(
                                      img,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(Icons.image_not_supported);
                            }(),
                            ),
                            title: Text(
                              movement.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (movement.muscleGroups['primary'] != null &&
                                    (movement.muscleGroups['primary'] as List)
                                        .isNotEmpty)
                                  Text(
                                    formatMuscles(
                                        movement.muscleGroups['primary']),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                if (movement.muscleGroups['secondary'] !=
                                        null &&
                                    (movement.muscleGroups['secondary'] as List)
                                        .isNotEmpty)
                                  Text(
                                    formatMuscles(
                                        movement.muscleGroups['secondary']),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey,
                                    ),
                                  ),
                              ],
                            ),
                            onTap: () {
                              setState(() {
                                if (_selectedIndices.contains(index)) {
                                  _selectedIndices.remove(index);
                                } else {
                                  _selectedIndices.add(index);
                                }
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_selectedIndices.isNotEmpty)
            Positioned(
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).padding.bottom,
              child: SafeArea(
                top: false,
                child: ElevatedButton(
                  onPressed: () {
                    // Create a list of selected movements based on selected indices
                    final selectedMovements = _selectedIndices
                        .map((index) => filteredMovements[index])
                        .toList();

                    Navigator.pop(context, selectedMovements);
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 18), // bigger vertical padding
                      backgroundColor: Palette.blue),
                  child: Text(
                    'Add ${_selectedIndices.length} exercises',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
