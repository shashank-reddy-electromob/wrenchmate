import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wrenchmate_user_app/app/modules/auth/register_page.dart';
import 'package:wrenchmate_user_app/app/widgets/blueButton.dart';
import '../../controllers/home_controller.dart';
import '../auth/widgets/CustomTextField.dart';
import 'package:image_picker/image_picker.dart'; // Import the image_picker package
import 'dart:io'; // Import dart:io to use File

class EditProfile extends StatefulWidget {
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController alternateNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final HomeController homeController = Get.put(HomeController());

  Map<String, dynamic>? userData;
  File? _image; // Variable to hold the selected image
  bool _isLoading = false; // Add this variable

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    homeController.fetchUserData().then((data) {
      setState(() {
        userData = data as Map<String, dynamic>?;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Obx(() {
        if (homeController.userData.isEmpty) {
          return Center(child: CircularProgressIndicator());
        } else {
          nameController.text = userData?['User_name'] ?? '';
          numberController.text =  userData?['User_number'][0] ?? '';
          alternateNumberController.text = userData?['User_number'][1] ?? '';
          emailController.text =   userData?['User_email'] ?? '';
          return SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height-100,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: GestureDetector( // Make the image clickable
                        onTap: _pickImage, // Call the image picker on tap
                        child: ClipOval(
                          child: _image != null
                            ? Image.file(
                                File(_image!.path), // Use Image.file for local images
                                fit: BoxFit.cover,
                                height: 85.0,
                                width: 85.0,
                              )
                            : Image.network(
                                userData?['User_profile_image'], // Fallback to fetched image
                                fit: BoxFit.cover,
                                height: 85.0,
                                width: 85.0,
                              ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    CustomTextField(
                      controller: nameController,
                      hintText: 'Name',
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      controller: emailController,
                      hintText: 'Email',
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      controller: numberController,
                      hintText: 'Primary Number',
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      controller: alternateNumberController,
                      hintText: 'Alternate Number',
                    ),
                    Spacer(),
                    _isLoading
                        ? Center(child: CircularProgressIndicator(color: Color(0xff1671D8)))
                        : blueButton(text: "EDIT", onTap: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            await homeController.updateUserProfile(
                              name: nameController.text,
                              email: emailController.text,
                              primaryNumber: numberController.text,
                              alternateNumber: alternateNumberController.text,
                              profileImage: _image,
                            );
                            setState(() {
                              _isLoading = false;
                            });
                          }),
                  ],
                ),
              ),
            ),
          );
        }
      }),
    );
  }
}