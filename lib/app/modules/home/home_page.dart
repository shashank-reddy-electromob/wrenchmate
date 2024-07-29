import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wrenchmate_user_app/app/modules/home/widgits/offers_slider.dart';
import 'package:wrenchmate_user_app/app/modules/home/widgits/searchbar_filter.dart';
import 'package:wrenchmate_user_app/app/modules/home/widgits/services.dart';
import 'package:wrenchmate_user_app/app/modules/home/widgits/toprecommendedservices.dart';
import 'package:wrenchmate_user_app/app/routes/app_routes.dart';
import 'package:google_api_availability/google_api_availability.dart';
import 'drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final user;
  late final profileImageUrl;

  @override
  void initState() {
    super.initState();
    print("initstate");
    user = FirebaseAuth.instance.currentUser!;
    print("userid: "+user.uid);
    fetchUserProfileImage();
    checkGooglePlayServices();
  }

  void checkGooglePlayServices() async {
    GoogleApiAvailability apiAvailability = GoogleApiAvailability.instance;
    final status = await apiAvailability.checkGooglePlayServicesAvailability();
    if (status == GooglePlayServicesAvailability.success) {
      print("Google Play Services are available.");
    } else {
      print("Google Play Services are not available: $status");
    }
  }

  void fetchUserProfileImage() async {
    try {
      print("Fetching User Profile Image...");

      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('User')
          .doc("8QgqTctzQnS2jjmHJ0baH4MQ0hv2")
          .get();

      if (userSnapshot.exists) {
        // Accessing only the User_profile_image field
        profileImageUrl = userSnapshot.get('User_profile_image');
        print("User Profile Image URL: $profileImageUrl");
      } else {
        print("No such document found.");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }




  double xOffSet = 0;
  double yOffSet = 0;
  double scaleFactor = 1;
  bool isDrawerOpen = false;


  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (details.primaryDelta! > 0) {
      // Swiping in right direction
      setState(() {
        xOffSet = 230;
        yOffSet = MediaQuery.of(context).size.height * 0.15;
        scaleFactor = 0.7;
        isDrawerOpen = true;
      });
    } else if (details.primaryDelta! < 0) {
      // Swiping in left direction
      setState(() {
        xOffSet = 0;
        yOffSet = 0;
        scaleFactor = 1;
        isDrawerOpen = false;
      });
    }
  }

  void _onTap() {
    setState(() {
      xOffSet = 0;
      yOffSet = 0;
      scaleFactor = 1;
      isDrawerOpen = false;
    });
  }
@override


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          drawerPage(),
          GestureDetector(
            onHorizontalDragUpdate: _onHorizontalDragUpdate,
            onTap: isDrawerOpen ? _onTap : null,
            child: AnimatedContainer(
              decoration: isDrawerOpen?BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 20,
                    blurRadius: 35,
                  ),
                ],
              ):BoxDecoration(
                color: Colors.white
              ),
              duration: Duration(microseconds: 100),
              transform: Matrix4.translationValues(xOffSet, yOffSet, 0)
                ..scale(scaleFactor),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Container(
                      height: 40,
                    ),
                    //appbar
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //icon and name
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                    setState(() {
                                    xOffSet = 230;
                                    yOffSet =
                                        MediaQuery.of(context).size.height *
                                            0.15;
                                    scaleFactor = 0.8;
                                  });
                                },
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/images/weekend.png',
                                    fit: BoxFit.cover,
                                    height: 45.0,
                                    width: 45.0,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                height: 45,
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      //"Hi ${user.uid}",
                                      'helo',
                                      style: TextStyle(
                                          fontSize: 22, color: Colors.black),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on_outlined,
                                          size: 16,
                                          color: Color(0xffFF5402),
                                        ),
                                        Text("234, FTS Colony, HYD",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          //notification
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Color(
                                    0xffE7E7E7), // Set the border color to grey
                                width: 1.0, // Set the border width
                              ),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.notifications_none_outlined,
                                color: Color(0xff515151),
                              ),
                              onPressed: () {
                                Get.toNamed(AppRoutes.NOTIFICATIONS);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    searchbar(),
                    SizedBox(
                      height: 12,
                    ),
                    offersSliders(),
                    serviceswidgit(),
                    toprecommendedservices(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}