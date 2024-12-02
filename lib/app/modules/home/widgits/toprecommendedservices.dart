import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/Service_firebase.dart';
import '../../../routes/app_routes.dart';
import '../../service/service_page.dart';

class toprecommendedservices extends StatefulWidget {
  const toprecommendedservices({super.key});

  @override
  State<toprecommendedservices> createState() => _toprecommendedservicesState();
}

class _toprecommendedservicesState extends State<toprecommendedservices> {
  Servicefirebase wash_service = new Servicefirebase(
      id: "DVa006J2yZgibIM3Vyr4",
      category: "Car Wash",
      description:
          "Give your car a sparkling clean with our exterior foam wash and interior cleaning",
      discount: 0,
      name: "Exterior Wash",
      image: "https://firebasestorage.googleapis.com/v0/b/user-app-6aaf1.appspot.com/o/Services%2Fexterior%20wash%201.png?alt=media&token=d5cf2401-327d-4c1d-ab01-403040109d79",
      price: 700,
      time: "1",
      warranty: "",
      averageReview: 3.5,
      numberOfReviews: 3,
      carmodel: ['SUV', 'Compact SUV']);

  Servicefirebase plastic_trim_service = new Servicefirebase(
      id: "dq6joq3HSFf7EPcGR9De",
      category: "Detailing",
      description:
          "A plastic trim restorer brings back the original color and shine of faded plastic and rubber trims on your car, making them look new while protecting them from future fading or cracking",
      discount: 0,
      name: "Plastic Trim Restorer",
      image: "https://firebasestorage.googleapis.com/v0/b/user-app-6aaf1.appspot.com/o/Services%2Fplastictrimrestorer.jpg?alt=media&token=d5db623f-04db-4a4b-badc-dcb8e870babc",
      price: 1800,
      time: "1",
      warranty: "",
      averageReview: 4,
      numberOfReviews: 3,
      carmodel: ['SUV', 'Compact SUV', 'Hactchback']);

  Servicefirebase glass_repellent_service = new Servicefirebase(
      id: "zHWXW60AV3GTx6fh5QiT",
      category: "Detailing",
      description:
          "A glass repellent keeps your windshield and windows clear by making water slide off quickly, improving visibility in rain and making it easier to clean dirt and grime.",
      discount: 0,
      name: "Glass Repellent",
      image: "https://firebasestorage.googleapis.com/v0/b/user-app-6aaf1.appspot.com/o/Services%2Fglassrepellent.jpg?alt=media&token=68d995d8-24bb-4bec-a019-9d432ca770bf",
      price: 1500,
      time: "1",
      warranty: "",
      averageReview: 4,
      numberOfReviews: 3,
      carmodel: ['SUV', 'Compact SUV', 'Hactchback']);

  Servicefirebase ceramic_service = new Servicefirebase(
      id: "1Jnv4P0Klgx87esxlEbM",
      category: "Detailing",
      description:
          "Enhance your vehicle’s shine and protection with our ceramic coating service. This high-tech coating creates a durable, hydrophobic layer that repels water and contaminants, making your car easier to clean and maintain.",
      discount: 0,
      name: "Ceramic Coat",
      image: "https://firebasestorage.googleapis.com/v0/b/user-app-6aaf1.appspot.com/o/Services%2Fceramic%20coat.png?alt=media&token=325ed269-5740-40aa-9aa1-cd5ce9b994b2",
      price: 14000,
      time: "72",
      warranty: "",
      averageReview: 4.5,
      numberOfReviews: 3,
      carmodel: ['SUV', 'Compact SUV']);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //servicefetchWash();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 8,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.SERVICE_DETAIL, arguments: {
                    'service': wash_service,
                    'currService': 'General Wash'
                  });
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
                child: ServiceCard(
                  serviceName: "General Wash",
                  price: "700",
                  rating: 4.9,
                  imagePath: 'assets/car/toprecommended1.png',
                  colors: [Color(0xff9DB3E5), Color(0xff3E31BF)],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.SERVICE_DETAIL, arguments: {
                    'service': ceramic_service,
                    'currService': 'Ceramic Coating'
                  });
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
                child: ServiceCard(
                  serviceName: "Ceramic Coating",
                  price: "14,000",
                  rating: 4.9,
                  imagePath: 'assets/car/toprecommended2.png',
                  colors: [Color(0xffFEA563), Color(0xffFF5F81)],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.SERVICE_DETAIL, arguments: {
                    'service': plastic_trim_service,
                    'currService': 'Plastic Trim Restorer'
                  });
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
                child: ServiceCard(
                  serviceName: "Plastic Trim Restorer",
                  price: "1,400",
                  rating: 4.7,
                  imagePath: 'assets/car/toprecommended3.png',
                  colors: [
                    Color(0xff86E3CE),
                    Color.fromARGB(255, 34, 162, 135)
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.SERVICE_DETAIL, arguments: {
                    'service': glass_repellent_service,
                    'currService': 'Glass Repellent'
                  });
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
                child: ServiceCard(
                  serviceName: "Glass Repellent",
                  price: "1,400",
                  rating: 4.8,
                  imagePath: 'assets/car/toprecommended4.png',
                  colors: [Color(0xffF3C5C5), Color.fromARGB(255, 181, 14, 14)],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class GradientContainer extends StatelessWidget {
  final double width;
  final double height;

  final List<Color> colors;
  final Widget child;

  const GradientContainer({
    Key? key,
    required this.width,
    required this.height,
    required this.colors,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0, bottom: 20),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: child,
      ),
    );
  }
}
// import 'package:flutter/material.dart';

class ServiceCard extends StatelessWidget {
  final String serviceName;
  final String price;
  final double rating;
  final List<Color> colors;

  final String imagePath;

  ServiceCard({
    required this.serviceName,
    required this.price,
    required this.rating,
    required this.colors,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      width: MediaQuery.of(context).size.width / 2 - 16,
      height: MediaQuery.of(context).size.width * 0.32,
      colors: colors,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  imagePath,
                  height: MediaQuery.of(context).size.width * 0.13,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: MediaQuery.of(context).size.width * 0.041,
                      ),
                      SizedBox(width: 4),
                      Text(
                        rating.toString(),
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: MediaQuery.of(context).size.width * 0.026,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.width * 0.04),
            Text(
              serviceName,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.031,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              '₹ $price',
              style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: MediaQuery.of(context).size.width * 0.026,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
