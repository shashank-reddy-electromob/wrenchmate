import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wrenchmate_user_app/app/widgets/blueButton.dart';
import '../../controllers/home_controller.dart';
import '../auth/widgets/CustomTextField.dart';

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

  @override
  void initState() {
    super.initState();
    homeController.fetchUserData();
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
          nameController.text = homeController.userData['User_name'] ?? '';
          numberController.text = homeController.userData['User_number'][0] ?? '';
          alternateNumberController.text = homeController.userData['User_number'][1] ?? '';
          emailController.text = homeController.userData['User_email'] ?? '';
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(homeController.userData['User_profile_image'] ?? 'assets/images/person.png'),
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
                blueButton(text: "EDIT", onTap: () {
                //update user data
                }),
              ],
            ),
          );
        }
      }),
    );
  }
}
