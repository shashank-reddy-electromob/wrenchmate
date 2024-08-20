import 'package:flutter/material.dart';

class CustomErrorField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? errorText;

  CustomErrorField({required this.controller, required this.hintText, this.errorText});

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
            errorText: errorText,
            errorStyle: TextStyle(
              color: Colors.redAccent, // Hint text color
              fontSize: 16,
              fontWeight: FontWeight.w500
            ),
            hintStyle: TextStyle(
              color: Color(0xffE9E9E9), // Hint text color
              fontSize: 18, // Hint text size
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.redAccent), // Color when error is displayed
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
