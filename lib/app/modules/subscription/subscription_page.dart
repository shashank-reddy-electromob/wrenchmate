import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wrenchmate_user_app/utils/textstyles.dart';
import '../../controllers/subscription_controller.dart';
import '../../routes/app_routes.dart';

// class SubscriptionPage extends StatefulWidget {
//   @override
//   _SubscriptionPageState createState() => _SubscriptionPageState();
// }

// class _SubscriptionPageState extends State<SubscriptionPage> {
//   bool isMonthly = true;

class SubscriptionPage extends StatefulWidget {
  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  bool isMonthly = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back, color: Colors.black),
      //     onPressed: () {
      //     },
      //   ),
      //   actions: [
      //     IconButton(
      //       icon: Icon(Icons.more_vert, color: Colors.black),
      //       onPressed: () {
      //       },
      //     ),
      //   ],
      // ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 36,
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
                  // Image.asset(
                  //   'assets/car/car_img.png',
                  //   width: 100,
                  //   height: 100,
                  // ),
                  // SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Lorem ipsum dolor sit amet consectetur. Vitae interdum libero risus urna. Tortor dolor bibendum a mauris gravida purus molestie vitae. Mollis nullam cum imperdiet tellus at duis tristique.',
                      style: TextStyle(fontSize: 14, fontFamily: 'Raleway'),
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
                    gradient: LinearGradient(
                      colors: isMonthly
                          ? [
                              Colors.lightBlue.shade200,
                              Colors.lightBlue.shade300,
                            ]
                          : [
                              Colors.lightBlue.shade400,
                              Colors.lightBlue.shade500,
                            ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: isMonthly
                        ? [
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
                          ],
                  ),
                ),
                SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ChoiceChip(
                      showCheckmark: false,
                      label: Text(
                        'Monthly',
                        style: AppTextStyle.medium14,
                      ),
                      selected: isMonthly,
                      selectedColor: Colors.lightBlue.shade300,
                      onSelected: (selected) {
                        setState(() {
                          isMonthly = true;
                        });
                      },
                    ),
                    ChoiceChip(
                      showCheckmark: false,
                      label: Text(
                        'Quarterly',
                        style: AppTextStyle.medium14,
                      ),
                      selected: !isMonthly,
                      selectedColor: Colors.lightBlue.shade300,
                      onSelected: (selected) {
                        setState(() {
                          isMonthly = false;
                        });
                      },
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
            SizedBox(height: 16),
            Center(
              child: TextButton.icon(
                onPressed: () {},
                icon: Icon(Icons.refresh, color: Colors.grey),
                label: Text('Restore Purchase',
                    style:
                        TextStyle(color: Colors.grey, fontFamily: 'Poppins')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
