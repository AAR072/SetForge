import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final Function(int) onItemTapped;
  final int selectedIndex;

  const NavBar(
      {super.key, required this.onItemTapped, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(selectedIndex == 0 ? Icons.home : Icons.home_outlined),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(selectedIndex == 1
              ? Icons.fitness_center
              : Icons.fitness_center_outlined),
          label: 'Workout',
        ),
        BottomNavigationBarItem(
          icon: Icon(selectedIndex == 2
              ? Icons.manage_accounts
              : Icons.manage_accounts_outlined),
          label: 'Setup',
        ),
      ],
      currentIndex: selectedIndex, // Set the currentIndex to the selectedIndex
      onTap:
          onItemTapped, // Call the onItemTapped callback when a tab is tapped
    );
  }
}
