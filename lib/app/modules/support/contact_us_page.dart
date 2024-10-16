import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/support_controller.dart';

class ContactUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SupportController controller = Get.find();
    return Scaffold(
      appBar: AppBar(title: Text('Contact Us')),
      body: Center(child: Text('Contact Us Page')),
    );
  }
}
