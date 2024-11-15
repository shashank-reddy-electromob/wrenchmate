import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wrenchmate_user_app/app/controllers/booking_controller.dart';
import 'package:wrenchmate_user_app/app/controllers/cart_controller.dart';
import 'package:wrenchmate_user_app/app/modules/subscription/widget/planCard.dart';
import 'package:wrenchmate_user_app/utils/textstyles.dart';
import '../../controllers/car_controller.dart';
import '../../routes/app_routes.dart';
import '../home/widgits/offers_slider_sub.dart';

class SubscriptionPage extends StatefulWidget {
  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  bool isMonthly = true;
  bool premium = true;

  int userCurrentCarIndex = 0;
  List<Map<String, dynamic>> userCars = [];
  String carType = '';
  String carTypeImage = ''; // Add this line

  late TextEditingController regYearController;
  late TextEditingController regNoController;
  late TextEditingController insuranceExpController;
  late TextEditingController pucExpController;

  var monthly_basic = 0;
  var quaterely_basic = 0;
  var monthly_premium = 0;
  var quaterley_premium = 0;

  int price = 0;

  final CarController carController = Get.put(CarController());
  final CartController cartController = Get.put(CartController());
  final BookingController bookingController = Get.put(BookingController());

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  FirebaseFirestore db = FirebaseFirestore.instance;
  PageController _pageController = PageController();
  int currentIndex = 0;

  final monthlyPlans = [
    {
      'title': 'Essential Need Pack',
      'type': 'basic',
      'details': [
        {
          'title': '-> 4 washes',
          'description': '- Basic exterior cleaning to remove dust and dirt.',
        },
      ],
    },
    {
      'title': 'Premium Need Pack',
      'type': 'premium',
      'details': [
        {
          'title': '-> 2 washes',
          'description': '- Comprehensive exterior wash for a clean finish.',
        },
        {
          'title': '-> 1 hydrophobic',
          'description': '- Water-repellent coating to protect your car.',
        },
        {
          'title': '-> 1 wax',
          'description': '- Adds shine and shields the paint from damage.',
        },
      ],
    },
  ];

  final quarterlyPlans = [
    {
      'title': 'Ultimate Wash Package',
      'type': 'basic',
      'details': [
        {
          'title': '-> 12 washes',
          'description':
              '- Regular washes to maintain your car\'s cleanliness.',
        },
      ],
    },
    {
      'title': 'Deluxe Maintenance Pack',
      'type': 'premium',
      'details': [
        {
          'title': '-> 6 washes',
          'description': '- Regular cleaning to keep your car looking fresh.',
        },
        {
          'title': '-> 1 scrubbing',
          'description':
              '- Detailed scrubbing for deep cleaning and spot removal.',
        },
        {
          'title': '-> 1 Wheel alignment',
          'description': '- Ensure proper alignment for a smooth ride.',
        },
      ],
    },
  ];

  void _handlePageChange(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentIndex);

