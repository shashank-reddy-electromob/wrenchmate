import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:wrenchmate_user_app/app/controllers/booking_controller.dart';
import 'package:wrenchmate_user_app/app/modules/booking/widgets/bottomSheet.dart';
import 'package:wrenchmate_user_app/app/modules/booking/widgets/payment_details.dart';
import 'package:wrenchmate_user_app/app/modules/booking/widgets/subscriptionCard.dart';
import 'package:wrenchmate_user_app/app/modules/booking/widgets/timelineTile.dart';
import 'package:wrenchmate_user_app/app/widgets/custombackbutton.dart';

import '../../data/models/Service_firebase.dart';
import '../../data/models/booking_model.dart';
import '../../routes/app_routes.dart';

String formatDateTime(DateTime dateTime) {
  final DateFormat formatter = DateFormat('EEE, MMM dd, yyyy');
  return formatter.format(dateTime);
}

class SubscriptionBookingDetailPage extends StatefulWidget {
  @override
  State<SubscriptionBookingDetailPage> createState() => _SubscriptionBookingDetailPageState();
}

class _SubscriptionBookingDetailPageState extends State<SubscriptionBookingDetailPage> {
  late Servicefirebase service;
  BookingController bookingController = Get.find<BookingController>();
  @override
  void initState() {
    super.initState();
  }

  String _getCarImage(String carType) {
    switch (carType) {
      case 'Compact SUV':
        return 'assets/car/compact_suv.png';
      case 'Hatchback':
        return 'assets/car/hatchback.png';
      case 'SUV':
        return 'assets/car/suv.png';
      case 'Sedan':
        return 'assets/car/sedan.png';
      default:
        return 'assets/car/default_car.png';
    }
  }

  String _formatTime(double value) {
    int hours = value.toInt();
    String formattedTime = '${hours.toString().padLeft(2, '0')}:00';
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    final String serviceName = bookingController.benefitsList[0]['name'];
    final String statusName = bookingController.subsBookingList[0]['status'];
    final String carType = bookingController.subsBookingList[0]['car_details'];
    final double servicePrice = 22;
    final String bookingDate = bookingController.formatTimestamp(
        bookingController.subsBookingList[0]['confirmation_date']);
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
              fontSize: 24, fontWeight: FontWeight.w500, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  children: [
                    Image.asset(
                      _getCarImage(carType),
                      height: 60,
                      width: 100,
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          serviceName,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        Text('Rs. $servicePrice',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff6E6E6E))),
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
                          height: 45,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Container(
                                  height: 60,
                                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Get.toNamed(AppRoutes.REVIEW,
                                          arguments: service);
                                    },
                                    child: Text(
                                      'WRITE A REVIEW',
                                      style: TextStyle(
                                          color: Color(0xff1671D8),
                                          fontWeight: FontWeight.w400),
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
                                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                                  height: 60,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    child: Text(
                                      'BOOK AGAIN',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400),
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
                        SizedBox(height: 32),
                      ],
                    )
                  : Container(),
              Obx(() {
                return Container(
                  height: 140,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: bookingController.benefitsList.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final benefit = bookingController.benefitsList[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            _showBottomSheet(
                                context,
                                benefit['name'],
                                DateFormat("d MMMM, yyyy").parse(
                                    bookingController.formatTimestamp(
                                        bookingController.subsBookingList[0]
                                            ['confirmation_date'])),
                                bookingController.subsBookingList[0]
                                    ['selected_time_range']['start'],
                                bookingController.subsBookingList[0]
                                    ['selected_time_range']['end'],
                                int.parse(benefit['num']));
                          },
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.85,
                            child: SubscriptionCard(
                                title: benefit['name'],
                                startDate: DateFormat("d MMMM, yyyy").parse(
                                    bookingController.formatTimestamp(
                                        bookingController.subsBookingList[0]
                                            ['confirmation_date'])),
                                totalSlots: int.parse(benefit['num']),
                                selectedSlotIndex: 0),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),

              SizedBox(
                height: 20,
              ),
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
                isPast: statusName == "ongoing" || statusName == "completed",
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
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              SizedBox(
                height: 10,
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
              SizedBox(
                height: 10,
              ),
              Container(
                height: 1,
                color: Colors.grey.shade200,
              ),
              SizedBox(
                height: 10,
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

  void _showBottomSheet(BuildContext context, String title, DateTime startDate,
      double startTime, double endTime, int slots) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return BottomSheetContent(
            title: title,
            startDate: startDate,
            startTime: startTime,
            endTime: endTime,
            slots: slots);
      },
    );
  }
}
