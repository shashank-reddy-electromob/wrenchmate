import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wrenchmate_user_app/utils/textstyles.dart';
import '../../controllers/car_controller.dart';
import '../../routes/app_routes.dart';

class SubscriptionPage extends StatefulWidget {
  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  bool isMonthly = true;

  int userCurrentCarIndex = 0;
  List<Map<String, dynamic>> userCars = [];
  String carType = '';
  String carTypeImage = ''; // Add this line

  late TextEditingController regYearController;
  late TextEditingController regNoController;
  late TextEditingController insuranceExpController;
  late TextEditingController pucExpController;

  final CarController carController = Get.put(CarController());

  @override
  void initState() {
    super.initState();
    fetchUserCurrentCarIndex();
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
    } else if (carType == "Hatchback") {
      carTypeImage = "hatchback";
    } else if (carType == "Compact SUV") {
      carTypeImage = "compact_suv";
    } else if (carType == "SUV") {
      carTypeImage = "suv";
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 12,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white, // Background color
                borderRadius: BorderRadius.circular(12.0), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 0,
                    blurRadius: 2,
                    offset: Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                children: [
                  FutureBuilder(
                    future: Future.delayed(
                      Duration(seconds: 1),
                    ),
                    builder: (c, s) => s.connectionState == ConnectionState.done
                        ? Container(
                            width: MediaQuery.of(context).size.height / 8,
                            child: Image.asset("assets/car/$carTypeImage.png"),
                          )
                        : Container(
                            child: CircularProgressIndicator(),
                          ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      "Keep your car in top shape all year round with our hassle-free service subscription—convenience, savings, and expert care, all in one package!",
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Upgrade to',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff01417E),
              ),
            ),
            SizedBox(height: 16),
            Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xffC6DFFE),
                    borderRadius: isMonthly
                        ? BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          )
                        : BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: isMonthly
                        ? [
                            Text(
                              "Essential Need Pack",
                              style: TextStyle(
                                  fontFamily: 'Raleway',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                      SizedBox(height: 8),
                      Text(
                        "-> 4 washes",
                        style: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        " - Basic exterior cleaning to remove dust and dirt.",
                        style: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                     // SizedBox(height: 8),
                     // Text(
                     //   "Premium Care Package \n   2 washes  Comprehensive exterior wash for a clean finish.- *1 hydrophobic* – Water-repellent coating to protect your car.- *1 wax* – Adds shine and shields the paint from damage.",
                     //   style: TextStyle(
                     //       fontFamily: 'Raleway',
                     //       fontSize: 14,
                     //       fontWeight: FontWeight.bold),
                     // ),
                            SizedBox(height: 8),
                          ]
                        : [
                            Text(
                              'Lorem ipsum dolor sit amet.',
                              style: TextStyle(
                                  fontFamily: 'Raleway',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Consectetur adipiscing elit.',
                              style: TextStyle(
                                  fontFamily: 'Raleway',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Sed do eiusmod tempor.',
                              style: TextStyle(
                                  fontFamily: 'Raleway',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Lorem ipsum dolor sit amet.',
                              style: TextStyle(
                                  fontFamily: 'Raleway',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isMonthly = true;
                        });
                      },
                      child: Container(
                        color:
                            isMonthly ? Colors.transparent : Color(0xffC6DFFE),
                        child: Container(
                          width: (MediaQuery.of(context).size.width * 0.5) - 16,
                          height: 52,
                          decoration: BoxDecoration(
                            color: isMonthly ? Color(0xffC6DFFE) : Colors.white,
                            borderRadius: isMonthly
                                ? BorderRadius.only(
                                    bottomRight: Radius.circular(16),
                                    bottomLeft: Radius.circular(16),
                                  )
                                : BorderRadius.only(
                                    topRight: Radius.circular(16),
                                  ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Monthly',
                            style: AppTextStyle.medium14,
                          ),
                          // Add onTap functionality
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isMonthly = false;
                        });
                      },
                      child: Container(
                        color:
                            !isMonthly ? Colors.transparent : Color(0xffC6DFFE),
                        child: Container(
                          width: (MediaQuery.of(context).size.width * 0.5) -
                              16, // Half the width of the upper container
                          height: 52, // Adjust height as needed
                          decoration: BoxDecoration(
                            color:
                                !isMonthly ? Color(0xffC6DFFE) : Colors.white,
                            borderRadius: !isMonthly
                                ? BorderRadius.only(
                                    bottomRight: Radius.circular(16),
                                    bottomLeft: Radius.circular(16),
                                  )
                                : BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                  ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Quarterly',
                            style: AppTextStyle.medium14,
                          ),
                          // Add onTap functionality
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            Container(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(56),
                  ),
                  padding: EdgeInsets.zero,
                ),
                onPressed: () {
                  Get.toNamed(AppRoutes.PAYMENT);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF51B6FF),
                        Color(0xFF2A5EE3),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(56),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'From ₹ 1,200/month',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            //Center(
            //  child: TextButton.icon(
            //    onPressed: () {},
            //    icon: Icon(Icons.refresh, color: Colors.grey),
            //    label: Text('Restore Purchase',
            //        style:
            //            TextStyle(color: Colors.grey, fontFamily: 'Poppins')),
            //  ),
            //),
            SizedBox(
              height: 32,
            )
          ],
        ),
      ),
    );
  }
}
