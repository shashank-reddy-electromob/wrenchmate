import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/booking_controller.dart';

class BookingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final BookingController controller = Get.find();
    return Scaffold(
      appBar: AppBar(title: Text('Bookings')),
      body: Center(child: Text('Booking Page')),
    );
  }
}
