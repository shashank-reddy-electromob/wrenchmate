import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wrenchmate_user_app/app/modules/auth/widgets/CustomTextField.dart';
import 'package:wrenchmate_user_app/app/widgets/blueButton.dart';
import 'package:wrenchmate_user_app/app/widgets/custombackbutton.dart';
import '../../controllers/auth_controller.dart';
import '../../routes/app_routes.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? userId;
  late final AuthController controller;



  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController alternateNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> register() async {
    String? name = nameController.text.isNotEmpty ? nameController.text : null;
    String? number = numberController.text.isNotEmpty ? numberController.text : null;
    String? alternateNumber = alternateNumberController.text.isNotEmpty ? alternateNumberController.text : null;
    String? email = emailController.text.isNotEmpty ? emailController.text : null;
    String? address = addressController.text.isNotEmpty ? addressController.text : null;
    String profileImagePath = _image?.path ?? '';

    if (name == null) {
      Get.snackbar('Error', 'Name field is empty');
    } else if (number == null) {
      Get.snackbar('Error', 'Number field is empty');
    } else if (alternateNumber == null) {
      Get.snackbar('Error', 'Alternate Number field is empty');
    } else if (email == null) {
      Get.snackbar('Error', 'Email field is empty');
    } else if (address == null) {
      Get.snackbar('Error', 'Address field is empty');
    } else {
      await controller.addUserToFirestore(
        name: name,
        number: number,
        alternateNumber: alternateNumber,
        email: email,
        address: address,
        profileImagePath: profileImagePath.isNotEmpty ? profileImagePath : null,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser!.phoneNumber;
    controller = Get.find();
    if (userId != null){
      numberController.text=userId!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 18),
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
            children: [
              SizedBox(height: 30),
              Row(
                children: [
                  Custombackbutton(),
                  SizedBox(width: 18),
                  Text(
                    "Profile",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 106.0,
                  height: 106.0,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: _image != null ? FileImage(_image!) : null,
                    child: _image == null
                        ? ClipOval(
                      child: Image.asset(
                        'assets/images/person.png',
                        fit: BoxFit.cover,
                        height: 100.0,
                        width: 100.0,
                      ),
                    )
                        : null,
                  ),
                ),
              ),
              SizedBox(height: 30),
              CustomTextField(
                controller: nameController,
                hintText: 'Full Name',
              ),
              CustomTextField(
                controller: numberController,
                hintText: userId!,
              ),
              CustomTextField(
                controller: alternateNumberController,
                hintText: 'Alternative Mobile Number',
              ),
              CustomTextField(
                controller: emailController,
                hintText: 'Email Address',
              ),
              SizedBox(height: 20),
              blueButton(
                text: "CONTINUE",
                onTap: () async {
                  await register();
                },
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: GestureDetector(
                  //skip functionality
                  onTap: () {
                    Get.toNamed(AppRoutes.BOTTOMNAV);
                  },
                  child: Text(
                    "SKIP FOR NOW",
                    style: TextStyle(fontSize: 18, color: Color(0xff595959)),
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
