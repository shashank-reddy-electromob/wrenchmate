import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/service_controller.dart';

class ServicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ServiceController controller = Get.find();
    return Scaffold(
      appBar: AppBar(title: Text('Services')),
      body: Center(child: Text('Service Page')),
    );
  }
}
