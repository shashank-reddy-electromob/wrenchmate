import 'package:flutter/material.dart';

class Pricing extends StatelessWidget {
  String text;
  String price;
  Pricing({super.key, required this.text, required this.price});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
                color: Color(0xff888888), fontSize: 14, fontFamily: 'Raleway'),
          ),
          Text(
            '\₹ $price',
            style: TextStyle(
                color: Color(0xff888888), fontSize: 14, fontFamily: 'Poppins'),
          ),
        ],
      ),
    );
  }
}
