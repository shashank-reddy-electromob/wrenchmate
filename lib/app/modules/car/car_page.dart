import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/car_controller.dart';

class CarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CarController controller = Get.find();
    return Scaffold(
      appBar: AppBar(title: Text('Car Details')),
      body: Center(child: Text('Car Page')),
    );
  }
}
