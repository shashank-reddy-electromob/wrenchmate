import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimeLineText extends StatelessWidget {
  final bool isPast;
  final String child;
  final String time;
  const TimeLineText(
      {super.key,
      required this.isPast,
      required this.child,
      required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                child,
                style: TextStyle(
                    fontSize: 15,
                    color: isPast ? Colors.black : Colors.grey,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                time,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            "Your Booking accepted",
            style: TextStyle(
              fontSize: 12,
              color: isPast ? Colors.black : Colors.grey,
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              color: isPast ? Colors.black : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
