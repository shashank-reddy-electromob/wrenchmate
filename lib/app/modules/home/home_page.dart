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
import '../../controllers/home_controller.dart';
import 'drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final user;
  HomeController? controller;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    controller = Get.put(HomeController());
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    userData = await controller?.fetchUserData() as Map<String, dynamic>?;
    setState(() {});
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

  double xOffSet = 0;
  double yOffSet = 0;
  double scaleFactor = 1;
  bool isDrawerOpen = false;

  void _onTap() {
    setState(() {
      xOffSet = 0;
      yOffSet = 0;
      scaleFactor = 1;
      isDrawerOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          drawerPage(
            userProfileImage: userData?['User_profile_image'] ?? '',
            userName: userData?['User_name'] ?? 'Unknown User',
            userNumber: userData?['User_number'] != null &&
                userData!['User_number'].isNotEmpty
                ? userData!['User_number'][0]
                : 'No number available',
            userEmail: userData?['User_email'] ?? 'No email available',
          ),
          GestureDetector(
            onTap: () {
              if (isDrawerOpen) {
                _onTap();
              }
            },
            child: AnimatedContainer(
              decoration: isDrawerOpen
                  ? BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 20,
                    blurRadius: 35,
                  ),
                ],
              )
                  : BoxDecoration(color: Colors.white),
              duration: Duration(microseconds: 100),
              transform: Matrix4.translationValues(xOffSet, yOffSet, 0)
                ..scale(scaleFactor),
              child: IgnorePointer(
                ignoring: isDrawerOpen, // Disable interaction only when drawer is open
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Container(
                        height: 40,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded( // Wrap the entire Row with Expanded
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        xOffSet = 230;
                                        yOffSet =
                                            MediaQuery.of(context).size.height *
                                                0.15;
                                        scaleFactor = 0.7;
                                        isDrawerOpen = true;
                                      });
                                    },
                                    child: ClipOval(
                                      child: userData?['User_profile_image'] != null &&
                                          userData!['User_profile_image'].isNotEmpty
                                          ? Image.network(
                                        userData!['User_profile_image'],
                                        fit: BoxFit.cover,
                                        height: 45.0,
                                        width: 45.0,
                                      )
                                          : Image.asset(
                                        'assets/images/person.png',
                                        fit: BoxFit.cover,
                                        height: 45.0,
                                        width: 45.0,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded( // Keep this Expanded
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'hello ${userData?['User_name'] ?? 'User'}',
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
                                            Expanded( // Keep this Expanded
                                              child: Text(
                                                userData?['User_address'] != null
                                                    ? userData!['User_address']
                                                    .split(',')
                                                    .take(3)
                                                    .join(', ')
                                                    : 'Location not available',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
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
                      offersSliders(),
                      serviceswidgit(),
                      toprecommendedservices(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}