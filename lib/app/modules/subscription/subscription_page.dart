import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wrenchmate_user_app/utils/textstyles.dart';
import '../../routes/app_routes.dart';

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
                        'Lorem  dolor sit amet.',
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
                        color: isMonthly? Colors.transparent:Color(0xffC6DFFE),
                        child: Container(
                          width: (MediaQuery.of(context).size.width * 0.5)-16,
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
                        color: !isMonthly? Colors.transparent:Color(0xffC6DFFE),
                        child: Container(
                          width: (MediaQuery.of(context).size.width * 0.5)-16, // Half the width of the upper container
                          height: 52, // Adjust height as needed
                          decoration: BoxDecoration(
                            color: !isMonthly ? Color(0xffC6DFFE) : Colors.white,
                            borderRadius: !isMonthly
                                ? BorderRadius.only(
                              bottomRight: Radius.circular(16),
                              bottomLeft: Radius.circular(16),
                            )
                                : BorderRadius.only(
                              topLeft: Radius.circular(16),
                            ),                        ),
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
            Center(
              child: TextButton.icon(
                onPressed: () {},
                icon: Icon(Icons.refresh, color: Colors.grey),
                label: Text('Restore Purchase',
                    style:
                        TextStyle(color: Colors.grey, fontFamily: 'Poppins')),
              ),
            ),
            SizedBox(height: 32,)
          ],
        ),
      ),
    );
  }
}
