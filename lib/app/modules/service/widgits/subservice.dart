import 'package:flutter/material.dart';

class SubService extends StatelessWidget {
  final String imagePath;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const SubService({
    Key? key,
    required this.imagePath,
    required this.text,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Column(
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: isSelected ? Color(0xff3778F2) : Color(0xffF7F7F7),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(
                  imagePath,
                ),
              ),
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
