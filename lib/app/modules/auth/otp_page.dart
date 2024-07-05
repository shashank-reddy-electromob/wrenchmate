import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/auth_controller.dart';

class optpage extends StatefulWidget {
  const optpage({super.key});

  @override
  State<optpage> createState() => _optpageState();
}

class _optpageState extends State<optpage> {
  final otpcontroller = TextEditingController();

  void _verifyotp() {
    print("tapeddddd");
    final AuthController controller = Get.find();
    controller.verifyOTP(
      otpcontroller.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(height: 300,),
          TextField(controller: otpcontroller,),
          ElevatedButton(onPressed: (){_verifyotp();}, child: Text("verify"))
        ],
      ),
    );
  }
}
