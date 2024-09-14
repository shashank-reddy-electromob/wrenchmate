import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wrenchmate_user_app/app/widgets/appbar.dart';
import 'package:wrenchmate_user_app/app/widgets/blueButton.dart';
import 'package:wrenchmate_user_app/utils/color.dart';
import '../../controllers/home_controller.dart';
import '../auth/widgets/CustomTextField.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfile extends StatefulWidget {
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController alternateNumberController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final HomeController homeController = Get.put(HomeController());

  File? _image;
  bool _isLoading = false;

  Map<String, dynamic>? originalUserData;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<Map<String, dynamic>> _fetchUserData() async {
    Map<String, dynamic>? data =
        await homeController.fetchUserData() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception('Failed to fetch user data');
    }

    // Populate the controllers with fetched data and store original data
    nameController.text = data['User_name'] ?? '';
    numberController.text = data['User_number'][0] ?? '';
    alternateNumberController.text = data['User_number'][1] ?? '';
    emailController.text = data['User_email'] ?? '';

    originalUserData = Map<String, dynamic>.from(data);

    return data;
  }

  Future<void> _updateUserProfile() async {
    Map<String, dynamic> updatedData = {};

    if (nameController.text != originalUserData?['User_name']) {
      updatedData['User_name'] = nameController.text;
    }
    if (emailController.text != originalUserData?['User_email']) {
      updatedData['User_email'] = emailController.text;
    }
    if (numberController.text != originalUserData?['User_number'][0]) {
      updatedData['User_number'] = [
        numberController.text,
        alternateNumberController.text
      ];
    }
    if (alternateNumberController.text != originalUserData?['User_number'][1]) {
      updatedData['User_number'] = [
        numberController.text,
        alternateNumberController.text
      ];
    }

    if (_image != null) {
      String originalImagePath = originalUserData?['User_profile_image'] ?? '';
      if (_image!.path != originalImagePath) {
        updatedData['User_profile_image'] = _image;
      }
    }

    if (updatedData.isNotEmpty) {
      await homeController.updateUserProfile(updatedData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Profile',
        onBackButtonPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching user data'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No user data found'));
          } else {
            String userProfileImage =
                snapshot.data?['User_profile_image'] ?? '';
            String userName = snapshot.data?['User_name'] ?? '';
            String userEmail = snapshot.data?['User_email'] ?? '';
            String primaryNumber = snapshot.data?['User_number'] != null &&
                    snapshot.data!['User_number'].isNotEmpty
                ? snapshot.data!['User_number'][0] ?? ''
                : '';
            String alternateNumber = snapshot.data?['User_number'] != null &&
                    snapshot.data!['User_number'].length > 1
                ? snapshot.data!['User_number'][1] ?? ''
                : '';

            return SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - 100,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: _pickImage,
                              child: Container(
                                width: 105.0,
                                height: 105.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Color(0xff515151),
                                    width: 3.0,
                                  ),
                                ),
                                child: ClipOval(
                                  child: _image != null
                                      ? Image.file(
                                          _image!,
                                          fit: BoxFit.cover,
                                          height: 95.0,
                                          width: 95.0,
                                        )
                                      : (userProfileImage.isNotEmpty
                                          ? Image.network(
                                              userProfileImage,
                                              fit: BoxFit.cover,
                                              height: 95.0,
                                              width: 95.0,
                                            )
                                          : Icon(
                                              Icons.person,
                                              size: 95.0,
                                            )),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: _pickImage,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Color(0xff515151),
                                      width: 1.0,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 16,
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: primaryColor,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      CustomTextField(
                        controller: nameController..text = userName,
                        hintText: 'Name',
                      ),
                      SizedBox(height: 10),
                      CustomTextField(
                        controller: emailController..text = userEmail,
                        hintText: 'Email',
                      ),
                      SizedBox(height: 10),
                      CustomTextField(
                        controller: numberController..text = primaryNumber,
                        hintText: 'Primary Number',
                      ),
                      SizedBox(height: 10),
                      CustomTextField(
                        controller: alternateNumberController
                          ..text = alternateNumber,
                        hintText: 'Alternate Number',
                      ),
                      Spacer(),
                      _isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                  color: Color(0xff1671D8)),
                            )
                          : blueButton(
                              text: "EDIT",
                              buttonHeight: 12,
                              onTap: () async {
                                setState(() {
                                  _isLoading = true;
                                });
                                await _updateUserProfile();
                                setState(() {
                                  _isLoading = false;
                                });
                              },
                            ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
