import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wrenchmate_user_app/app/controllers/searchcontroller.dart';
import 'package:wrenchmate_user_app/app/modules/home/widgits/services.dart';
import 'package:wrenchmate_user_app/app/modules/home/widgits/toprecommendedservices.dart';
import 'package:wrenchmate_user_app/app/routes/app_routes.dart';

import '../../data/models/Service_Firebase.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchControllerClass searchController =
      Get.put(SearchControllerClass());

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => SearchControllerClass());
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios_new_outlined,
                            color: Colors.black),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: searchController.searchController,
                        decoration: InputDecoration(
                          hintText: 'Search services & Packages',
                          hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(Icons.search, color: Colors.grey),
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Color(0xffF5F5F5),
                          contentPadding: EdgeInsets.all(10),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Obx(() => _buildSearchResults()),
                SizedBox(height: 20),
                Text('Your search history',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 10),
                Obx(() {
                  return Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: searchController.searchHistory
                        .map((name) => _buildChip(name))
                        .toList(),
                  );
                }),
                SizedBox(height: 20),
                Text('Popular Services',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                SizedBox(height: 10),
                Obx(() {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: searchController.popularServices
                          .map((service) => GestureDetector(
                                onTap: () {
                                  Get.toNamed(AppRoutes.SERVICE_DETAIL,
                                      arguments: service);
                                },
                                child: ServiceCard(
                                  serviceName: service.name,
                                  price: service.price.toString(),
                                  rating: service.averageReview,
                                  imagePath: 'assets/car/toprecommended1.png',
                                  colors: [
                                    Color(0xff9DB3E5),
                                    Color(0xff3E31BF)
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                  );
                }),
                SizedBox(height: 20),
                Text('Top Categories',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                SizedBox(height: 10),
                Obx(() {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: searchController.topCategories
                          .map((category) => ServicesType(
                                text: category.category,
                                borderSides: [
                                  BorderSideEnum.bottom,
                                  BorderSideEnum.right
                                ],
                                imagePath: 'assets/services/car wash.png',
                                onTap: () =>
                                    navigateToServicePage(category.category),
                              ))
                          .toList(),
                    ),
                  );
                }),
                SizedBox(height: 20),
                Text('Top Services',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                SizedBox(height: 10),
                Obx(() {
                  return Column(
                    children: searchController.topServices
                        .map((service) => GestureDetector(
                              onTap: () {
                                Get.toNamed(AppRoutes.SERVICE_DETAIL,
                                    arguments: service);
                              },
                              child: _buildTopServiceCard(
                                serviceName: service.name,
                                imageUrl: service.image,
                                time: service.time,
                                warranty: service.warranty,
                                description: service.description,
                              ),
                            ))
                        .toList(),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (searchController.searchResults.isEmpty &&
        searchController.searchController.text.isNotEmpty) {
      return Center(
        child: Text(
          "No results found",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: searchController.searchResults.map((result) {
          final data = result.data() as Map<String, dynamic>;
          final service = ServiceFirebase.fromMap(data, result.id);

          return GestureDetector(
            onTap: () {
              Get.toNamed(AppRoutes.SERVICE_DETAIL, arguments: service);
            },
            child: _buildTopServiceCard(
              serviceName: service.name,
              imageUrl: service.image,
              time: service.time,
              warranty: service.warranty,
              description: service.description,
            ),
          );
        }).toList(),
      );
    }
  }

  void navigateToServicePage(String service) {
    Get.toNamed('/service', arguments: service);
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

  Widget _buildTopServiceCard({
    required String serviceName,
    required String imageUrl,
    required String time,
    required String warranty,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              imageUrl,
              height: 70,
              width: 70,
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  serviceName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text('Takes $time'),
                    SizedBox(width: 4),
                    Text('$warranty Warranty'),
                  ],
                ),
                Text('Includes 15 Services'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
