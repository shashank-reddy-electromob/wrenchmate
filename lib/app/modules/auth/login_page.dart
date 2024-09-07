import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
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

    // Validate phone number before proceeding
    if (_phonenumbercontroller.text.isEmpty ||
        _phonenumbercontroller.text.length < 10) {
      Get.snackbar("Error", "Please enter a valid phone number");
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber:
            '$_countryCode${_phonenumbercontroller.text}', // Ensure correct format
        verificationCompleted: (PhoneAuthCredential credential) {
          controller.handleSignIn(credential, _phonenumbercontroller);
          setState(() {
            _isLoading = false;
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print("Verification failed: ${e.message}");
          Get.snackbar("Error", "Login failed: ${e.message}");
          setState(() {
            _isLoading = false;
          });
        },
        codeSent: (String verificationId, int? resendToken) {
          print("OTP sent: $verificationId");
          Get.toNamed(AppRoutes.OTP,
              arguments: '$_countryCode${_phonenumbercontroller.text}');
          controller.verificationid.value = verificationId;
          controller.resendToken =
              resendToken ?? 0; // Handle potential null value
          setState(() {
            _isLoading = false;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          controller.verificationid.value = verificationId;
        },
      );
    } catch (e) {
      print("Error during phone verification: $e");
      Get.snackbar("Error", "Something went wrong: $e");
      setState(() {
        _isLoading = false;
      });
    }
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
  Widget build(BuildContext context) {
    return Scaffold(
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
              SizedBox(height: 80),
              //logo
              Image.asset(
                height: 140,
                'assets/images/logo.png',
                fit: BoxFit.cover,
              ),
              SizedBox(height: 64.0),
              //text
              Text(
                "Log In",
                style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff120D26)),
              ),
              SizedBox(height: 12.0),
              Text(
                "Hello, Welcome back to your account.",
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff969696),
                    fontFamily: 'Poppins'),
              ),
              //textfield
              SizedBox(height: 24.0),
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
                          decoration: InputDecoration(
                            hintText: 'Enter number',
                            hintStyle: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.grey,
                                fontSize: 22.0), // Increased hint text size
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.transparent,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0), // Remove vertical padding
                          ),
                          style: TextStyle(
                              fontSize: 22.0), // Increased entered text size
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32.0),
              //submit
              Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: _isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                          color: Color(0xff1671D8),
                        )) // Show loader
                      : blueButton(
                          text: 'REQUEST OTP',
                          onTap: _isLoading ? null : _login)),
              SizedBox(height: 32.0),
              Text(
                "OR",
                style: TextStyle(
                    fontSize: 22,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: Color(0xff969696)),
              ),
              SizedBox(height: 32.0),
              //google
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: 60,
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
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      ),
              ),
              SizedBox(height: 16.0),
              //facebook
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 1,
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.white, // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/facebok_logo.png',
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 18),
                      Text(
                        'Login With Facebook',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Color(0xff120D26),
                            fontSize: 16),
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
