import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  const Header({
    Key? key,
    required this.text,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: TextStyle(fontSize: 20),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            "See all",
            style: TextStyle(color: Color(0xffFF5402)),
          ),
        ),
      ],
    );
  }
}
