import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wrenchmate_user_app/app/controllers/cart_controller.dart';
import 'package:wrenchmate_user_app/app/modules/home/widgits/offers_slider.dart';
import 'package:wrenchmate_user_app/app/modules/home/widgits/persistentnotification.dart';
import 'package:wrenchmate_user_app/app/modules/home/widgits/searchbar_filter.dart';
import 'package:wrenchmate_user_app/app/modules/home/widgits/services.dart';
import 'package:wrenchmate_user_app/app/modules/home/widgits/toprecommendedservices.dart';
import 'package:wrenchmate_user_app/app/routes/app_routes.dart';
import 'package:google_api_availability/google_api_availability.dart';
import 'package:wrenchmate_user_app/utils/color.dart';
import 'package:wrenchmate_user_app/utils/textstyles.dart';
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
    cartController = Get.put(CartController());
    user = FirebaseAuth.instance.currentUser!;
    controller = Get.put(HomeController());
    fetchUserData();
    initalCall();
  }

  Future<void> initalCall() async {
    await cartController.fetchTotalCost();
    print("cartController.totalAmount.value :: ${cartController.totalAmount.value}");
    if (cartController.totalAmount.value > 0.0) {
      print("cartController.totalAmount.value :: ${cartController.totalAmount.value}");
    }
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
  late CartController cartController;

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
                setState(() {
                  xOffSet = 0;
                  yOffSet = 0;
                  scaleFactor = 1;
                  isDrawerOpen = false;
                });
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
                ignoring: isDrawerOpen,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Container(height: 40),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        ScaffoldMessenger.of(context)
                                            .hideCurrentSnackBar();

                                        xOffSet = 230;
                                        yOffSet =
                                            MediaQuery.of(context).size.height *
                                                0.15;
                                        scaleFactor = 0.7;
                                        isDrawerOpen = true;
                                      });
                                    },
                                    child: ClipOval(
                                      child: userData?['User_profile_image'] !=
                                                  null &&
                                              userData!['User_profile_image']
                                                  .isNotEmpty
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
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'hello ${userData?['User_name'] ?? 'User'}',
                                          style: AppTextStyle.boldRaleway15,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            print("address");
                                            Get.toNamed(AppRoutes.MAPSCREEN,
                                                arguments:
                                                    userData?['User_address']);
                                          },
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.location_on_outlined,
                                                size: 16,
                                                color: Color(0xffFF5402),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  userData?['User_address'] !=
                                                          null
                                                      ? userData![
                                                              'User_address']
                                                          .split(',')
                                                          .take(3)
                                                          .join(', ')
                                                      : 'Location not available',
                                                  style: AppTextStyle.medium10,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: Color(0xffE7E7E7),
                                  width: 1.0,
                                ),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.notifications_none_outlined,
                                  color: Color(0xff515151),
                                ),
                                onPressed: () {
                                  Get.toNamed(AppRoutes.NOTIFICATIONS);
                                  // ScaffoldMessenger.of(context)
                                  //     .hideCurrentSnackBar();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12),
                      searchbar(readonly: true),
                      OffersSliders(),
                      serviceswidgit(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: toprecommendedservices(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: PersistentNotification(
              totalAmount: cartController.totalAmount,
              discountAmount: cartController.discountAmount,
            ),
          ),
        ],
      ),
    );
  }
}
