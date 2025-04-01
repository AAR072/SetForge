import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowIndicator(); // Prevent Overscroll Indication
        return true;
      },
      child: ListView(
        shrinkWrap: true,
        children: [
          Text("Home")
        ],
      ),
    ),
    );
  }
}
