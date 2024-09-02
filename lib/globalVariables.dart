import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:wrenchmate_user_app/app/controllers/cart_controller.dart';
import 'package:wrenchmate_user_app/app/data/models/Service_firebase.dart';
import 'package:wrenchmate_user_app/app/routes/app_routes.dart';
import 'package:wrenchmate_user_app/utils/color.dart';

final Map<String, String> categoryImageMap = {
  "Car Wash": 'assets/services/car wash.png',
  "Detailing": 'assets/services/detailing.png',
  "Denting and Painting": 'assets/services/painting.png',
  "Repairing": 'assets/services/repair.png',
  "Accessories": 'assets/services/accessories.png',
  "Wheel Service": 'assets/services/wheelservice.png',
  "Body Parts": 'assets/services/body parts.png',
  "General Service": 'assets/services/general service.png',
};
Future<void> addToCartSnackbar(BuildContext context, Servicefirebase service,
    CartController cartController) async {
  print("adding to cart");
  await cartController.addToCart(serviceId: service.id);
  print("added to cart");

  cartController.totalAmount.value += service.price;
  print(
      "cartController.totalAmount.value :: ${cartController.totalAmount.value}");
  if (!context.mounted) return;

  final snackBar = SnackBar(
    backgroundColor: primaryColor,
    content: Obx(() => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Total Amount: \₹${cartController.totalAmount.value.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  Get.toNamed(AppRoutes.CART);
                },
                child: Text(
                  'Checkout',
                  style: TextStyle(
                    fontSize: 16,
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
        )),
    duration: Duration(days: 1), // Snackbar duration
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);

  cartController.totalAmount.listen((newTotal) {
    if (!context.mounted) return; // Check again before updating the Snackbar
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  });
}
