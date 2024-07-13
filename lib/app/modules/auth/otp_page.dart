import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pinput/pinput.dart';
import 'package:wrenchmate_user_app/app/widgets/blueButton.dart';

import '../../controllers/auth_controller.dart';
import '../../widgets/custombackbutton.dart';

class optpage extends StatefulWidget {
  const optpage({super.key});

  @override
  State<optpage> createState() => _optpageState();
}

class _optpageState extends State<optpage> {
  final otpcontroller = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;
  final number = Get.arguments;
  int _start = 20;
  late Timer _timer;
  bool buttonVisiblity = false;

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_start == 1) {
        //_resendotp();
        setState(() {
          buttonVisiblity = true;
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _verifyotp() {
    final AuthController controller = Get.find();
    controller.verifyOTP(otpcontroller.text, number, otpcontroller);
  }

  void _resendotp() {
    setState(() {
      buttonVisiblity=false;
      _start = 20;
    });
    final AuthController controller = Get.find();
    controller.resendOTP(number, otpcontroller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 60,
            ),
            Custombackbutton(),
            Container(
              height: 20,
            ),
            Text(
              "Verification",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
            Container(
              height: 10,
            ),
            Text(
              "We’ve send you the verification \ncode on ${number}",
              style: TextStyle(fontSize: 20, color: Color(0xff969696)),
            ),
            Container(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Pinput(
                controller: otpcontroller,
                length: 6,
                defaultPinTheme: PinTheme(
                  width: 56,
                  height: 56,
                  textStyle: TextStyle(fontSize: 30, color: Colors.black),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Color(0xffE4DFDF)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                focusedPinTheme: PinTheme(
                  width: 56,
                  height: 56,
                  textStyle: TextStyle(fontSize: 30, color: Colors.black),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Color(0xff1671D8)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            Container(
              height: 20,
            ),
            blueButton(
                text: "VERIFY",
                onTap: () {
                  _verifyotp();
                }),
            Container(
              height: 20,
            ),
            buttonVisiblity?
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                child: Text("Resend otp",style: TextStyle(fontSize: 18,color: Color(0xff1671D8)),),
                onTap: _resendotp,
              ),
            ): Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        ' Re-send code in ',
                        style: TextStyle(fontSize: 18),
                      ),Text(
                        '0:${_start}',
                        style: TextStyle(fontSize: 18,color: Color(0xff1671D8)),
                      ),
                  ],
                ),
          ],
        ),
      ),
    );
  }
}
