import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class DurationWidget extends StatelessWidget {
  final IconData icon;
  final String titleText;
  final String subtitleText;
  final String durationText;


  const DurationWidget({
    Key? key,
    required this.icon,
    required this.titleText,
    required this.durationText, required this.subtitleText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12),
        Text(
          titleText,
          style: TextStyle(
            fontSize: 16,
            color: Color(0xff616161),
            fontWeight: FontWeight.w400,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Row(
            children: [
              
              Icon(
                icon,
                size: 24,
                color: (icon==CupertinoIcons.star)?Color(0xffFFE262):Color(0xff797979),
              ),
              Text(
                ' $durationText '+ subtitleText,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
