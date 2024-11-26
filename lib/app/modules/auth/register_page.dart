import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wrenchmate_user_app/app/localstorage/localstorage.dart';
import 'package:wrenchmate_user_app/app/modules/auth/widgets/CustomTextField.dart';
import 'package:wrenchmate_user_app/app/widgets/blueButton.dart';
import 'package:wrenchmate_user_app/app/widgets/custombackbutton.dart';
import 'package:wrenchmate_user_app/main.dart';
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
  final TextEditingController alternateNumberController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  File? _image;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String?> uploadImageToStorage(File image) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User not logged in');
      }
      String userId = currentUser.uid;
      final storageReference = FirebaseStorage.instance.ref('/Users');
      final fileName = image.path.split('/').last;
      final dateStamp = DateTime.now().microsecondsSinceEpoch;
      final uploadReference =
          storageReference.child('$userId/ProfileImage/$dateStamp-$fileName');
      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
      );
      TaskSnapshot taskSnapshot =
          await uploadReference.putFile(image, metadata);
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      print("Failed to upload image: $e");
      return null;
    }
  }

  Future<void> register() async {
    setState(() {
      _isLoading = true;
    });

    String? name = nameController.text.isNotEmpty ? nameController.text : null;
    String? number =
        numberController.text.isNotEmpty ? numberController.text : null;
    String? alternateNumber = alternateNumberController.text.isNotEmpty
        ? alternateNumberController.text
        : '';
    String? email = emailController.text.isNotEmpty ? emailController.text : '';
    String? address =
        addressController.text.isNotEmpty ? addressController.text : '';
    String? profileImagePath;
    prefs?.setBool(LocalStorage.isLogin, true) ?? false;
    print(
        "prefs?.getBool(LocalStorage.isLogin) :: ${prefs?.getBool(LocalStorage.isLogin)}");
    if (_image != null) {
      profileImagePath = await uploadImageToStorage(_image!);
    }

    if (name == null || !RegExp(r'^[a-zA-Z\s]+$').hasMatch(name)) {
      Get.snackbar('Error', 'Invalid or empty name field');
    } else if (number == null || !RegExp(r'^\d{10}$').hasMatch(number)) {
      Get.snackbar('Error', 'Invalid or empty number field');
    } else {
      try {
        await controller.addUserToFirestore(
          name: name,
          number: number,
          alternateNumber: alternateNumber,
          email: email,
          address: address,
          profileImagePath: profileImagePath,
        );
        Get.toNamed(AppRoutes.MAPSCREEN);
      } catch (e) {
        print("Failed to add user to Firestore: $e");
        Get.snackbar('Error', 'Failed to register user. Please try again.');
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args != null ) {
      nameController.text = args['fullname'] == 'User' ? '' : args['fullname'];
      emailController.text = args['email'];
      numberController.text = args['phone'];
    }
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      userId = currentUser.phoneNumber;
      controller = Get.find();
      if (userId != null) {
        numberController.text = userId!.substring(userId!.length - 10);
      }
    } else {
      // Handle the case where the user is not logged in
      Get.snackbar('Error', 'User not logged in');
    }
    print("userId: $userId"); // Add this line to log userId
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 18),
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
            children: [
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
                hintText: userId ?? 'Enter your number', // Add null check here
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
              _isLoading
                  ? CircularProgressIndicator(color: Color(0xff1671D8))
                  : BlueButton(
                      text: "CONTINUE",
                      onTap: () async {
                        await register();
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
