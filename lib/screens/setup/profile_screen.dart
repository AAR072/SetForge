import 'package:setforge/styling/colors.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.secondaryBackground,
        elevation: 0, // No shadow
        centerTitle: true,
        toolbarHeight: 30,
        surfaceTintColor: Colors.transparent,
        leading: Transform.translate(
          offset: Offset(0, -4), // Adjust the Y value to raise it
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.keyboard_arrow_left_sharp),
          ),
        ),
        title: Opacity(
          opacity: 1,
          child: Text(
            "Profile", // AppBar title
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16
            ),
          ),
        ),
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowIndicator(); // Prevent Overscroll Indication
        return true;
      },
      child: ListView(
        shrinkWrap: true,
        children: [
          Text("Setup/Profile")
        ],
      ),
    ),
    );
  }
}
