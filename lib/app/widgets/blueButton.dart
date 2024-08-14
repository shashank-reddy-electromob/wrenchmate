import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class blueButton extends StatelessWidget {
  final String text;
  final double buttonHeight;
  final onTap;
  const blueButton(
      {super.key,
      required this.text,
      required this.onTap,
      this.buttonHeight = 16.0});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 4),
        child: Text(
          text,
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: buttonHeight),
        backgroundColor: Color(0XFF1671D8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              18.0), // Adjust the radius to make it more rectangular
        ),
      ),
    );
  }
}
