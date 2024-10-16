import 'package:flutter/material.dart';
import 'package:wrenchmate_user_app/utils/textstyles.dart';

class Header extends StatelessWidget {
  final String text;
  final String? seeall;
  final VoidCallback? onTap;

  const Header({
    Key? key,
    required this.text,
    this.seeall,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: AppTextStyle.semibold14,
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            (seeall == null) ? '' : seeall!,
            style: TextStyle(color: Color(0xffFF5402), fontFamily: 'Poppins'),
          ),
        ),
      ],
    );
  }
}
