import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wrenchmate_user_app/app/modules/home/widgits/searchbar_filter.dart';
import 'package:wrenchmate_user_app/app/modules/service/widgits/elevatedbutton.dart';
import 'package:wrenchmate_user_app/app/modules/service/widgits/subservice.dart';
import 'package:wrenchmate_user_app/app/widgets/blueButton.dart';
import 'package:wrenchmate_user_app/app/widgets/bluebuttoncircular.dart';
import 'package:wrenchmate_user_app/app/widgets/custombackbutton.dart';
import 'package:wrenchmate_user_app/globalVariables.dart';
import 'package:wrenchmate_user_app/utils/color.dart';
import 'package:wrenchmate_user_app/utils/textstyles.dart';
import '../../controllers/car_controller.dart';
import '../../controllers/cart_controller.dart';
import '../../data/models/Service_firebase.dart';
import '../../routes/app_routes.dart';
import '../../controllers/service_controller.dart';
import '../../controllers/auth_controller.dart'; // Import AuthController

class ServicePage extends StatefulWidget {
  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  String selectedCategory = 'Show All';
  late String service;
  late CartController cartController;
  final ServiceController serviceController = Get.put(ServiceController());
  final AuthController authController = Get.put(AuthController());
  List<bool> addToCartStates = [];

  int userCurrentCarIndex = 0;
  List<Map<String, dynamic>> userCars = [];
  String carType = '';
  String carTypeImage = ''; // Add this line

  late TextEditingController regYearController;
  late TextEditingController regNoController;
  late TextEditingController insuranceExpController;
  late TextEditingController pucExpController;

  final CarController carController = Get.put(CarController());

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

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    fetchUserCurrentCarIndex();
    cartController = Get.put(CartController());
    service = Get.arguments;
    print(service);

    addToCartStates =
        List<bool>.filled(serviceController.services.length, false);

