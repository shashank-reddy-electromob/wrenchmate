import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wrenchmate_user_app/app/modules/home/widgits/searchbar_filter.dart';
import 'package:wrenchmate_user_app/app/modules/service/widgits/elevatedbutton.dart';
import 'package:wrenchmate_user_app/app/modules/service/widgits/seperator.dart';
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
  late String currService;
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
  bool isCarLoading = true;

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
    try {
      userCars = await carController.fetchUserCarDetails();

      if (userCars.isNotEmpty) {
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
      }

      setState(() {
        isCarLoading = false;
      });
    } catch (e) {
      print("Error fetching car details: $e");
      setState(() {
        isCarLoading = false;
      });
    }
  }

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    fetchUserCurrentCarIndex();
    cartController = Get.put(CartController());
    currService = Get.arguments;
    print('service category is: ${currService}');

    addToCartStates =
        List<bool>.filled(serviceController.services.length, false);

    authController.getUserCarDetails().then((userCarDetails) {
      String userCar = userCarDetails[userCurrentCarIndex];
      print(userCar);
      List<String> list = (userCar.split(",")).cast<String>().toList();

      serviceController.fetchServicesForUser(currService, list).then((_) {
        setState(() {
          addToCartStates =
              List<bool>.filled(serviceController.services.length, false);
          // isCarLoading = false;
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
          backgroundColor: currService == "Body Parts"
              ? Colors.transparent
              : Colors.transparent,
          title: Text(
            currService,
            style: AppTextStyle.semiboldRaleway19,
          ),
          leading: Padding(
              padding: const EdgeInsets.all(6.0), child: Custombackbutton()),
        ),
        floatingActionButton: Obx(
          () => Visibility(
            visible: !cartController.cartItems.isEmpty,
            child: FloatingActionButton(
              onPressed: () {
                Get.toNamed(AppRoutes.CART);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              backgroundColor: primaryColor,
              child: Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
              shape: CircleBorder(),
            ),
          ),
        ),
        body: isCarLoading
            ? Center(
                child: CircularProgressIndicator(), // Show loader while loading
              )
            : userCars.isEmpty
                // serviceController.filteredServices.isEmpty

                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                            'Please enter your car details to avail any service'),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.CAR_REGISTER);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 8),
                              child: Text(
                                'Add Car',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                :
                // currService != "Body Parts"?
                Column(
                    children: [
                      SizedBox(
                        height: 8,
                      ),
                      // service != "Repairs"?
                      Container(
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
                                  onChanged: (val) {
                                    serviceController.filterServices(val);
                                  },
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
                      // : Container(),
                      ,
                      SizedBox(
                        height: 8,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              currService == 'Accessories'
                                  ? subservicesAccessories()
                                  : Container(),
                              Obx(() {
                                if (serviceController.loading.value) {
                                  return Center(
                                      child: CircularProgressIndicator(
                                    color: Colors.blue,
                                  ));
                                } else {
                                  return serviceController
                                          .filteredServices.isEmpty
                                      ? Center(
                                          child: Column(
                                          children: [
                                            Text(
                                                "Contact us if the service is not listed"),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            GestureDetector(
                                                onTap: () {
                                                  Get.toNamed(
                                                      AppRoutes.CHATSCREEN);
                                                },
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.blue),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 15,
                                                          vertical: 10),
                                                      child: Text(
                                                        "Contact us",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    )))
                                          ],
                                        ))
                                      : ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: serviceController
                                              .filteredServices.length,
                                          itemBuilder: (context, index) {
                                            if (index >=
                                                addToCartStates.length) {
                                              return Container();
                                            }
                                            final service = serviceController
                                                .filteredServices[index];
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  Get.toNamed(
                                                      AppRoutes.SERVICE_DETAIL,
                                                      arguments: {
                                                        'service': service,
                                                        'currService':
                                                            currService
                                                      });
                                                  ScaffoldMessenger.of(context)
                                                      .hideCurrentSnackBar();
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 10),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      color: Color(0xffF7F7F7)),
                                                  child: Stack(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            ExtendedImage
                                                                .network(
                                                              service.image,
                                                              fit: currService ==
                                                                      'Repairs'
                                                                  ? BoxFit
                                                                      .contain
                                                                  : BoxFit
                                                                      .fitWidth,
                                                              cache: true,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width -
                                                                  32,
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.17,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          12.0,
                                                                      vertical:
                                                                          8.0),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        service
                                                                            .name,
                                                                        style: AppTextStyle
                                                                            .semibold18,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          8),
                                                                  Row(
                                                                    children: [
                                                                      currService != "Repairs" &&
                                                                              currService !=
                                                                                  "General Service" &&
                                                                              currService !=
                                                                                  'Denting and Painting' &&
                                                                              currService !=
                                                                                  'Body Parts'
                                                                          ? Text(
                                                                              '\₹${service.price}  ',
                                                                              style: AppTextStyle.semibold14)
                                                                          : SizedBox(),
                                                                      SizedBox(
                                                                        width:
                                                                            3,
                                                                      ),
                                                                      Icon(
                                                                          CupertinoIcons
                                                                              .star,
                                                                          size:
                                                                              16,
                                                                          color:
                                                                              Color(0xffFFE262)),
                                                                      Text(
                                                                        ' ${service.averageReview.toStringAsFixed(1)}',
                                                                        style: AppTextStyle
                                                                            .mediumdmsans13
                                                                            .copyWith(color: greyColor),
                                                                      ),
                                                                      Text(
                                                                        ' (${service.numberOfReviews} reviews)',
                                                                        style: AppTextStyle
                                                                            .mediumdmsans11
                                                                            .copyWith(color: greyColor),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          8),
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
                                                                              CupertinoIcons.clock,
                                                                              size: 16,
                                                                              color: Color(0xff797979)),
                                                                          Text(
                                                                              ' Takes ${service.time} Hours',
                                                                              style: AppTextStyle.mediumRaleway12.copyWith(color: Color(0xff797979), fontWeight: FontWeight.w700)),
                                                                        ],
                                                                      ),
                                                                      //WARRANTY
                                                                      Row(
                                                                        children: [
                                                                          Icon(
                                                                              CupertinoIcons.checkmark_shield,
                                                                              size: 18,
                                                                              color: Color(0xff797979)),
                                                                          Text(
                                                                              ' ${service.warranty} Warranty',
                                                                              style: AppTextStyle.mediumRaleway12.copyWith(color: Color(0xff797979), fontWeight: FontWeight.w700)),
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
                                                        top: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.18,
                                                        right: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.03,
                                                        child: currService ==
                                                                    'Repairs' ||
                                                                currService ==
                                                                    'General Service' ||
                                                                currService ==
                                                                    'Denting and Painting' ||
                                                                currService ==
                                                                    'Body Parts'
                                                            ? GestureDetector(
                                                                onTap: () {
                                                                  Get.toNamed(
                                                                    AppRoutes
                                                                        .CHATSCREEN,
                                                                    arguments:
                                                                        "I need more clarity on ${service.name}",
                                                                  );
                                                                },
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Color(
                                                                        0xff3778F2),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            12,
                                                                        vertical:
                                                                            8),
                                                                    child: Text(
                                                                        'Get Quotation',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white)),
                                                                  ),
                                                                ),
                                                              )
                                                            : !addToCartStates[
                                                                    index]
                                                                ? CustomElevatedButton(
                                                                    onPressed:
                                                                        () async {
                                                                      String
                                                                          serviceId =
                                                                          service
                                                                              .id;
                                                                      bool
                                                                          isInCart =
                                                                          await cartController
                                                                              .isServiceInCart(serviceId);

                                                                      if (isInCart) {
                                                                        ScaffoldMessenger.of(context)
                                                                            .showSnackBar(
                                                                          SnackBar(
                                                                            content:
                                                                                Text('Service already in cart'),
                                                                            duration:
                                                                                Duration(seconds: 2),
                                                                          ),
                                                                        );
                                                                      } else {
                                                                        if (service.category ==
                                                                                'Denting and Painting' ||
                                                                            service.category ==
                                                                                'Detailing') {
                                                                          showCustomBottomSheet(
                                                                              service.price,
                                                                              service,
                                                                              index);
                                                                        } else {
                                                                          cartController
                                                                              .addToCartSnackbar(
                                                                            context,
                                                                            cartController,
                                                                            service,
                                                                            scaffoldMessengerKey,
                                                                          );
                                                                          setState(
                                                                              () {
                                                                            addToCartStates[index] =
                                                                                true;
                                                                          });
                                                                          // setState(() => addtocart = true);
                                                                        }
                                                                        // cartController
                                                                        //     .addToCartSnackbar(
                                                                        //   context,
                                                                        //   cartController,
                                                                        //   service,
                                                                        //   scaffoldMessengerKey,
                                                                        // );
                                                                      }
                                                                    },
                                                                    text:
                                                                        '+Add',
                                                                  )
                                                                : CustomElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .hideCurrentSnackBar();
                                                                      cartController
                                                                          .deleteServicesFromCart(
                                                                              service.id);
                                                                      setState(
                                                                          () {
                                                                        addToCartStates[index] =
                                                                            false;
                                                                      });
                                                                    },
                                                                    text:
                                                                        'Remove',
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
        // : Container(
        //     height: double.infinity,
        //     width: MediaQuery.of(context).size.width,
        //     color: Color(0xffE4F7FF),
        //     child: Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 32),
        //       child: Image.asset(
        //         "assets/images/comingsoon.png",
        //       ),
        //     ),
        //   ),
        );
  }

  void showCustomBottomSheet(double price, Servicefirebase service, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 4,
                  width: 60,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10)),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Choose Service Type',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Showroom Quality',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500)),
                        Text('₹ ${price}',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    CustomElevatedButton(
                      onPressed: () {
                        cartController.addToCartSnackbar(
                          context,
                          cartController,
                          service,
                          scaffoldMessengerKey,
                        );
                        Navigator.pop(context);
                        setState(() {
                          addToCartStates[index] = true;
                        });
                      },
                      text: '+Add',
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: MySeparator(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Normal Quality',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500)),
                        Text('₹ ${price}',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    CustomElevatedButton(
                      onPressed: () {
                        cartController.addToCartSnackbar(
                          context,
                          cartController,
                          service,
                          scaffoldMessengerKey,
                        );
                        Navigator.pop(context);
                        setState(() {
                          addToCartStates[index] = true;
                        });
                      },
                      text: '+Add',
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        );
      },
    );
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
