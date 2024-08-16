import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wrenchmate_user_app/app/modules/home/widgits/searchbar_filter.dart';
import 'package:wrenchmate_user_app/app/modules/home/widgits/services.dart';
import 'package:wrenchmate_user_app/app/modules/home/widgits/toprecommendedservices.dart';
import 'package:wrenchmate_user_app/app/routes/app_routes.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: Colors.white,
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back, color: Colors.black),
      //     onPressed: () {},
      //   ),
      //   title: TextField(
      //     decoration: InputDecoration(
      //       hintText: 'Search services & Packages',
      //       hintStyle: TextStyle(color: Colors.grey),
      //       prefixIcon: Icon(Icons.search, color: Colors.grey),
      //       border: InputBorder.none,
      //       filled: true,
      //       fillColor: Color(0xffF5F5F5),
      //       contentPadding: EdgeInsets.all(10),
      //     ),
      //   ),
      // ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                searchbar(
                  showFilter: false,
                ),
                Text(
                  'Your search history',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: [
                    _buildChip('Car'),
                    _buildChip('Car wash'),
                    _buildChip('Service'),
                    _buildChip('Wheel'),
                    _buildChip('Repair'),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Popular Services',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    ServiceCard(
                      serviceName: "General Wash",
                      price: "1,400",
                      rating: 4.9,
                      imagePath: 'assets/car/toprecommended1.png',
                      colors: [
                        Color(0xff9DB3E5),
                        Color(0xff3E31BF)
                      ], // Make sure you have an image in your assets
                    ),
                    // GradientContainer(
                    //   width: MediaQuery.of(context).size.width/2-36,
                    //   height: 120,
                    //   colors: [Color(0xff9DB3E5), Color(0xff3E31BF)], // Define the gradient colors
                    //   child: Text(""),
                    // ),
                    ServiceCard(
                      serviceName: "General Check-up",
                      price: "1,400",
                      rating: 4.9,
                      imagePath: 'assets/car/toprecommended2.png',
                      colors: [
                        Color(0xffFEA563),
                        Color(0xffFF5F81)
                      ], // Make sure you have an image in your assets
                    ),
                    // GradientContainer(
                    //   width: MediaQuery.of(context).size.width / 2 - 36,
                    //   height: 120,
                    //   colors: [
                    //     Color(0xffFEA563),
                    //     Color(0xffFF5F81)
                    //   ], // Define the gradient colors
                    //   child: Text(""),
                    // ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Top Categories',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    ServicesType(
                      text: "Car Wash",
                      borderSides: [
                        BorderSideEnum.bottom,
                        BorderSideEnum.right
                      ],
                      imagePath: 'assets/services/car wash.png',
                      onTap: () => navigateToServicePage("Car Wash"),
                    ),
                    ServicesType(
                      text: "Detailing",
                      borderSides: [
                        BorderSideEnum.right,
                        BorderSideEnum.bottom
                      ],
                      imagePath: 'assets/services/detailing.png',
                      onTap: () => navigateToServicePage("Detailing"),
                    ),
                    ServicesType(
                      text: "Denting and Painting",
                      borderSides: [
                        BorderSideEnum.bottom,
                        BorderSideEnum.right
                      ],
                      imagePath: 'assets/services/painting.png',
                      onTap: () =>
                          navigateToServicePage("Denting and Painting"),
                    ),
                    ServicesType(
                      text: "Repairing",
                      borderSides: [BorderSideEnum.bottom],
                      imagePath: 'assets/services/repair.png',
                      onTap: () => navigateToServicePage("Repairing"),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Top Services',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                SizedBox(height: 10),
                _buildTopServiceCard(),
                _buildTopServiceCard(),
                _buildTopServiceCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void navigateToServicePage(String service) {
    Get.toNamed(AppRoutes.SERVICE, arguments: service);
  }

  Widget _buildChip(String label) {
    return Chip(
      label: Text(label),
      backgroundColor: Color.fromARGB(172, 245, 245, 245),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Color.fromARGB(172, 245, 245, 245)),
      ),
    );
  }

  Widget _buildTopServiceCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              'assets/images/topImages.png',
              // height: 60.0,
              // width: 60.0,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Service Name',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Text('• Takes 4 Hour  • 1 Month Warranty'),
              SizedBox(height: 5),
              Text('• Includes 15 Services'),
            ],
          )
        ],
      ),
    );
  }
}
