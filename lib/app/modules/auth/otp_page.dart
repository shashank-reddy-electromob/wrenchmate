import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pinput/pinput.dart';
import 'package:wrenchmate_user_app/app/widgets/blueButton.dart';

import '../../controllers/auth_controller.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custombackbutton.dart';

class optpage extends StatefulWidget {
  const optpage({super.key});

  @override
  State<optpage> createState() => _optpageState();
}

class _optpageState extends State<optpage> {
  final otpcontroller = TextEditingController();
  final number = Get.arguments;
  int _start = 60;
  late Timer _timer;
  bool buttonVisiblity = false;
  bool _isLoading = false; // Add loading state

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

  void _verifyotp() async {
    setState(() {
      _isLoading = true;
    });
    final AuthController controller = Get.find();
    try {
      await controller.verifyOTP(
          otpcontroller.text.toString(), number, otpcontroller);
    } catch (e) {
      print("Exception caught in _verifyotp: $e");
      Get.snackbar("Error", e.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _resendotp() {
    setState(() {
      buttonVisiblity = false;
      _start = 60;
    });
    final AuthController controller = Get.find();
    controller.resendOTP(number, otpcontroller);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 30,
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xffF6F6F5),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: IconButton(
                  icon: Icon(
                    CupertinoIcons.back,
                    color: Color(0xff1E1E1E),
                    size: 22,
                  ),
                  onPressed: () {
                    Get.toNamed(AppRoutes.LOGIN);
                  },
                ),
              ),
              Container(
                height: 20,
              ),
              Text(
                "Verification",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins'),
              ),
              Container(
                height: 10,
              ),
              Text(
                "We've send you the verification \ncode on ${number}",
                style: TextStyle(
                    fontSize: width * 0.045,
                    color: Color(0xff969696),
                    fontFamily: 'Poppins'),
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
              _isLoading
                  ? Center(
                      child:
                          CircularProgressIndicator(color: Color(0xff1671D8)))
                  : BlueButton(
                      text: "VERIFY",
                      onTap: _isLoading ? () {} : _verifyotp,
                    ),
              Container(
                height: 20,
              ),
              buttonVisiblity
                  ? Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        child: Text(
                          "Resend otp",
                          style:
                              TextStyle(fontSize: 18, color: Color(0xff1671D8)),
                        ),
                        onTap: _resendotp,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          ' Re-send code in ',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          '0:${_start}',
                          style:
                              TextStyle(fontSize: 18, color: Color(0xff1671D8)),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
