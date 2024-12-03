import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wrenchmate_user_app/app/controllers/booking_controller.dart';
import 'package:wrenchmate_user_app/app/routes/app_routes.dart';
import 'package:wrenchmate_user_app/app/widgets/appbar.dart';
import 'package:wrenchmate_user_app/globalVariables.dart';
import 'package:wrenchmate_user_app/utils/color.dart';
import 'package:wrenchmate_user_app/utils/textstyles.dart';
import '../../controllers/car_controller.dart';
import '../../controllers/tracking_controller.dart';

class TrackingPage extends StatefulWidget {
  @override
  _TrackingPageState createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  // Example state variables
  double distance = 5.0;
  int deliveryTime = 50;
  String driverName = 'Alex Gondron';
  double driverRating = 5.0;
  String carModel = 'Audi TT';
  String carPlate = 'YH1S44T';
  int currentStep = 2;

  int userCurrentCarIndex = 0;
  List<Map<String, dynamic>> userCars = [];
  String carType = '';
  String carTypeImage = ''; // Add this line

  late TextEditingController regYearController;
  late TextEditingController regNoController;
  late TextEditingController insuranceExpController;
  late TextEditingController pucExpController;

  final CarController carController = Get.put(CarController());
  BookingController bookingController = Get.put(BookingController());

  @override
  void initState() {
    super.initState();
    fetchUserCurrentCarIndex();
    bookingController.fetchUserBookings();
  }

