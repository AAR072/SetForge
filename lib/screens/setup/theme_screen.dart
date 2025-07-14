import 'package:setforge/prefs.dart';
import 'package:setforge/styling/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ThemeScreen extends StatelessWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.secondaryBackground,
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
            "Theme", // AppBar title
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
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
            Column(
              children: [
                Padding(padding: EdgeInsets.only(top: 20)),
                Text(
                  "Set the brightness mode",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                ToggleSwitch(
                  initialLabelIndex: SharedPrefsHelper.isDarkMode ? 0 : 1,
                  minWidth: double.maxFinite,
                  activeBgColors: [
                    [Palette.inverseThemeColor],
                    [Palette.inverseThemeColor]
                  ],
                  activeFgColor: Palette.themeColor,
                  inactiveBgColor: Palette.inactiveBgColor,
                  inactiveFgColor: Palette.inverseThemeColor,
                  totalSwitches: 2,
                  labels: ['Dark Mode', 'Light Mode'],
                  icons: [Icons.dark_mode, Icons.sunny],
                  onToggle: (index) {
                    if (index != null) {
                      showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return AlertDialog(
                            title: Text("Warning"),
                            content: Text(
                                "This will restart the app and delete any unsaved workouts. Do you want to continue?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(dialogContext)
                                      .pop(); // Close dialog
                                },
                                child: Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(dialogContext)
                                      .pop(); // Close dialog
                                  SharedPrefsHelper.setBoolean(
                                      "darkMode", index == 0);
                                  SystemChrome.setSystemUIOverlayStyle(
                                      SystemUiOverlayStyle(
                                    // Make the bar transparent
                                    systemNavigationBarColor:
                                        Colors.transparent,
                                    systemNavigationBarContrastEnforced: false,
                                    systemNavigationBarIconBrightness:
                                        SharedPrefsHelper.isDarkMode
                                            ? Brightness.light
                                            : Brightness.dark,
                                    statusBarColor: Colors.transparent,
                                    statusBarBrightness:
                                        SharedPrefsHelper.isDarkMode
                                            ? Brightness.dark
                                            : Brightness.light,
                                  ));
                                  // Ensure Phoenix.rebirth() runs after the dialog is fully closed
                                  Future.microtask(
                                      () => Phoenix.rebirth(context));
                                },
                                child: Text("OK"),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
