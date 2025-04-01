import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ControlScreen extends StatefulWidget{

  const ControlScreen({super.key, this.child});
  final Widget? child;

  @override
  State<ControlScreen> createState() =>
    _ControlScreenState();


}
class _ControlScreenState extends State<ControlScreen> {
  int currentIndex = 0;
  void changeTab(int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/workout');
        break;
      case 2:
        context.go('/settings');
        break;
      default:
        context.go('/home');
        break;
    }
    setState(() {
      currentIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        onTap: changeTab,
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(currentIndex == 0 ? Icons.home : Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(currentIndex == 1 ? Icons.fitness_center : Icons.fitness_center_outlined),
            label: 'Workout',
          ),
          BottomNavigationBarItem(
            icon: Icon(currentIndex == 2 ? Icons.manage_accounts : Icons.manage_accounts_outlined),
            label: 'Setup',
          ),
        ],
      ),
    );
  }
}
