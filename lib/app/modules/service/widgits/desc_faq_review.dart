import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wrenchmate_user_app/utils/color.dart';
import 'package:wrenchmate_user_app/utils/textstyles.dart';

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
        padding: EdgeInsets.symmetric(vertical: 14),
        width: MediaQuery.of(context).size.width * 0.24,
        decoration: BoxDecoration(
            color: isSelected ? primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(8)),
        child: Text(
          textAlign: TextAlign.center,
          text,
          style: AppTextStyle.mediumRaleway12.copyWith(
            color: isSelected ? Colors.white : Colors.black,
          ),
          // style: TextStyle(
          //   fontSize: 16,
          //   fontWeight: FontWeight.w500,
          //   color: isSelected ? Colors.white : Colors.black,
          // ),
        ),
      ),
    );
  }
}
