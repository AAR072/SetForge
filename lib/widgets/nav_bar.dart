import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final Function(int) onItemTapped;
  final int selectedIndex;  // Added selectedIndex to track the current selected tab

  const NavBar({super.key, required this.onItemTapped, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.fitness_center),
          label: 'Workout',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.manage_accounts),
          label: 'Profile',
        ),
      ],
      currentIndex: selectedIndex,  // Set the currentIndex to the selectedIndex
      onTap: onItemTapped,  // Call the onItemTapped callback when a tab is tapped
    );
  }
}
