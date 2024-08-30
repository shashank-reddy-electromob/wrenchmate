import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:wrenchmate_user_app/app/routes/app_routes.dart';
import 'package:wrenchmate_user_app/app/widgets/appbar.dart';
import 'package:wrenchmate_user_app/utils/color.dart';
import 'package:wrenchmate_user_app/utils/textstyles.dart';
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
  int currentStep = 1;

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
                        Image.asset(
                          'assets/tracking/blur_bg.jpg',
                          fit: BoxFit.cover,
                        ),
                        Center(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                '$distance Km away',
                                style: AppTextStyle.bold20
                                    .copyWith(color: primaryColor),
                              ),
                              Text(
                                'Deliver in $deliveryTime min',
                                style: AppTextStyle.semibold16
                                    .copyWith(color: primaryColor),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              driverName,
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
                              driverRating.toString(),
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
                        SizedBox(height: 30),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color:
                                    currentStep >= 1 ? primaryColor : greyColor,
                                thickness: 4,
                              ),
                            ),
                            SvgPicture.asset('assets/tracking/small_car.svg'),
                            // Container(
                            //   width: 40,
                            //   height: 40,
                            //   decoration: BoxDecoration(
                            //     color: currentStep == 1
                            //         ? Colors.blue
                            //         : Colors.grey,
                            //     shape: BoxShape.circle,
                            //   ),
                            //   child: Icon(Icons.directions_car,
                            //       color: Colors.white),
                            // ),
                            Expanded(
                              child: Divider(
                                color:
                                    currentStep == 2 ? primaryColor : greyColor,
                                thickness: 4,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: buildStatusColumn(
                                  "Picked\nup", currentStep >= 0),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: buildStatusColumn(
                                  "Service ongoing", currentStep >= 1),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: buildStatusColumn(
                                  "Being Delivered", currentStep >= 2),
                            ),
                          ],
                        ),
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
                Image.asset(
                  'assets/tracking/bottom_bg.jpg',
                  fit: BoxFit.cover,
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
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.chat, color: Colors.white, size: 30),
                        onPressed: () {
                          Get.toNamed(AppRoutes.CHATSCREEN);
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
