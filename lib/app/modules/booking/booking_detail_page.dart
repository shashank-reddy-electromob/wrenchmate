import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wrenchmate_user_app/app/modules/booking/widgets/payment_details.dart';
import 'package:wrenchmate_user_app/app/modules/booking/widgets/timelineTile.dart';
import '../../controllers/booking_controller.dart';
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
  final Booking bookings = Get.arguments;
  @override
  Widget build(BuildContext context) {
    final BookingController controller = Get.find();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: //(child: Text(bookings.service.name)),
              Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 40,
                ),
                //appbar
                Row(
                  children: [
                    //back button
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xffF6F6F5),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: IconButton(
                        icon: Icon(
                          CupertinoIcons.back,
                          color: Color(0xff1E1E1E),
                          size: 22,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      "Booking Details",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    )
                  ],
                ),
                //car deetails
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Row(
                    children: [
                      //add image
                      //service name
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bookings.status.name,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          Text('Rs. ${bookings.service.price}',
                              style: TextStyle(
                                  fontSize: 18, color: Color(0xff6E6E6E))),
                        ],
                      ),
                    ],
                  ),
                ),
                //buttons
                bookings.status.name == "completed"
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
                                        Get.toNamed(AppRoutes.REVIEW, arguments: bookings.service);
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
                    isPast: bookings.status.name == "confirmed" ||
                        bookings.status.name == "ongoing" ||
                        bookings.status.name == "completed",
                    timeLineText: "Booking Confirmed",
                    date: formatDateTime(bookings.date).toString()),
                TimeLineTile(
                    isFirst: false,
                    isLast: false,
                    isPast: bookings.status.name == "ongoing" ||
                        bookings.status.name == "completed",
                    timeLineText: "Out For Service",
                    date: formatDateTime(bookings.date).toString()),
                TimeLineTile(
                    isFirst: false,
                    isLast: true,
                    isPast: bookings.status.name == "completed",
                    timeLineText: "Service Completed",
                    date: formatDateTime(bookings.date).toString()),
                SizedBox(
                  height: 32,
                ),

                Text(
                  "Payment Summary",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                ),

                PaymentDetails(
                  text: 'Item Total',
                  amount: bookings.paymentSummary.amount.toString(),
                ),
                PaymentDetails(
                  text: 'Discount Applied',
                  amount: bookings.paymentSummary.discount.toString(),
                ),
                PaymentDetails(
                  text: 'Tax',
                  amount: bookings.paymentSummary.tax.toString(),
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
                      bookings.paymentSummary.totalAmount.toString(),
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
