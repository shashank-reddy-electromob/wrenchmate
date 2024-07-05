import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/service_controller.dart';

class ServiceDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ServiceController controller = Get.find();
    return Scaffold(
      appBar: AppBar(title: Text('Service Details')),
      body: Center(child: Text('Service Detail Page')),
    );
  }
}