    authController.getUserCarDetails().then((userCarDetails) {
      String userCar = userCarDetails[userCurrentCarIndex];
      print(userCar);
      List<String> list = (userCar.split(",")).cast<String>().toList();

      serviceController
          .fetchServicesForUser(service, list)
          .then((_) {
        setState(() {
          addToCartStates =
              List<bool>.filled(serviceController.services.length, false);
        });
      });
    });
  }

  List<Servicefirebase> get filteredServices {
    if (selectedCategory == 'Show All') {
      return serviceController.services;
    } else {
      return serviceController.services.where((service) {
        String serviceName = service.name.toLowerCase().replaceAll(' ', '');
        String category = selectedCategory.toLowerCase().replaceAll(' ', '');

        return serviceName.contains(category) || category.contains(serviceName);
      }).toList();
    }
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   addToCartStates = List<bool>.filled(filteredServices.length, false);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldMessengerKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: service == "Repairs" || service == "Body Parts"
              ? Color(0xffE4F7FF)
              : Colors.transparent,
          title: Text(
            service,
            style: AppTextStyle.semiboldRaleway19,
          ),
          leading: Padding(
              padding: const EdgeInsets.all(6.0), child: Custombackbutton()),
        ),
        body: service != "Repairs" && service != "Body Parts"
            ? Column(
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  service != "Repairs"
                      ? Container(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.05),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.75,
                                color: Color(0xffF7F7F7),
                                child: Center(
                                  child: TextField(
                                    cursorColor: Colors.grey,
                                    decoration: InputDecoration(
                                      hintText: "Search services and Packages",
                                      hintStyle: AppTextStyle.mediumRaleway12
                                          .copyWith(color: greyColor),
                                      prefixIcon: Icon(
                                        Icons.search,
                                        color: Color(0xff838383),
                                      ),
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                    style: TextStyle(
                                      fontSize:
                                          20, // Increase the font size for the entered text
                                    ),
                                  ),
                                ),
                              ),
                              //filter
                              CustomIconButton(
                                onPressed: () {},
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  SizedBox(
                    height: 8,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          service == 'Accessories'
                              ? subservicesAccessories()
                              : Container(),
                          Obx(() {
                            if (serviceController.loading.value) {
                              return Center(
                                  child: CircularProgressIndicator(
                                color: Colors.blue,
                              ));
                            } else {
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: filteredServices.length,
                                itemBuilder: (context, index) {
                                  if (index >= addToCartStates.length) {
                                    return Container();
                                  }
                                  final service = filteredServices[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.toNamed(AppRoutes.SERVICE_DETAIL,
                                            arguments: service);
                                        ScaffoldMessenger.of(context)
                                            .hideCurrentSnackBar();
                                      },
                                      child: Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Color(0xffF7F7F7)),
                                        child: Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ExtendedImage.network(
                                                    service.image,
                                                    fit: BoxFit.fitWidth,
                                                    cache: true,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            32,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.17,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 12.0,
                                                        vertical: 8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              service.name,
                                                              style: AppTextStyle
                                                                  .semibold18,
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 8),
                                                        Row(
                                                          children: [
                                                            Text(
                                                                '\₹${service.price}  ',
                                                                style: AppTextStyle
                                                                    .semibold14),
                                                            Icon(
                                                                CupertinoIcons
                                                                    .star,
                                                                size: 16,
                                                                color: Color(
                                                                    0xffFFE262)),
                                                            Text(
                                                              ' ${service.averageReview.toStringAsFixed(1)}',
                                                              style: AppTextStyle
                                                                  .mediumdmsans13
                                                                  .copyWith(
                                                                      color:
                                                                          greyColor),
                                                            ),
                                                            Text(
                                                              ' (${service.numberOfReviews} reviews)',
                                                              style: AppTextStyle
                                                                  .mediumdmsans11
                                                                  .copyWith(
                                                                      color:
                                                                          greyColor),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 8),
                                                        //TIME AND WARRANTY
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            //TIME
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                    CupertinoIcons
                                                                        .clock,
                                                                    size: 16,
                                                                    color: Color(
                                                                        0xff797979)),
                                                                Text(
                                                                    ' Takes ${service.time} Hours',
                                                                    style: AppTextStyle
                                                                        .mediumRaleway12
                                                                        .copyWith(
                                                                            color:
                                                                                Color(0xff797979),
                                                                            fontWeight: FontWeight.w700)),
                                                              ],
                                                            ),
                                                            //WARRANTY
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                    CupertinoIcons
                                                                        .checkmark_shield,
                                                                    size: 18,
                                                                    color: Color(
                                                                        0xff797979)),
                                                                Text(
                                                                    ' ${service.warranty} Warranty',
                                                                    style: AppTextStyle
                                                                        .mediumRaleway12
                                                                        .copyWith(
                                                                            color:
                                                                                Color(0xff797979),
                                                                            fontWeight: FontWeight.w700)),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Positioned(
                                              top: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.18,
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.04,
                                              child: !addToCartStates[index]
                                                  ? CustomElevatedButton(
                                                      onPressed: () async {
                                                        String serviceId =
                                                            service.id;
                                                        bool isInCart =
                                                            await cartController
                                                                .isServiceInCart(
                                                                    serviceId);

                                                        if (isInCart) {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                  'Service already in cart'),
                                                              duration:
                                                                  Duration(
                                                                      seconds:
                                                                          2),
                                                            ),
                                                          );
                                                        } else {
                                                          cartController
                                                              .addToCartSnackbar(
                                                            context,
                                                            cartController,
                                                            service,
                                                            scaffoldMessengerKey,
                                                          );
                                                          // setState(() {
                                                            addToCartStates[
                                                                index] = true;
                                                          // });
                                                        }
                                                      },
                                                      text: '+Add',
                                                    )
                                                  : CustomElevatedButton(
                                                      onPressed: () {
                                                        Get.toNamed(
                                                            AppRoutes.CART);
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .hideCurrentSnackBar();
                                                      },
                                                      text: 'Go to cart',
                                                    ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Container(
                height: double.infinity,
                width: MediaQuery.of(context).size.width,
                color: Color(0xffE4F7FF),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Image.asset(
                    "assets/images/comingsoon.png",
                  ),
                ),
              ));
  }

  Widget subservicesRepairing() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SubService(
              imagePath: "assets/services/repair/showall.png",
              text: "Show All",
              isSelected: selectedCategory == 'Show All',
              onTap: () {
                setState(() {
                  selectedCategory = 'Show All';
                });
              },
            ),
            SubService(
              imagePath: "assets/services/repair/breakmain.png",
              text: "Breaks",
              isSelected: selectedCategory == 'Breaks',
              onTap: () {
                setState(() {
                  selectedCategory = 'Breaks';
                });
              },
            ),
            SubService(
              imagePath: "assets/services/repair/ac.png",
              text: "AC",
              isSelected: selectedCategory == 'AC',
              onTap: () {
                setState(() {
                  selectedCategory = 'AC';
                });
              },
            ),
            SubService(
              imagePath: "assets/services/repair/radiator.png",
              text: "Radiator",
              isSelected: selectedCategory == 'Radiator',
              onTap: () {
                setState(() {
                  selectedCategory = 'Radiator';
                });
              },
            ),
            SubService(
              imagePath: "assets/services/repair/alternator.png",
              text: "Alternator",
              isSelected: selectedCategory == 'Alternator',
              onTap: () {
                setState(() {
                  selectedCategory = 'Alternator';
                });
              },
            ),
            SubService(
              imagePath: "assets/services/repair/steering.png",
              text: "Steering",
              isSelected: selectedCategory == 'Steering',
              onTap: () {
                setState(() {
                  selectedCategory = 'Steering';
                });
              },
            ),
            SubService(
              imagePath: "assets/services/repair/suspension.png",
              text: "Suspension",
              isSelected: selectedCategory == 'Suspension',
              onTap: () {
                setState(() {
                  selectedCategory = 'Suspension';
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget subservicesAccessories() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SubService(
              imagePath: "assets/services/accessories/showall.png",
              text: "Show All",
              isSelected: selectedCategory == 'Show All',
              onTap: () {
                setState(() {
                  selectedCategory = 'Show All';
                });
              },
            ),
            SubService(
              imagePath: "assets/services/accessories/seatcover.png",
              text: "Seat Cover",
              isSelected: selectedCategory == 'seatcover',
              onTap: () {
                setState(() {
                  selectedCategory = 'seatcover';
                });
              },
            ),
            SubService(
              imagePath: "assets/services/accessories/floormats.png",
              text: "Floor mats",
              isSelected: selectedCategory == 'floormats',
              onTap: () {
                setState(() {
                  selectedCategory = 'floormats';
                });
              },
            ),
            SubService(
              imagePath: "assets/services/accessories/blinds.png",
              text: "Blinds",
              isSelected: selectedCategory == 'blinds',
              onTap: () {
                setState(() {
                  selectedCategory = 'blinds';
                });
              },
            ),
            SubService(
              imagePath: "assets/services/accessories/guards.png",
              text: "Guards",
              isSelected: selectedCategory == 'guard',
              onTap: () {
                setState(() {
                  selectedCategory = 'guard';
                });
              },
            ),
            SubService(
              imagePath: "assets/services/accessories/entertain.png",
              text: "Entertainment display",
              isSelected: selectedCategory == 'entertainmentdisplay',
              onTap: () {
                setState(() {
                  selectedCategory = 'entertainmentdisplay';
                });
              },
            ),
            SubService(
              imagePath: "assets/services/accessories/led.png",
              text: "LED Lights",
              isSelected: selectedCategory == 'ledlights',
              onTap: () {
                setState(() {
                  selectedCategory = 'ledlights';
                });
              },
            ),
            SubService(
              imagePath: "assets/services/accessories/solartoys.png",
              text: "Solar Toys",
              isSelected: selectedCategory == 'solartoys',
              onTap: () {
                setState(() {
                  selectedCategory = 'solartoys';
                });
              },
            ),
            SubService(
              imagePath: "assets/services/accessories/airfresh.png",
              text: "Perfume",
              isSelected: selectedCategory == 'Perfume',
              onTap: () {
                setState(() {
                  selectedCategory = 'Perfume';
                });
              },
            ),
            SubService(
              imagePath: "assets/services/accessories/cushion.png",
              text: "Cushion",
              isSelected: selectedCategory == 'cushion',
              onTap: () {
                setState(() {
                  selectedCategory = 'cushion';
                });
              },
            ),
            SubService(
              imagePath: "assets/services/accessories/chrome.png",
              text: "Chrome Fitting",
              isSelected: selectedCategory == 'chromefitting',
              onTap: () {
                setState(() {
                  selectedCategory = 'chromefitting';
                });
              },
            ),
            SubService(
              imagePath: "assets/services/accessories/cables.png",
              text: "Cables",
              isSelected: selectedCategory == 'cable',
              onTap: () {
                setState(() {
                  selectedCategory = 'cable';
                });
              },
            ),
            SubService(
              imagePath: "assets/services/accessories/doordamp.png",
              text: "Door Damping",
              isSelected: selectedCategory == 'doordamping',
              onTap: () {
                setState(() {
                  selectedCategory = 'doordamping';
                });
              },
            ),
            SubService(
              imagePath: "assets/services/accessories/wiper.png",
              text: "Wipers",
              isSelected: selectedCategory == 'wipers',
              onTap: () {
                setState(() {
                  selectedCategory = 'wipers';
                });
              },
            ),
            SubService(
              imagePath: "assets/services/accessories/rain.png",
              text: "Rain Visors",
              isSelected: selectedCategory == 'rainvisors',
              onTap: () {
                setState(() {
                  selectedCategory = 'rainvisors';
                });
              },
            ),
            SubService(
              imagePath: "assets/services/accessories/sun.png",
              text: "Sun Protection Film",
              isSelected: selectedCategory == 'sunprotectionfilm',
              onTap: () {
                setState(() {
                  selectedCategory = 'sunprotectionfilm';
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
