import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/cart_controller.dart';

class BookingDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CartController controller = Get.find();
    return Scaffold(
      appBar: AppBar(title: Text('Booking Details')),
      body: Center(child: Text('Booking Details Page')),
    );
  }
}
