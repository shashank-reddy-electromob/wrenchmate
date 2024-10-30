import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContainerButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData icon;
  final Widget? trailingWidget; // Make trailingWidget optional

  ContainerButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.icon,
    this.trailingWidget, // Optional parameter
  });

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
              SizedBox(width: 8),
              Icon(
                icon,
                color: Colors.blue,
                size: 24,
              ),
              SizedBox(width: 18),
              Text(
                text,
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          GestureDetector(
              onTap: onPressed,
              child: trailingWidget ??
                  IconButton(
                      onPressed: onPressed,
                      icon: Icon(
                        Icons.navigate_next_rounded,
                        color: CupertinoColors.black,
                      ))),
        ],
      ),
    );
  
  
  
  }
}
