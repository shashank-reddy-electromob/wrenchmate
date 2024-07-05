import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/support_controller.dart';

class SupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SupportController controller = Get.find();
    return Scaffold(
      appBar: AppBar(title: Text('Support')),
      body: Center(child: Text('Support Page')),
    );
  }
}