  void fetchUserCurrentCarIndex() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('User').doc(userId).get();
    if (userDoc.exists) {
      setState(() {
        userCurrentCarIndex = userDoc['User_currentCar'] ?? 0;
      });
      fetchCarDetails();
    }
  }

  void fetchCarDetails() async {
    userCars = await carController.fetchUserCarDetails();
    carType = userCars[userCurrentCarIndex]['car_type'];
    if (carType == "Sedan") {
      carTypeImage = "sedan";
      carModel = userCars[userCurrentCarIndex]['car_model'];
      carPlate = userCars[userCurrentCarIndex]['registration_number'];
    } else if (carType == "Hatchback") {
      carTypeImage = "hatchback";
      carModel = userCars[userCurrentCarIndex]['car_model'];
      carPlate = userCars[userCurrentCarIndex]['registration_number'];
    } else if (carType == "Compact SUV") {
      carTypeImage = "compact_suv";
      carModel = userCars[userCurrentCarIndex]['car_model'];
      carPlate = userCars[userCurrentCarIndex]['registration_number'];
    } else if (carType == "SUV") {
      carTypeImage = "suv";
      carModel = userCars[userCurrentCarIndex]['car_model'];
      carPlate = userCars[userCurrentCarIndex]['registration_number'];
    }
    setState(() {});
  }

  String currentStatus = 'confirmed';

  double getCarPosition(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return 0.0;
      case 'pickedup':
        return 0.1;
      case 'serviceongoing':
        return 0.54;
      case 'beingdelivered':
        return 1.0;
      default:
        return 0.0;
    }
  }

  /*
  Sedan
  Hatchback
  Compact SUV
  SUV
   */

  @override
  Widget build(BuildContext context) {
    final TrackingController controller = Get.find();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Track your Location',
        onBackButtonPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height / 3,
                          decoration: new BoxDecoration(
                            image: new DecorationImage(
                              image: new ExactAssetImage(
                                  'assets/car/hatchback.png'),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                          child: new BackdropFilter(
                            filter: new ImageFilter.blur(
                                sigmaX: 10.0, sigmaY: 10.0),
                            child: new Container(
                              decoration: new BoxDecoration(
                                  color: Colors.white.withOpacity(0.0)),
                            ),
                          ),
                        ),
                        Center(
                          child: Column(
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.height / 7,
                                child: Image(
                                  image: AssetImage(
                                      "assets/tracking/location_marker.png"),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                '$distance Km away',
                                style: AppTextStyle.bold20
                                    .copyWith(color: Colors.white),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Deliver in ',
                                    style: AppTextStyle.semibold16
                                        .copyWith(color: Colors.black),
                                  ),
                                  Text(
                                    '$deliveryTime min',
                                    style: AppTextStyle.semibold16
                                        .copyWith(color: primaryColor),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              FutureBuilder(
                                future: Future.delayed(
                                  Duration(seconds: 1),
                                ),
                                builder: (c, s) =>
                                    s.connectionState == ConnectionState.done
                                        ? Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                9,
                                            child: Image.asset(
                                                "assets/car/$carTypeImage.png"),
                                          )
                                        : CircularProgressIndicator(),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 2.4,
                    margin: EdgeInsets.only(top: 40),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 16),
                        bookingController.BookingList.isEmpty
                            ? const SizedBox()
                            : bookingController.BookingList[0]
                                            ['assignedDriverName'] ==
                                        null &&
                                    bookingController.BookingList[0]
                                            ['assignedDriverPhone'] ==
                                        null
                                ? Text(
                                    'Driver Not Assigned',
                                    style: AppTextStyle.boldRaleway15
                                        .copyWith(color: primaryColor),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        bookingController.BookingList.isEmpty
                                            ? ''
                                            : bookingController.BookingList[0]
                                                    ['assignedDriverName'] ??
                                                'Driver not assigned',
                                        style: AppTextStyle.boldRaleway15
                                            .copyWith(color: primaryColor),
                                      ),
                                      Text(
                                        '  •  ',
                                        style: AppTextStyle.boldRaleway15
                                            .copyWith(color: primaryColor),
                                      ),
                                      Icon(Icons.star_border,
                                          color: Colors.yellow, size: 20),
                                      SizedBox(width: 5),
                                      Text(
                                        bookingController.driverRating.value.toString(),
                                        style: AppTextStyle.boldRaleway15
                                            .copyWith(color: primaryColor),
                                      ),
                                    ],
                                  ),
                        SizedBox(height: 10),
                        Text(
                          '$carModel • $carPlate',
                          style: AppTextStyle.boldRaleway15.copyWith(
                              color: primaryColor, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 60,
                          child: Stack(
                            children: [
                              // Progress line

                              Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Divider(
                                          color: currentStep >= 1
                                              ? primaryColor
                                              : greyColor,
                                          thickness: 4,
                                        ),
                                      ),
                                      Expanded(
                                        child: Divider(
                                          color: currentStep == 2
                                              ? primaryColor
                                              : greyColor,
                                          thickness: 4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              AnimatedPositioned(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                                left: bookingController.BookingList.isEmpty
                                    ? 0
                                    : getCarPosition(bookingController
                                            .BookingList[bookingController
                                                .BookingList.length -
                                            1]['status']) *
                                        (MediaQuery.of(context).size.width -
                                            120),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height / 16,
                                  child: Image(
                                    image: AssetImage(
                                        "assets/tracking/small_car.png"),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Update the status column widgets to be clickable for testing
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: buildStatusColumn(
                                "Picked\nup",
                                currentStatus == 'pickedup',
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: buildStatusColumn(
                                "Service ongoing",
                                currentStatus == 'serviceongoing',
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: buildStatusColumn(
                                "Being Delivered",
                                currentStatus == 'beingdelivered',
                              ),
                            ),
                          ],
                        ),

                        // Row(
                        //   children: [
                        //     Expanded(
                        //       child: Divider(
                        //         color:
                        //             currentStep >= 1 ? primaryColor : greyColor,
                        //         thickness: 4,
                        //       ),
                        //     ),
                        //     Container(
                        //       height: MediaQuery.of(context).size.height / 16,
                        //       child: Image(
                        //         image:
                        //             AssetImage("assets/tracking/small_car.png"),
                        //       ),
                        //     ),
                        //     // Container(
                        //     //   width: 40,
                        //     //   height: 40,
                        //     //   decoration: BoxDecoration(
                        //     //     color: currentStep == 1
                        //     //         ? Colors.blue
                        //     //         : Colors.grey,
                        //     //     shape: BoxShape.circle,
                        //     //   ),
                        //     //   child: Icon(Icons.directions_car,
                        //     //       color: Colors.white),
                        //     // ),
                        //     Expanded(
                        //       child: Divider(
                        //         color:
                        //             currentStep == 2 ? primaryColor : greyColor,
                        //         thickness: 4,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // SizedBox(height: 20),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //   children: [
                        //     Expanded(
                        //       child: buildStatusColumn(
                        //           "Picked\nup", currentStep >= 0),
                        //     ),
                        //     SizedBox(
                        //       width: 20,
                        //     ),
                        //     Expanded(
                        //       child: buildStatusColumn(
                        //           "Service ongoing", currentStep >= 1),
                        //     ),
                        //     SizedBox(
                        //       width: 20,
                        //     ),
                        //     Expanded(
                        //       child: buildStatusColumn(
                        //           "Being Delivered", currentStep >= 2),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: MediaQuery.of(context).size.width / 2 - 40,
                    child: CircleAvatar(
                      radius: 40,
                      // backgroundImage: AssetImage(''),
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 65,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 9,
                  child: Image.asset(
                    'assets/tracking/bottom_bg.jpg',
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Container(
                  height: 70,
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.phone, color: Colors.white, size: 30),
                        onPressed: () {
                          final driverPhone = bookingController.BookingList[0]
                              ['assignedDriverPhone'];
                          if (driverPhone != null && driverPhone.isNotEmpty) {
                            _makePhoneCall(driverPhone);
                          } else {
                            // Optionally show a message if the number is not available
                            Get.snackbar(
                              'Error',
                              'No phone number assigned to the driver.',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.chat, color: Colors.white, size: 30),
                        onPressed: () {
                          Get.toNamed(AppRoutes.CHATSCREEN);
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(phoneUri);
  }

  Container buildStatusColumn(String label, bool isActive) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x40000000), // #00000040
            blurRadius: 7.2,
          ),
        ],
        border: Border.all(
          color: isActive ? Color(0xFF3979F0) : Color(0xFF3979F066),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: AppTextStyle.semiboldpurple12
            .copyWith(color: primaryColor, fontWeight: FontWeight.w700),
        // style: TextStyle(
        //   color: isActive ? Colors.blue : Colors.grey,
        //   fontWeight: FontWeight.bold,
        // ),
      ),
    );
  }
}
