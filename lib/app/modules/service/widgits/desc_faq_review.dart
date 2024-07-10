import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class descFaqReview extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  descFaqReview(
      {super.key,
      required this.text,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        width: MediaQuery.of(context).size.width * 0.24,
        decoration: BoxDecoration(
            color: isSelected ? Color(0xff3778F2) : Colors.white,
            borderRadius: BorderRadius.circular(12)),
        child: Text(
          textAlign: TextAlign.center,
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
