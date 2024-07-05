import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/booking_controller.dart';

class BookingDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final BookingController controller = Get.find();
    return Scaffold(
      appBar: AppBar(title: Text('Booking Details')),
      body: Center(child: Text('Booking Detail Page')),
    );
  }
}
