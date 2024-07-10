import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;

  CustomElevatedButton({required this.onPressed});

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
        '+Add',
        style: TextStyle(fontSize: 14),
      ),
    );
  }
}
