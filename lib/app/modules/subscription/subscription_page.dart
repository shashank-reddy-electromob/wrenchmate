import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/subscription_controller.dart';

class SubscriptionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SubscriptionController controller = Get.find();
    return Scaffold(
      appBar: AppBar(title: Text('Subscription')),
      body: Center(child: Text('Subscription Page')),
    );
  }
}
