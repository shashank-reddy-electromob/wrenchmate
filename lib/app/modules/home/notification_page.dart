import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';
import '../../data/providers/notifications_provider.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();
    return Scaffold(
      appBar: AppBar(title: Text('Notifications')),
      body: ListView.builder(
        itemCount: dummyNotifications.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              // Icon based on category
              Icon(Icons.notifications),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dummyNotifications[index].title),
                  Text(dummyNotifications[index].description),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
