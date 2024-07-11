import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/booking_controller.dart';
import '../../data/models/booking_model.dart';

class BookingDetailPage extends StatefulWidget {
  @override
  State<BookingDetailPage> createState() => _BookingDetailPageState();
}

class _BookingDetailPageState extends State<BookingDetailPage> {
  final Booking bookings = Get.arguments;
  @override
  Widget build(BuildContext context) {
    final BookingController controller = Get.find();
    return Scaffold(
      appBar: AppBar(title: Text('Booking Details')),
      body: Center(child: Text(bookings.service.name)),
    );
  }
}
