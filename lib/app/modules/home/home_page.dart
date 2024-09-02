import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wrenchmate_user_app/app/controllers/cart_controller.dart';
import 'package:wrenchmate_user_app/app/modules/home/widgits/offers_slider.dart';
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
    print(
        "cartController.totalAmount.value :: ${cartController.totalAmount.value}");
    if (cartController.totalAmount.value > 0.0) {
      print(
          "cartController.totalAmount.value :: ${cartController.totalAmount.value}");

      _onTap();
    }
  }

  // RxDouble totalAmount = 0.0.obs;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Future<void> fetchTotalCost() async {
  //   try {
  //     String userId = FirebaseAuth.instance.currentUser!.uid;
  //     DocumentSnapshot userDoc =
  //         await _firestore.collection('User').doc(userId).get();

  //     if (userDoc.exists) {
  //       totalAmount.value = userDoc['total_cost_cart'] ?? 0.0;
  //       print("totalAmount.value :: ${totalAmount.value}");
  //     }
  //   } catch (e) {
  //     print("Error fetching total cost: $e");
  //   }
  // }

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

  void _onTap() {
    setState(() {
      final snackBar = SnackBar(
        backgroundColor: primaryColor,
        content: Obx(() => Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Total Amount: \₹${cartController.totalAmount.value.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.CART);
                      setState(() {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      });
                    },
                    child: Text(
                      'Checkout',
                      style: TextStyle(
                        fontSize: 16,
                        color: primaryColor,
                        fontFamily: 'Raleway',
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            )),
        duration: Duration(days: 1), // Snackbar duration
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      cartController.totalAmount.listen((newTotal) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
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
                ignoring: isDrawerOpen,
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
                                    // Keep this Expanded
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'hello ${userData?['User_name'] ?? 'User'}',
                                          style: AppTextStyle.boldRaleway15,
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on_outlined,
                                              size: 16,
                                              color: Color(0xffFF5402),
                                            ),
                                            Expanded(
                                              // Keep this Expanded
                                              child: Text(
                                                userData?['User_address'] !=
                                                        null
                                                    ? userData!['User_address']
                                                        .split(',')
                                                        .take(3)
                                                        .join(', ')
                                                    : 'Location not available',
                                                style: AppTextStyle.medium10,
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
                      searchbar(
                        readonly: true,
                      ),
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
