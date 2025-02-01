import 'package:benchy/database/models.dart';
import 'package:flutter/material.dart';
import 'package:benchy/database/db_helper.dart';
import 'package:flutter/services.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class Utility extends StatefulWidget {
  const Utility({super.key});
  @override
  State<StatefulWidget> createState() => _UtilityState();

}
class _UtilityState extends State<Utility>{
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
    final db = await DatabaseHelper.instance.getAllWorkouts();
    for (var i = 0; i < db.length; i++) {
      final element = db[i];
      _outputText += "Workout $i:\nTitle: ${element.title}\nDate: ${element.date}\nDuration: ${element.duration}\nVolume: ${element.volume}\nNotes: ${element.notes}";
    }
    setState((){});
  }
  @override Widget build(BuildContext context) {
    return Column(children: [
      ElevatedButton(onPressed: (){clearDB();}, child: Text("Clear Database")),
      ElevatedButton(onPressed: (){showDB();}, child: Text("View Database")),
      Text(_outputText),
    ]);
  } 
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // This is all testing
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController(text: "Good Workout");
  final _durationController = TextEditingController(text: "5400");
  final _volumeController = TextEditingController(text: "9000");
  String outputText = "Please tell me your name :(";
  @override Widget build(BuildContext context) {
    return Scaffold(
      body: 
      Form(
        key: _formKey,
        child: 
        SingleChildScrollView(child:
        Column(
          children: [
            Utility(),
            TextFormField(
              controller: _titleController, 
              decoration: 
              InputDecoration(labelText: "Title"),
            ),
            TextFormField(
              controller: _durationController, 
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Duration"),
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
              decoration: InputDecoration(labelText: "Volume"),
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
            Padding(padding: EdgeInsets.all(16)),
            ElevatedButton(
              onPressed: ()async{
                if (_formKey.currentState?.validate() ?? false) {  
                  await DatabaseHelper.instance.database;
                  final Workout tempWorkout = Workout(
                  title: _titleController.text, 
                  date: DateTime.now(), 
                  duration: int.parse(_durationController.text), 
                  volume: double.parse(_volumeController.text), 
                  );
                  await DatabaseHelper.instance.insertWorkout(tempWorkout);
                }
              }, 
              child: Text("Create Workout"))
          ]),
      ),
    )
    );
  }
}