    bookingController.fetchBookingsWithSubscriptionDetails();
    fetchUserCurrentCarIndex();
    firebasePriceFetch();
  }

  void togglePremium(bool status) {
    setState(() {
      premium = status;
    });
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

  int _currentIndex = 0;

  // Toggle between monthly and quarterly plans

  // Get the current list of plans based on the toggle
  List<Map<String, dynamic>> get currentPlans =>
      isMonthly ? monthlyPlans : quarterlyPlans;

  // void _nextPlan() {
  //   setState(() {
  //     _currentIndex = (_currentIndex + 1) % currentPlans.length;
  //     log('premium is : ${premium.toString()}');
  //     log('monthly is : ${isMonthly.toString()}');
  //   });
  // }

  // void _previousPlan() {
  //   setState(() {
  //     // Move to the previous plan, or loop to the end
  //     _currentIndex =
  //         (_currentIndex - 1 + currentPlans.length) % currentPlans.length;
  //   });
  // }

  void _nextPlan() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % currentPlans.length;
      pricesetMethod();
    });
  }

  void _previousPlan() {
    setState(() {
      _currentIndex =
          (_currentIndex - 1 + currentPlans.length) % currentPlans.length;
      pricesetMethod();
    });
  }

  void firebasePriceFetch() {
    final docRef = db.collection("Subscriptions").doc("sub-2024");
    docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        monthly_basic = data["monthly basic"];
        monthly_premium = data["monthly premium"];
        quaterely_basic = data["quarterly basic"];
        quaterley_premium = data["quarterly premium"];
        pricesetMethod();
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  // void pricesetMethod() {
  //   setState(() {
  //     if (isMonthly) {
  //       if (!premium) {
  //         price = monthly_premium;
  //       } else {
  //         price = monthly_basic;
  //       }
  //     } else {
  //       if (!premium) {
  //         price = quaterley_premium;
  //       } else {
  //         price = quaterely_basic;
  //       }
  //     }
  //   });
  // }

  void pricesetMethod() {
    setState(() {
      final currentPlan = currentPlans[_currentIndex];
      final isBasic = currentPlan['type'] == 'basic';

      if (isMonthly) {
        price = isBasic ? monthly_basic : monthly_premium;
      } else {
        price = isBasic ? quaterely_basic : quaterley_premium;
      }
    });
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color
                    borderRadius:
                        BorderRadius.circular(12.0), // Rounded corners
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
                        builder: (c, s) => s.connectionState ==
                                ConnectionState.done
                            ? Container(
                                width: MediaQuery.of(context).size.height / 8,
                                child:
                                    Image.asset("assets/car/$carTypeImage.png"),
                              )
                            : Container(
                                child: CircularProgressIndicator(),
                              ),
                      ),
                      SizedBox(width: 16),
                      Obx(() {
                        return bookingController.subsBookingList.isEmpty
                            ? Expanded(
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Text(
                                    "Keep your car in top shape all year round with our hassle-free service subscription—convenience, savings, and expert care, all in one package!",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Raleway',
                                        fontWeight: FontWeight.w600),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 5,
                                  ),
                                ),
                              )
                            : Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Get.toNamed(AppRoutes.BOOKING_DETAILS_SUBS);
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Current Subscription',
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: 'Raleway',
                                            fontWeight: FontWeight.w500),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 5,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        bookingController.subsBookingList[0]
                                            ['subscriptionDetails']['packDesc'],
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'Raleway',
                                            fontWeight: FontWeight.w800),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 5,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'Expiring on: ${bookingController.formatTimestamp(bookingController.subsBookingList[0]['subscriptionDetails']['endDate'])}',
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontFamily: 'Raleway',
                                            fontWeight: FontWeight.w300),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                      })
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 10, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Upgrade to',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff01417E),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
                  child: Column(
                    children: [
                      GestureDetector(
                        onHorizontalDragEnd: (details) {
                          if (details.primaryVelocity! < 0) {
                            _nextPlan();
                          } else if (details.primaryVelocity! > 0) {
                            _previousPlan();
                          }
                        },
                        child: Center(
                          child: PlanCard(currentPlans[_currentIndex],
                              isMonthly, currentPlans.length, _currentIndex),
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
                              pricesetMethod();
                            },
                            child: Container(
                              color: isMonthly
                                  ? Colors.transparent
                                  : Color(0xffC6DFFE),
                              child: Container(
                                width:
                                    (MediaQuery.of(context).size.width * 0.5) -
                                        16,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: isMonthly
                                      ? Color(0xffC6DFFE)
                                      : Colors.white,
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
                                child: Column(
                                  children: [
                                    isMonthly
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: List.generate(
                                                currentPlans.length, (index) {
                                              return Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 4.0),
                                                width: 8.0,
                                                height: 8.0,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: _currentIndex == index
                                                      ? Colors.blue
                                                      : Colors.grey,
                                                ),
                                              );
                                            }),
                                          )
                                        : SizedBox(),
                                    SizedBox(
                                      height: isMonthly ? 10 : 20,
                                    ),
                                    Text(
                                      'Monthly',
                                      style: AppTextStyle.medium14,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isMonthly = false;
                              });
                              pricesetMethod();
                            },
                            child: Container(
                              color: !isMonthly
                                  ? Colors.transparent
                                  : Color(0xffC6DFFE),
                              child: Container(
                                width:
                                    (MediaQuery.of(context).size.width * 0.5) -
                                        16,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: !isMonthly
                                      ? Color(0xffC6DFFE)
                                      : Colors.white,
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
                                child: Column(
                                  children: [
                                    !isMonthly
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: List.generate(
                                                currentPlans.length, (index) {
                                              return Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 4.0),
                                                width: 8.0,
                                                height: 8.0,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: _currentIndex == index
                                                      ? Colors.blue
                                                      : Colors.grey,
                                                ),
                                              );
                                            }),
                                          )
                                        : SizedBox(),
                                    SizedBox(
                                      height: !isMonthly ? 10 : 20,
                                    ),
                                    Text(
                                      'Quarterly',
                                      style: AppTextStyle.medium14,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
                child: GestureDetector(
                  onTap: () async {
                    final currentPlan = currentPlans[_currentIndex];
                    final isBasic = currentPlan['type'] == 'basic';

                    final subscriptionCode = isMonthly && isBasic
                        ? 'monthly-essential-need-pack'
                        : isMonthly && !isBasic
                            ? 'monthly-premium-need-pack'
                            : !isMonthly && isBasic
                                ? 'quarterly-ultimate-wash-package'
                                : "quarterly-deluxe-maintenance-pack";

                    final subscriptionName = isMonthly && isBasic
                        ? 'Essential Need Pack'
                        : isMonthly && !isBasic
                            ? 'Premium Need Pack'
                            : !isMonthly && isBasic
                                ? 'Ultimate Wash Package'
                                : "Deluxe Maintenance Pack";

                    await cartController.addSubscriptionToCartSnackbar(
                      context,
                      cartController,
                      double.parse(price.toString()),
                      "1",
                      subscriptionCode,
                      subscriptionName,
                      scaffoldMessengerKey,
                    );

                    Get.toNamed(AppRoutes.CART);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    child: Ink(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            offset: Offset(0, 3),
                            blurRadius: 4,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '₹ $price',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "Add to Cart",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.26,
                  child: OffersSlidersSub(),
                ),
              ),
              SizedBox(
                height: 32,
              )
            ],
          ),
        ),
      ),
    );
  }
}
