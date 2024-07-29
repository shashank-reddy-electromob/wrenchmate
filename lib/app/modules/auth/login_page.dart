import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phonenumbercontroller = TextEditingController();
   bool _isLoading=false;
   bool _isLoadingGoogle=false;

  void _login() async {
    setState(() {
      _isLoading = true;
    });
    final AuthController controller = Get.find();
    try {
      print("calling the controller functions");
      bool success = await controller.login(
          '+91${_phonenumbercontroller.text}', _phonenumbercontroller
      );
      print("true ya false: "+success.toString());
      if (!success) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Exception caught in _login: $e");
      setState(() {
        _isLoading = false;
      });
      Get.snackbar("Error", e.toString());
    }
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
        padding: EdgeInsets.all(16),
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff9DB3E5), Color(0xffFFFFFF), Color(0xffFFFFFF), Color(0xffFFFFFF)],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 128),
              //logo
              Image.asset(
                'assets/images/wrench_mate_logo.png',
                fit: BoxFit.cover,
              ),
              SizedBox(height: 32.0),
              //text
              Text(
                "Log In",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xff120D26)),
              ),
              SizedBox(height: 12.0),
              Text(
                "Hello, Welcome back to your account.",
                style: TextStyle(fontSize: 16, color: Color(0xff969696)),
              ),
              //textfield
              SizedBox(height: 24.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.transparent,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _phonenumbercontroller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Enter number',
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 22.0), // Increased hint text size
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.transparent,
                          ),
                          style: TextStyle(fontSize: 22.0), // Increased entered text size
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32.0),
              //submit
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 60,
                child: _isLoading
                    ? Center(child: CircularProgressIndicator(color:  Color(0xff1671D8),)) // Show loader
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.blue,
                          backgroundColor: Color(0xff1671D8), // Text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                        onPressed: _login,
                        child: Text(
                          'REQUEST OTP',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
              ),
              SizedBox(height: 32.0),
              Text(
                "OR",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xff969696)),
              ),
              SizedBox(height: 32.0),
              //google
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 60,
                child: _isLoadingGoogle
                    ? Center(child: CircularProgressIndicator(color: Color(0xff1671D8),)) // Show loader
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
                            SizedBox(width: 8),
                            Text(
                              'Login With Google',
                              style: TextStyle(color: Color(0xff120D26), fontSize: 20),
                            ),
                          ],
                        ),
                      ),
              ),
              SizedBox(height: 16.0),
              //facebook
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
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
                      SizedBox(width: 8),
                      Text(
                        'Login With Facebook',
                        style: TextStyle(color: Color(0xff120D26), fontSize: 20),
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