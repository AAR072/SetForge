import 'package:benchy/styling/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen>
    with TickerProviderStateMixin {
  late AnimationController _opacityController;
  final List<bool> _expanded = List.generate(1, (_) => false);
  final List<double> _opacity = List.generate(1, (_) => 1.00);
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
              "Workout", // AppBar title
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
              child: ListView(shrinkWrap: true, children: [
                Padding(padding: EdgeInsets.only(top: 20)),
                Text(
                  "Quick Start",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                GestureDetector(
                  onTap: () {
                    context.push('/profile');
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12.0), // Round top-left corner
                        topRight:
                            Radius.circular(12.0), // Round top-right corner
                        bottomLeft:
                            Radius.circular(12.0), // Round top-right corner
                        bottomRight:
                            Radius.circular(12.0), // Round top-right corner
                      ),
                    ),
                    margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                    child: Column(
                      children: [
                        ListTile(
                          visualDensity: VisualDensity(vertical: -2),
                          leading: Icon(Icons.add),
                          title: Text(
                            'Start Empty Workout',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Palette.inverseThemeColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                Text(
                  "Routines",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                  12.0), // Round top-left corner
                              topRight: Radius.circular(
                                  12.0), // Round top-right corner
                              bottomLeft: Radius.circular(
                                  12.0), // Round top-right corner
                              bottomRight: Radius.circular(
                                  12.0), // Round top-right corner
                            ),
                          ),
                          margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                          child: Column(
                            children: [
                              ListTile(
                                visualDensity:
                                    VisualDensity(vertical: -2, horizontal: -4),
                                leading: Icon(Icons.assignment_outlined),
                                title: Text(
                                  'New Routine',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Palette.inverseThemeColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 6),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                  12.0), // Round top-left corner
                              topRight: Radius.circular(
                                  12.0), // Round top-right corner
                              bottomLeft: Radius.circular(
                                  12.0), // Round top-right corner
                              bottomRight: Radius.circular(
                                  12.0), // Round top-right corner
                            ),
                          ),
                          margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                          child: Column(
                            children: [
                              ListTile(
                                visualDensity:
                                    VisualDensity(vertical: -2, horizontal: -4),
                                leading: Icon(Icons.create_new_folder_outlined),
                                title: Text(
                                  'New Folder',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Palette.inverseThemeColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Theme(
                  data: Theme.of(context).copyWith(
                    splashFactory: NoSplash.splashFactory,
                    highlightColor:
                        Colors.transparent, // no grey background when tapped
                  ),
                  child: GestureDetector(
                    onTap: () {
                      // Fade-out effect
                      setState(() {
                        _opacity[0] = 0.5;
                      });
                      Future.delayed(Duration(milliseconds: 100), () {
                        setState(() {
                          _opacity[0] = 1.0;
                        });
                      });
                    },
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 150),
                      opacity: _opacity[0],
                      child: ExpansionTile(
                        backgroundColor: Colors.transparent,
                        collapsedBackgroundColor: Colors.transparent,
                        tilePadding:
                            EdgeInsets.zero, // optional: remove side padding
                        childrenPadding:
                            EdgeInsets.zero, // optional: clean spacing inside
                        leading: Icon(
                          _expanded[0]
                              ? Icons.keyboard_arrow_down
                              : Icons.keyboard_arrow_right_sharp,
                          color: Palette.inverseDimThemeColor,
                        ),
                        showTrailingIcon: false,
                        onExpansionChanged: (bool expanded) {
                          setState(() {
                            _expanded[0] = expanded;
                          });
                        },
                        title: Text(
                          'Clean Tile',
                          style: TextStyle(color: Palette.inverseDimThemeColor),
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Detail 1',
                                  style: TextStyle(
                                      color: Palette.inverseThemeColor),
                                ),
                                SizedBox(height: 8),
                                Text('Detail 2'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
            )));
  }
}
