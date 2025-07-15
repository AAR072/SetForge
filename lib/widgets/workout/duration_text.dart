import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:setforge/helpers/session_helpers.dart';
import 'package:setforge/styling/colors.dart';

class DurationText extends StatefulWidget {
  final DateTime startTime;
  const DurationText({required this.startTime, Key? key}) : super(key: key);

  @override
  State<DurationText> createState() => _DurationTextState();
}

class _DurationTextState extends State<DurationText> {
  late Timer _timer;
  late String _durationText;

  @override
  void initState() {
    super.initState();
    _durationText = timeConverter(widget.startTime);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _durationText = timeConverter(widget.startTime);
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _durationText,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Palette.inverseThemeColor,
      ),
    );
  }
}
