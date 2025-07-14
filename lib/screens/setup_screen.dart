import 'package:setforge/styling/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  _SetupScreenState createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen>
    with TickerProviderStateMixin {
  late AnimationController _opacityController;

  @override
  void initState() {
    // Initialize the AnimationController with a duration for the fade effect
    _opacityController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500), // Duration for the fade animation
    );
    _opacityController.addListener(() {
      setState(
          () {}); // This triggers a rebuild when the animation value changes
    });
    super.initState();
  }

  @override
  void dispose() {
    _opacityController
        .dispose(); // Dispose the controller when the widget is removed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.secondaryBackground,
        elevation: 0, // No shadow
        centerTitle: true,
        toolbarHeight: 30,
        surfaceTintColor: Colors.transparent,
        title: Opacity(
          opacity: _opacityController.value,
          child: Text(
            "Setup", // AppBar title
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          ),
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollUpdateNotification) {
            double offset = scrollNotification.metrics.pixels;
            if (offset > 10) {
              _opacityController.forward(); // Start the fade-in animation
            } else {
              _opacityController.reverse();
            }
          }
          return true;
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              Padding(padding: EdgeInsets.only(top: 20)),
              Text(
                "General",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              // Profile Card
              GestureDetector(
                onTap: () {
                  context.push('/profile');
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.0), // Round top-left corner
                      topRight: Radius.circular(12.0), // Round top-right corner
                      bottomLeft:
                          Radius.zero, // Keep bottom-left corner rectangular
                      bottomRight:
                          Radius.zero, // Keep bottom-right corner rectangular
                    ),
                  ),
                  margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                  child: Column(
                    children: [
                      ListTile(
                        visualDensity: VisualDensity(vertical: -1),
                        leading: Icon(Icons.person),
                        title: Text(
                          'Profile',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color),
                        ),
                        trailing: Icon(Icons.keyboard_arrow_right_sharp),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 0.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Color.fromARGB(20, 255, 255, 255),
                                thickness: 1.0,
                                height: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Data Card
              Card(
                margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius
                      .zero, // Remove rounded corners to make it a regular box
                ),
                child: Column(
                  children: [
                    ListTile(
                      visualDensity: VisualDensity(vertical: -1),
                      leading: Icon(Icons.storage_rounded),
                      title: Text(
                        'Data',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      trailing: Icon(Icons.keyboard_arrow_right_sharp),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Color.fromARGB(20, 255, 255, 255),
                              thickness: 1.0,
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // System Card
              Card(
                margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12.0), // Round top-left corner
                    bottomRight:
                        Radius.circular(12.0), // Round top-right corner
                    topLeft: Radius.zero, // Keep bottom-left corner rectangular
                    topRight:
                        Radius.zero, // Keep bottom-right corner rectangular
                  ),
                ),
                child: Column(
                  children: [
                    ListTile(
                      visualDensity: VisualDensity(vertical: -1),
                      leading: Icon(Icons.settings),
                      title: Text(
                        'System',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      trailing: Icon(Icons.keyboard_arrow_right_sharp),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Color.fromARGB(0, 255, 255, 255),
                              thickness: 1.0,
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              Text(
                "Preferences",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              // Workouts Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0), // Round top-left corner
                    topRight: Radius.circular(12.0), // Round top-right corner
                    bottomLeft:
                        Radius.zero, // Keep bottom-left corner rectangular
                    bottomRight:
                        Radius.zero, // Keep bottom-right corner rectangular
                  ),
                ),
                margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                child: Column(
                  children: [
                    ListTile(
                      visualDensity: VisualDensity(vertical: -1),
                      leading: Icon(Icons.fitness_center_sharp),
                      title: Text(
                        'Workouts',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: Icon(Icons.keyboard_arrow_right_sharp),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 0.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Color.fromARGB(20, 255, 255, 255),
                              thickness: 1.0,
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Units Card
              GestureDetector(
                onTap: () {
                  context.push('/units');
                },
                child: Card(
                  margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius
                        .zero, // Remove rounded corners to make it a regular box
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        visualDensity: VisualDensity(vertical: -1),
                        leading: Icon(Icons.straighten_rounded),
                        title: Text(
                          'Units',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        trailing: Icon(Icons.keyboard_arrow_right_sharp),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Color.fromARGB(20, 255, 255, 255),
                                thickness: 1.0,
                                height: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Theme Card
              GestureDetector(
                onTap: () {
                  context.push('/theme');
                },
                child: Card(
                  margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft:
                          Radius.circular(12.0), // Round top-left corner
                      bottomRight:
                          Radius.circular(12.0), // Round top-right corner
                      topLeft:
                          Radius.zero, // Keep bottom-left corner rectangular
                      topRight:
                          Radius.zero, // Keep bottom-right corner rectangular
                    ),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        visualDensity: VisualDensity(vertical: -1),
                        leading: Icon(Icons.bedtime_outlined),
                        title: Text(
                          'Theme',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        trailing: Icon(Icons.keyboard_arrow_right_sharp),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Color.fromARGB(0, 255, 255, 255),
                                thickness: 1.0,
                                height: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              Text(
                "Info",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              // FAQ Card
              GestureDetector(
                onTap: () {
                  context.push('/faq');
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.0), // Round top-left corner
                      topRight: Radius.circular(12.0), // Round top-right corner
                      bottomLeft:
                          Radius.zero, // Keep bottom-left corner rectangular
                      bottomRight:
                          Radius.zero, // Keep bottom-right corner rectangular
                    ),
                  ),
                  margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                  child: Column(
                    children: [
                      ListTile(
                        visualDensity: VisualDensity(vertical: -1),
                        leading: Icon(Icons.question_mark_outlined),
                        title: Text(
                          'Frequently Asked Questions',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: Icon(Icons.keyboard_arrow_right_sharp),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 0.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Color.fromARGB(20, 255, 255, 255),
                                thickness: 1.0,
                                height: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Features Card
              Card(
                margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius
                      .zero, // Remove rounded corners to make it a regular box
                ),
                child: Column(
                  children: [
                    ListTile(
                      visualDensity: VisualDensity(vertical: -1),
                      leading: Icon(Icons.lightbulb),
                      title: Text(
                        'Feature Request',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      trailing: Icon(Icons.keyboard_arrow_right_sharp),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Color.fromARGB(20, 255, 255, 255),
                              thickness: 1.0,
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Review Card
              Card(
                margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius
                      .zero, // Remove rounded corners to make it a regular box
                ),
                child: Column(
                  children: [
                    ListTile(
                      visualDensity: VisualDensity(vertical: -1),
                      leading: Icon(Icons.star),
                      title: Text(
                        'Review Benchy',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      trailing: Icon(Icons.keyboard_arrow_right_sharp),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Color.fromARGB(20, 255, 255, 255),
                              thickness: 1.0,
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // About Card
              Card(
                margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12.0), // Round top-left corner
                    bottomRight:
                        Radius.circular(12.0), // Round top-right corner
                    topLeft: Radius.zero, // Keep bottom-left corner rectangular
                    topRight:
                        Radius.zero, // Keep bottom-right corner rectangular
                  ),
                ),
                child: Column(
                  children: [
                    ListTile(
                      visualDensity: VisualDensity(vertical: -1),
                      leading: Icon(Icons.info),
                      title: Text(
                        'About',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      trailing: Icon(Icons.keyboard_arrow_right_sharp),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Color.fromARGB(0, 255, 255, 255),
                              thickness: 1.0,
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
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
