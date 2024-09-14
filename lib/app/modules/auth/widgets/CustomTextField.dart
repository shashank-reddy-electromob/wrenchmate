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
        style:
            TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Poppins'),
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
                color: Color(0xffE9E9E9), fontSize: 16, fontFamily: 'Poppins'),
            contentPadding: EdgeInsets.symmetric(vertical: 16.0),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
              ),
            ),
            border: UnderlineInputBorder(
                borderSide: BorderSide(
              color: Colors.grey,
            ))),
      ),
    );
  }
}
