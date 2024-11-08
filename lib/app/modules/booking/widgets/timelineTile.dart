import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:wrenchmate_user_app/app/modules/booking/widgets/timeLineText.dart';

class TimeLineTile extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final bool isPast;
  final String timeLineText;
  final String date;

  const TimeLineTile({
    Key? key,
    required this.isFirst,
    required this.isLast,
    required this.isPast,
    required this.timeLineText,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140.0,
      child: TimelineTile(
        isFirst: isFirst,
        isLast: isLast,
        beforeLineStyle: LineStyle(
          color: isPast ? Color(0xff1671D8) : Colors.blue.shade100,
          thickness: 2.0,
        ),
        afterLineStyle: LineStyle(
          color: isPast ? Color(0xff1671D8) : Colors.blue.shade100,
          thickness: 2.0,
        ),
        indicatorStyle: IndicatorStyle(
          color: isPast ? Color(0xff1671D8) : Colors.blue.shade100,
          width: 20.0, // Adjust the size of the indicator
          height: 20.0, // Adjust the size of the indicator
        ),
        endChild: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: TimeLineText(
            isPast: isPast,
            time: date,
            child: timeLineText,
          ),
        ),
      ),
    );
  }
}
