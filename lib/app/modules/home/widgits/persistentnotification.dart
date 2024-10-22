import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wrenchmate_user_app/app/routes/app_routes.dart';
import 'package:wrenchmate_user_app/utils/color.dart';
import 'package:glass/glass.dart';

class PersistentNotification extends StatelessWidget {
  final RxDouble totalAmount;
  final RxDouble discountAmount;

  PersistentNotification({
    Key? key,
    required this.totalAmount,
    required this.discountAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (totalAmount.value > 0.0) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20.0),
                topLeft : Radius.circular(20.0)),
          ),
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Total Amount: ₹${(totalAmount.value - discountAmount.value).toStringAsFixed(2)}',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.CART);
                },
                child: Text(
                  'Checkout',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    fontFamily: 'Raleway',
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ).asGlass();
      } else {
        return SizedBox
            .shrink(); // Hide the widget if totalAmount is not greater than 0
      }
    });
  }
}
