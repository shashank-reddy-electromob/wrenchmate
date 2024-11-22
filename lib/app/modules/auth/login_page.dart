import 'dart:developer';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart' as loc;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wrenchmate_user_app/app/widgets/blueButton.dart';
import '../../controllers/auth_controller.dart';
import '../../routes/app_routes.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phonenumbercontroller = TextEditingController();
  String _countryCode = '+91'; // Default country code for India
  bool _isLoading = false;
  bool _isLoadingGoogle = false;
  final AuthController controller = Get.find();

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    final AuthController controller = Get.find();
    print("calling the controller functions");
    print('$_countryCode${_phonenumbercontroller.text}');
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '$_countryCode${_phonenumbercontroller.text}',
      verificationCompleted: (PhoneAuthCredential credential) {
        controller.handleSignIn(credential, _phonenumbercontroller);
        setState(() {
          _isLoading = false;
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print("Verification failed: ${e.message}");
        Get.snackbar("Error", "Login failed: ${e.toString()}");
        setState(() {
          _isLoading = false;
        });
      },
      codeSent: (String verificationId, int? resendToken) {
        print("OTP sent: $verificationId");
        Get.toNamed(AppRoutes.OTP,
            arguments: '+91${_phonenumbercontroller.text}');
        controller.verificationid.value = verificationId;
        controller.resendToken = resendToken;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        controller.verificationid.value = verificationId;
      },
    );
  }

  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _googlelogin() async {
    setState(() {
      _isLoadingGoogle = true; // Show loader
    });
    final AuthController controller = Get.find();
    try {
      await controller.googleLogin();
    } catch (e) {
      // Handle exception and reset the button state
      print("Exception caught in _googlelogin: $e");
      Get.snackbar("Error", e.toString());
    } finally {
      setState(() {
        _isLoadingGoogle = false; // Hide loader
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getLocation();
    super.initState();
  }


  Future<void> getLocation() async {
    try {
      var location = loc.Location();
      final currentLocation = await location.getLocation();
      if (currentLocation != null) {
        saveLocationToSharedPreferences(currentLocation!);
      }
    } catch (e) {
      print('Error fetching location: $e');
    }
  }

  Future<void> saveLocationToSharedPreferences(
      loc.LocationData location) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('latitude', location.latitude ?? 0.0);
    await prefs.setDouble('longitude', location.longitude ?? 0.0);
  }


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff9DB3E5),
              Color(0xffFFFFFF),
              Color(0xffFFFFFF),
              Color(0xffFFFFFF)
            ],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.08),
              //logo
              Image.asset(
                height: 140,
                'assets/images/logo.png',
                fit: BoxFit.cover,
              ),
              SizedBox(height: height * 0.065),
              //text
              const Text(
                "Log In",
                style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff120D26)),
              ),
              const SizedBox(height: 12.0),
              const Text(
                "Hello, Welcome back to your account.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15,
                    color: Color(0xff969696),
                    fontFamily: 'Poppins'),
              ),
              //textfield
              SizedBox(height: height * 0.025),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.transparent,
                  ),
                  child: Row(
                    children: [
                      CountryCodePicker(
                        onChanged: (country) {
                          setState(() {
                            _countryCode = country.dialCode!;
                          });
                        },
                        initialSelection: 'IN', // Set default to India
                        favorite: ['+91', 'IN'],
                        hideMainText: true,
                        showOnlyCountryWhenClosed:
                            true, // Show only the flag when closed
                        alignLeft: true, // Align the flag to the center
                        padding: EdgeInsets.zero, // Remove padding
                        flagDecoration: BoxDecoration(
                          shape: BoxShape.circle, // Make the flag circular
                        ),
                        hideSearch: true,
                        showDropDownButton: true, // Show the dropdown arrow
                        textStyle:
                            TextStyle(fontSize: 0), // Hide the country name
                      ),
                      Expanded(
                        child: TextField(
                          controller: _phonenumbercontroller,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(
                                10), // Limit to 10 digits
                          ],
                          decoration: const InputDecoration(
                            hintText: 'Enter number',
                            hintStyle: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.grey,
                                fontSize: 16.0), // Increased hint text size
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.transparent,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0), // Remove vertical padding
                          ),
                          style: TextStyle(
                              fontSize: 16.0), // Increased entered text size
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: height * 0.035),
              //submit
              Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                          color: Color(0xff1671D8),
                        )) // Show loader
                      : BlueButton(
                          fontSize: 17,
                          text: 'REQUEST OTP',
                          onTap: _isLoading ? () {} : _login,
                          icon: Icons.arrow_forward_outlined,
                        )),
              SizedBox(height: height * 0.04),
              Text(
                "OR",
                style: TextStyle(
                    fontSize: 17,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: Color(0xff969696)),
              ),
              SizedBox(height: height * 0.035),
              //google
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: 50,
                child: _isLoadingGoogle
                    ? Center(
                        child: CircularProgressIndicator(
                        color: Color(0xff1671D8),
                      )) // Show loader
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 1,
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.white, // Text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                        onPressed: _googlelogin,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/google logo.png',
                              fit: BoxFit.cover,
                            ),
                            SizedBox(width: 18),
                            Text(
                              'Login With Google',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Color(0xff120D26),
                                  fontSize: 15),
                            ),
                          ],
                        ),
                      ),
              ),
              SizedBox(height: 16.0),
              //facebook
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 1,
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.white, // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  onPressed: () async {
                    await controller.signInWithApple();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/apple_logo.png',
                        height: 30,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 18),
                      Text(
                        'Login With Apple',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Color(0xff120D26),
                            fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
