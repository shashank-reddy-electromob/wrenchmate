import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class containerButton extends StatelessWidget {
  String text;
  final VoidCallback onPressed; // Added function parameter
  final IconData icon; // Added icon parameter

  containerButton(
      {super.key,
      required this.text,
      required this.onPressed,
      required this.icon}); // Updated constructor

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      height: 70,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                width: 8,
              ),
              Icon(
                icon,
                color: Colors.blue,
                size: 24,
              ), // Updated to use the icon parameter
              SizedBox(
                width: 18,
              ),
              Text(
                text,
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400),
              )
            ],
          ),
          IconButton(
              onPressed: onPressed,
              icon: Icon(
                Icons.navigate_next_rounded,
                color: CupertinoColors.black,
              )) // Updated onPressed
        ],
      ),
    );
  }
}
