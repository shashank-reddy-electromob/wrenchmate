import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wrenchmate_user_app/app/widgets/blueButton.dart';
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
  final TextEditingController alternateNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final HomeController homeController = Get.put(HomeController());

  File? _image;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<Map<String, dynamic>> _fetchUserData() async {
    Map<String, dynamic> data = await homeController.fetchUserData() as Map<String, dynamic>;

    // Populate the controllers with fetched data
    nameController.text = data['User_name'] ?? '';
    numberController.text = data['User_number'][0] ?? '';
    alternateNumberController.text = data['User_number'][1] ?? '';
    emailController.text = data['User_email'] ?? '';

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('User Profile'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching user data'));
          } else {
            return SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - 100,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: ClipOval(
                            child: _image != null
                                ? Image.file(
                              _image!,
                              fit: BoxFit.cover,
                              height: 95.0,
                              width: 95.0,
                            )
                                : Image.network(
                              snapshot.data?['User_profile_image'],
                              fit: BoxFit.cover,
                              height: 95.0,
                              width: 95.0,
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
        },
      ),
    );
  }
}
