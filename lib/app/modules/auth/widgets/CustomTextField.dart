import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  CustomTextField({required this.controller, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: controller,
        cursorColor: Colors.grey,
        style: TextStyle(
          color: Colors.black, // Entered text color
          fontSize: 18, // Entered text size
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey, // Hint text color
            fontSize: 18, // Hint text size
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 16.0),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey, // Active bottom border color
            ),
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            )
          )
        ),
      ),
    );
  }
}
