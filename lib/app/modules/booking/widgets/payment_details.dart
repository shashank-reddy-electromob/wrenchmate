import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaymentDetails extends StatelessWidget {
  final String text;
  final String amount;
  const PaymentDetails({super.key, required this.text, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          Text(
            amount,
            style: TextStyle(
                color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w400),
          )
        ],
      ),
    );
  }
}
