import 'package:flutter/material.dart';
import 'package:wrenchmate_user_app/utils/textstyles.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double textSize;

  CustomElevatedButton({required this.onPressed, required this.text, this.textSize = 14});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xff3778F2), // Background color
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: AppTextStyle.semibold14.copyWith(color: Colors.white, fontSize: textSize),
      ),
    );
  }
}
