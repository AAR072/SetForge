import 'package:benchy/database/exercise_dao.dart';
import 'package:benchy/database/models.dart';
import 'package:benchy/database/workout_dao.dart';
import 'package:flutter/material.dart';
import 'package:benchy/database/db_helper.dart';
import 'package:flutter/services.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:benchy/styling/theme.dart';
import 'package:fl_chart/fl_chart.dart'; // Add for graph
import 'package:benchy/styling/colors.dart';

Future main() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  await DatabaseHelper.instance.database;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return MaterialApp(
          title: 'Benchy',
          theme: macroFactorTheme,
          home: const MyHomePage(),
        );
      },
    );
  }
}

class Utility extends StatefulWidget {
  const Utility({super.key});
  @override
  State<StatefulWidget> createState() => _UtilityState();
}

class _UtilityState extends State<Utility> {
  String _outputText = "";

  void clearDB() async {
    await DatabaseHelper.instance.deleteDatabaseFile();

    // Reinitialize the database
    await DatabaseHelper.instance.database;

    setState(() {
      _outputText = "";
    });
  }

  void showDB() async {
    _outputText = "";
    final db = await WorkoutDao.instance.getAllWorkouts();
    for (var i = 0; i < db.length; i++) {
    final element = db[i];
    _outputText += "Workout $i:\nTitle: ${element.title}\nDate: ${element.date}\nDuration: ${element.duration}\nVolume: ${element.volume}\nNotes: ${element.notes}";
  }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(onPressed: () { clearDB(); }, child: const Text("Clear Database")),
        ElevatedButton(onPressed: () { showDB(); }, child: const Text("View Database")),
        Text(_outputText),
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController(text: "Good Workout");
  final _durationController = TextEditingController(text: "5400");
  final _volumeController = TextEditingController(text: "9000");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Theme Testing"),
        scrolledUnderElevation: 0.0,
      ),
      body: Form(
        key: _formKey,
        child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator(); // Prevent Overscroll Indication
          return true;
        },
        child: ListView(
          shrinkWrap: true,
          children: [
            Card(child: Column(children: [              Utility(),
              // Form fields
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Title"),
              ),
              TextFormField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Duration"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a number';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if (int.parse(value) <= 0) {
                    return 'Please enter a duration that is greater than 0';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _volumeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Volume"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a number';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if (int.parse(value) <= 0) {
                    return 'Please enter a volume that is greater than 0';
                  }
                  return null;
                },
              ),
              const Padding(padding: EdgeInsets.all(16)),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    await DatabaseHelper.instance.database;
                    final Workout tempWorkout = Workout(
                      title: _titleController.text,
                      date: DateTime.now(),
                      duration: int.parse(_durationController.text),
                      volume: double.parse(_volumeController.text),
                    );
                    await WorkoutDao.instance.insertWorkout(tempWorkout);
                    await ExerciseDao.instance.insertExercise(Exercise(
                      category: "LOL",
                      movementId: 2,
                      workoutId: 2,
                      orderIndex: 2,
                      restTime: 23,
                      notes: "",
                      date: DateTime.now(),
                      volume: 20,
                    ));
                  }
                },
                child: const Text("Create Workout"),
              ),
            ],),),

            // Demo widgets for testing the theme
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              child: const Text(
                "This is a demo container. The theme will style it.",
              ),
            ),
            const SizedBox(height: 20),
            const Card(
              child: const Padding(
                padding: const EdgeInsets.all(16),
                child: const Text(
                  "This is a demo card. The theme will handle its appearance.",
                ),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              title: const Text("This is a demo ListTile."),
              trailing: const Icon(Icons.arrow_forward),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Demo Button"),
            ),
            const SizedBox(height: 20),

            // Accordion-style expansion list
            ExpansionTile(
              title: const Text("Demo Accordion"),
              children: [
                const ListTile(
                  title: Text("Item 1"),
                ),
                const ListTile(
                  title: Text("Item 2"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Slider to test theme styling
            const Slider(
              value: 50.0,
              min: 0,
              max: 100,
              onChanged: null,
            ),
            const SizedBox(height: 20),

            // Switch to test theme styling
            Switch(
              value: true,
              onChanged: (value) {},
            ),
            const SizedBox(height: 20),

            // Chip widget for theme testing
            Chip(
              label: const Text("Demo Chip"),
            ),
            const SizedBox(height: 20),

            // SnackBar trigger button to test snackbars
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('This is a demo Snackbar')),
                );
              },
              child: const Text('Show Snackbar'),
            ),
            const SizedBox(height: 20),

            // **Graph for testing**
            const Text("Demo Graph", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            Container(
              height: 300,
              padding: const EdgeInsets.all(16),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(show: true),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 1),
                        FlSpot(1, 3),
                        FlSpot(2, 1.5),
                        FlSpot(3, 2),
                        FlSpot(4, 4),
                      ],
                      isCurved: true,
                      color: blue,
                      barWidth: 4,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // **Group Widgets**
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text("Grouped Section 1", style: TextStyle(fontSize: 18)),
                  const Divider(),
                  const Text("This is a section for testing groupings."),
                  const Divider(),
                  const Text("You can add multiple items here to test the look."),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // **Sections with headers**
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Section Header 1", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  const Text("Content for section 1."),
                  const SizedBox(height: 20),
                  const Text("Section Header 2", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  const Text("Content for section 2."),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
