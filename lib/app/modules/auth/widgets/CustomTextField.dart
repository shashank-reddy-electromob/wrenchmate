import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isStarred; // New optional parameter to show a red star.

  CustomTextField({
    required this.controller,
    required this.hintText,
    this.isStarred = false, // Defaults to false.
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: controller,
        cursorColor: Colors.grey,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontFamily: 'Poppins',
        ),
        decoration: InputDecoration(
          label: isStarred
              ? RichText(
                  text: TextSpan(
                    text: hintText,
                    style: TextStyle(
                      color: Color(0xffE9E9E9),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                    ),
                    children: [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                )
              : Text(
                  hintText,
                  style: TextStyle(
                    color: Color(0xffE9E9E9),
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                ),
          contentPadding: EdgeInsets.only(top: 20, bottom: 10),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
