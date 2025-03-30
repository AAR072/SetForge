import 'package:benchy/screens/home_screen.dart';
import 'package:benchy/screens/profile_screen.dart';
import 'package:benchy/screens/workout_screen.dart';
import 'package:benchy/styling/colors.dart';
import 'package:flutter/material.dart';
import 'package:benchy/widgets/nav_bar.dart';
import 'package:flutter/services.dart'; // Import the NavBar widget

class ControlScreen extends StatefulWidget {
  const ControlScreen({super.key});

  @override
  _ControlScreenState createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),  // Replace this with your actual screen
    WorkoutScreen(), // Replace with your actual screen
    ProfileScreen(), // Replace with your actual screen
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        // systemNavigationBarColor: Colors.transparent,
    // systemNavigationBarIconBrightness: Brightness.light, // Ensure icons are visible on dark backgrounds
    // statusBarColor: Colors.transparent, // Optionally, make the status bar transparent
    // statusBarBrightness: Brightness.dark, // Adjust the status bar brightness for light/dark status bar
      ),
    child: Scaffold(
      backgroundColor: Colors.transparent,
      body: _widgetOptions[_selectedIndex],  // Display the selected widget
      extendBody: true,
      bottomNavigationBar: NavBar(
        onItemTapped: _onItemTapped,  // Pass the callback function
        selectedIndex: _selectedIndex, // Pass the current selected index
      ),
    )
  );
  }
}
