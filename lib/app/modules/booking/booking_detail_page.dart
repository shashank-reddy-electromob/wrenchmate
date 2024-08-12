import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:wrenchmate_user_app/app/modules/booking/widgets/payment_details.dart';
import 'package:wrenchmate_user_app/app/modules/booking/widgets/timelineTile.dart';
import 'package:wrenchmate_user_app/app/widgets/custombackbutton.dart';

import '../../data/models/Service_Firebase.dart';

String formatDateTime(DateTime dateTime) {
  final DateFormat formatter = DateFormat('EEE, MMM dd, yyyy');
  return formatter.format(dateTime);
}

class BookingDetailPage extends StatefulWidget {
  @override
  State<BookingDetailPage> createState() => _BookingDetailPageState();
}

class _BookingDetailPageState extends State<BookingDetailPage> {
  late ServiceFirebase service;

  @override
  void initState() {
    service = Get.arguments;
  }
  @override
  Widget build(BuildContext context) {
    // Dummy values
    final String serviceName = "Service Name";
    final String statusName = "completed";
    final double servicePrice = 100.0;
    final String bookingDate = "2023-10-01";
    final double itemTotal = 100.0;
    final double discount = 10.0;
    final double tax = 5.0;
    final double totalAmount = itemTotal - discount + tax;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.transparent,
        leading:  Custombackbutton(),
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
          child:
              Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //car deetails
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    children: [
                      //add image
                      //service name
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service.name, // Updated
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          Text('Rs. ${service.price}', // Updated
                              style: TextStyle(
                                  fontSize: 18, color: Color(0xff6E6E6E))),
                        ],
                      ),
                    ],
                  ),
                ),
                //buttons
                statusName == "completed" // Updated
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
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                       // Get.toNamed(AppRoutes.REVIEW, arguments: service);
                                      },
                                      child: Text(
                                        'WRITE A REVIEW',
                                        style:
                                            TextStyle(color: Color(0xff1671D8)),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        side: BorderSide(
                                            color: Color(0xff1671D8), width: 1),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 8.0),
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
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 32,
                          ),
                        ],
                      )
                    : Container(),
                //booking status

                Text(
                  "Booking Status",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                ),
                TimeLineTile(
                    isFirst: true,
                    isLast: false,
                    isPast: statusName == "confirmed" ||
                        statusName == "ongoing" ||
                        statusName == "completed", // Updated
                    timeLineText: "Booking Confirmed", // Updated
                    date: formatDateTime(DateTime.parse(bookingDate)), // Updated
                ),
                TimeLineTile(
                    isFirst: false,
                    isLast: false,
                    isPast: statusName == "ongoing" ||
                        statusName == "completed", // Updated
                    timeLineText: "Out For Service", // Updated
                    date: formatDateTime(DateTime.parse(bookingDate)), // Updated
                ),
                TimeLineTile(
                    isFirst: false,
                    isLast: true,
                    isPast: statusName == "completed", // Updated
                    timeLineText: "Service Completed", // Updated
                    date: formatDateTime(DateTime.parse(bookingDate)), // Updated
                ),
                SizedBox(
                  height: 32,
                ),

                Text(
                  "Payment Summary",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                ),

                PaymentDetails(
                  text: 'Item Total',
                  amount: itemTotal.toString(), // Updated
                ),
                PaymentDetails(
                  text: 'Discount Applied',
                  amount: discount.toString(), // Updated
                ),
                PaymentDetails(
                  text: 'Tax',
                  amount: tax.toString(), // Updated
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    Text(
                      totalAmount.toString(), // Updated
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(height: 32,)
              ],
            ),
          )),
    );
  }
}