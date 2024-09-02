import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wrenchmate_user_app/app/modules/booking/widgets/payment_details.dart';
import 'package:wrenchmate_user_app/app/modules/booking/widgets/timelineTile.dart';
import 'package:wrenchmate_user_app/app/widgets/custombackbutton.dart';

import '../../data/models/Service_firebase.dart';
import '../../data/models/booking_model.dart';
import '../../routes/app_routes.dart';

String formatDateTime(DateTime dateTime) {
  final DateFormat formatter = DateFormat('EEE, MMM dd, yyyy');
  return formatter.format(dateTime);
}

class BookingDetailPage extends StatefulWidget {
  @override
  State<BookingDetailPage> createState() => _BookingDetailPageState();
}

class _BookingDetailPageState extends State<BookingDetailPage> {
  late Servicefirebase service;
  late Booking booking;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments; // Get all arguments
    service = args['service']; // Retrieve service
    booking = args['booking']; // Retrieve booking

    print("Current status: ${booking.status ?? "unknown"}"); // Debugging line
  }

  @override
  Widget build(BuildContext context) {
    // Use the booking and service details
    final String serviceName = service.name; // Use service name
    final String statusName = booking.status ?? "unknown";
    final double servicePrice = service.price; // Use service price
    final String bookingDate = booking.confirmationDate != null 
        ? formatDateTime(booking.confirmationDate!) 
        : "No Date"; // Use booking confirmation date
    final double itemTotal = 100.0;
    final double discount = 10.0;
    final double tax = 5.0;
    final double totalAmount = itemTotal - discount + tax;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Custombackbutton(),
        title: Text(
          "Booking Details",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Service details
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          serviceName,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Text('Rs. $servicePrice',
                            style: TextStyle(
                                fontSize: 18, color: Color(0xff6E6E6E))),
                      ],
                    ),
                  ],
                ),
              ),
              // Buttons
              statusName == "completed"
                  ? Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 60,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.1),
                                spreadRadius: 5,
                                blurRadius: 15,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Container(
                                  height: 60,
                                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Get.toNamed(AppRoutes.REVIEW, arguments: service);
                                    },
                                    child: Text(
                                      'WRITE A REVIEW',
                                      style: TextStyle(color: Color(0xff1671D8)),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      side: BorderSide(
                                          color: Color(0xff1671D8), width: 1),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                                  height: 60,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    child: Text(
                                      'BOOK AGAIN',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xff1671D8),
                                      side: BorderSide(
                                          color: Colors.white, width: 1),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 32),
                      ],
                    )
                  : Container(),
              // Booking status
              Text(
                "Booking Status",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              ),
              TimeLineTile(
                isFirst: true,
                isLast: false,
                isPast: statusName == "confirmed" ||
                    statusName == "ongoing" ||
                    statusName == "completed",
                timeLineText: "Booking Confirmed",
                date: bookingDate,
              ),
              TimeLineTile(
                isFirst: false,
                isLast: false,
                isPast: statusName == "ongoing" ||
                    statusName == "completed",
                timeLineText: "Out For Service",
                date: bookingDate,
              ),
              TimeLineTile(
                isFirst: false,
                isLast: true,
                isPast: statusName == "completed",
                timeLineText: "Service Completed",
                date: bookingDate,
              ),
              SizedBox(height: 32),
              Text(
                "Payment Summary",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              ),
              PaymentDetails(
                text: 'Item Total',
                amount: itemTotal.toString(),
              ),
              PaymentDetails(
                text: 'Discount Applied',
                amount: discount.toString(),
              ),
              PaymentDetails(
                text: 'Tax',
                amount: tax.toString(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  Text(
                    totalAmount.toString(),
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}