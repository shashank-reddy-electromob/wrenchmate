import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wrenchmate_user_app/app/controllers/searchcontroller.dart';
import 'package:wrenchmate_user_app/app/data/models/Service_firebase.dart';
import 'package:wrenchmate_user_app/app/routes/app_routes.dart';
import 'package:wrenchmate_user_app/app/widgets/appbar.dart';

class FilteredResultsPage extends StatelessWidget {
  final SearchControllerClass searchController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Filtered Results',
        onBackButtonPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: Obx(() {
        if (searchController.searchFilterResults.isEmpty) {
          return Center(
            child: Text('No matching results found.'),
          );
        } else {
          return ListView.builder(
            itemCount: searchController.searchFilterResults.length,
            itemBuilder: (context, index) {
              final result = searchController.searchFilterResults[index];
              final service = ServiceFirebase.fromMap(
                result.data() as Map<String, dynamic>,
                result.id,
              );

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
            },
          );
        }
      }),
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
                Text(description),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
