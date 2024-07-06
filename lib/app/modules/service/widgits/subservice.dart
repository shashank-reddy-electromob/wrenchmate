import 'package:flutter/material.dart';

class SubService extends StatelessWidget {
  final String imagePath;
  final String text;

  const SubService({
    Key? key,
    required this.imagePath,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        children: [
          Image.asset(
            imagePath,
            fit: BoxFit.contain,
            height: 60,
            width: 60,
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
