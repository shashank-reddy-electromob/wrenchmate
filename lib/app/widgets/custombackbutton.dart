import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Custombackbutton extends StatelessWidget {
  const Custombackbutton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffF6F6F5),
        borderRadius: BorderRadius.circular(30),
      ),
      child: IconButton(
        icon: Icon(
          CupertinoIcons.back,
          color: Color(0xff1E1E1E),
          size: 22,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
