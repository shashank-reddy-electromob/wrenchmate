import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class RegisterPage extends StatelessWidget {
  String? number=Get.arguments;
  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find();
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Center(child: Text('Register Page ${number != null?number:""}')),
    );
  }
}
