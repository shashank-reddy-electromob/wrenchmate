import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/tracking_controller.dart';

class TrackingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TrackingController controller = Get.find();
    return Scaffold(
      appBar: AppBar(title: Text('Tracking')),
      body: Center(child: Text('Tracking Page')),
    );
  }
}
