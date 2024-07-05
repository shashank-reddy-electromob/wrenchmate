import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phonenumbercontroller = TextEditingController();

  void _login() {
    final AuthController controller = Get.find();
    controller.login(
      _phonenumbercontroller.text,
    );
  }
  void _googlelogin() {
    final AuthController controller = Get.find();
    controller.googleLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _phonenumbercontroller,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            ElevatedButton(
              onPressed: _googlelogin,
              child: Text('google'),
            ),
          ],
        ),
      ),
    );
  }
}