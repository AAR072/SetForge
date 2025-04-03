import 'package:benchy/prefs.dart';
import 'package:benchy/styling/colors.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class UnitsScreen extends StatelessWidget {
  const UnitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryBackground,
      appBar: AppBar(
        backgroundColor: secondaryBackground,
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
            "Units", // AppBar title
            style: TextStyle(
              color: Colors.white,
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
          Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 20)),
              Text(
                "Weight",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 10)),
              ToggleSwitch(
                initialLabelIndex: (() {
                  final distanceMetric = SharedPrefsHelper.getInt("weightImperial");
                  if (distanceMetric == null) {
                    SharedPrefsHelper.setInt("weightImperial", 0);
                    return 0;
                  }
                  return distanceMetric;
                })(),
                minWidth: double.maxFinite,
                activeBgColors: [[Colors.white], [Colors.white]],
                activeFgColor: Colors.black,
                inactiveBgColor: tertiaryBackground,
                inactiveFgColor: Colors.white,
                totalSwitches: 2,
                labels: ['kg', 'lbs'],
                onToggle: (index) {
                  if (index != null) SharedPrefsHelper.setInt("weightImperial", index);
                },
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              Text(
                "Distance",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 10)),
              ToggleSwitch(
                initialLabelIndex: (() {
                  final distanceMetric = SharedPrefsHelper.getInt("distanceImperial");
                  if (distanceMetric == null) {
                    SharedPrefsHelper.setInt("distanceImperial", 0);
                    return 0;
                  }
                  return distanceMetric;
                })(),
                minWidth: double.maxFinite,
                activeBgColors: [[Colors.white], [Colors.white]],
                activeFgColor: Colors.black,
                inactiveBgColor: tertiaryBackground,
                inactiveFgColor: Colors.white,
                totalSwitches: 2,
                labels: ['Kilometres', 'Miles'],
                onToggle: (index) {
                  if (index != null) SharedPrefsHelper.setInt("distanceImperial", index);
                },
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              Text(
                "Body Measurement",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 10)),
              ToggleSwitch(
                initialLabelIndex: (() {
                  final distanceMetric = SharedPrefsHelper.getInt("bodyMeasurementsImperial");
                  if (distanceMetric == null) {
                    SharedPrefsHelper.setInt("bodyMeasurementsImperial", 0);
                    return 0;
                  }
                  return distanceMetric;
                })(),
                minWidth: double.maxFinite,
                activeBgColors: [[Colors.white], [Colors.white]],
                activeFgColor: Colors.black,
                inactiveBgColor: tertiaryBackground,
                inactiveFgColor: Colors.white,
                totalSwitches: 2,
                labels: ['Centimetres', 'Inches'],
                onToggle: (index) {
                  if (index != null) SharedPrefsHelper.setInt("bodyMeasurementsImperial", index);
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
