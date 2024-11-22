import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wrenchmate_user_app/app/controllers/home_controller.dart';
import 'package:wrenchmate_user_app/app/localstorage/localstorage.dart';
import 'package:wrenchmate_user_app/app/modules/home/widgits/drawer/tabs.dart';
import 'package:wrenchmate_user_app/main.dart';
import '../../controllers/auth_controller.dart';
import '../../routes/app_routes.dart';

class drawerPage extends StatefulWidget {
  final String userProfileImage;
  final String userName;
  final String userNumber;
  final String userEmail;

  const drawerPage({
    Key? key,
    required this.userProfileImage,
    required this.userName,
    required this.userNumber,
    required this.userEmail,
  }) : super(key: key);

  @override
  State<drawerPage> createState() => _drawerPageState();
}

class _drawerPageState extends State<drawerPage> {
  int? _selectedIndex;

  void _deleteAccount() async {
    try {
      bool? confirmDelete = await Get.defaultDialog<bool>(
        title: "Delete Account",
        titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        content: Center(
            child: const Text(
          "Are you sure you want to delete your account?",
          textAlign: TextAlign.center,
        )),
        confirm: ElevatedButton(
          child: const Text("Yes"),
          onPressed: () => Get.back(result: true),
        ),
        cancel: ElevatedButton(
          child: const Text("No"),
          onPressed: () => Get.back(result: false),
        ),
      );

      if (confirmDelete == true) {
        final User? currentUser = FirebaseAuth.instance.currentUser;

        if (currentUser != null) {
          try {
            // Delete user document from Firestore
            await FirebaseFirestore.instance
                .collection('User')
                .doc(currentUser.uid)
                .delete();

            // Attempt to delete the Firebase Authentication user
            await currentUser.delete();

            // Navigate to login page
            prefs?.setBool(LocalStorage.isLogin, false) ?? false;
            Get.toNamed(AppRoutes.LOGIN);

            Get.snackbar("Success", "Account deleted successfully.");
          } on FirebaseAuthException catch (e) {
            if (e.code == 'requires-recent-login') {
              _handleReauthentication(currentUser);
            } else {
              throw e; // Rethrow unexpected errors
            }
          }
        } else {
          Get.snackbar("Error", "No user is currently logged in.");
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Account deletion failed: ${e.toString()}");
    }
  }

  void _handleReauthentication(User currentUser) {
    // Identify the sign-in provider
    String provider = currentUser.providerData.first.providerId;

    String message;
    if (provider == 'google.com') {
      message = "Please sign in with Google again to confirm account deletion.";
    } else if (provider == 'apple.com') {
      message = "Please sign in with Apple again to confirm account deletion.";
    } else if (provider == 'phone') {
      message =
          "Please sign in with your phone number again to confirm account deletion.";
    } else {
      message = "Please log in again to confirm account deletion.";
    }

    // Show a toast or snackbar with the message
    Get.snackbar("Re-authentication Required", message,
        snackPosition: SnackPosition.BOTTOM, duration: Duration(seconds: 5));

    // Redirect to login page for re-authentication
    prefs?.setBool(LocalStorage.isLogin, false) ?? false;
    Get.toNamed(AppRoutes.LOGIN);
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Get.toNamed(AppRoutes.CAR);
    } else if (index == 1) {
      Get.toNamed(AppRoutes.BOOKING);
    } else if (index == 2) {
      Get.toNamed(AppRoutes.TERMSANDCONDITIONS);
    } else if (index == 3) {
      Get.toNamed(AppRoutes.REFUNDPOLICY);
    } else if (index == 4) {
      Get.toNamed(AppRoutes.PRIVACYPOLICY);
    } else if (index == 5) {
      Get.toNamed(AppRoutes.SUPPORT);
    } else if (index == 6) {
      print("rate us");
    } else if (index == 7) {
      _deleteAccount();
    } else {}
  }

  void logout() async {
    try {
      final AuthController controller = Get.find();
      controller.logout();
      prefs?.setBool(LocalStorage.isLogin, false) ?? false;

      Get.toNamed(AppRoutes.LOGIN);
    } catch (e) {
      Get.snackbar("Error", "Logout failed: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          color: Colors.white,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 60),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: ClipOval(
                        child: (widget.userProfileImage.isNotEmpty)
                            ? Image.network(
                                widget.userProfileImage,
                                fit: BoxFit.cover,
                                height: 85.0,
                                width: 85.0,
                              )
                            : Image.asset("assets/images/person.png"),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          widget.userName,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: 'Raleway'),
                        ),
                        IconButton(
                            onPressed: () {
                              Get.toNamed(AppRoutes.EDITPROFILE);
                            },
                            icon: Icon(
                              Icons.edit,
                              color: Colors.green,
                              size: 20,
                            )),
                      ],
                    ),
                    Text(
                      widget.userNumber,
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontFamily: 'Poppins'),
                    ),
                    Text(
                      widget.userEmail,
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontFamily: 'Poppins'),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              MenuTab(
                index: 0,
                selectedIndex: _selectedIndex,
                onTap: _onTabTapped,
                icon: Icons.description,
                text: 'Car Documents',
              ),
              MenuTab(
                index: 1,
                selectedIndex: _selectedIndex,
                onTap: _onTabTapped,
                icon: Icons.subscriptions,
                text: 'Bookings',
              ),
              MenuTab(
                index: 2,
                selectedIndex: _selectedIndex,
                onTap: _onTabTapped,
                icon: Icons.article,
                text: 'Terms & Conditions',
              ),
              MenuTab(
                index: 3,
                selectedIndex: _selectedIndex,
                onTap: _onTabTapped,
                icon: Icons.article,
                text: 'Refund Policy',
              ),
              MenuTab(
                index: 4,
                selectedIndex: _selectedIndex,
                onTap: _onTabTapped,
                icon: Icons.article,
                text: 'Privacy Policy',
              ),
              MenuTab(
                index: 5,
                selectedIndex: _selectedIndex,
                onTap: _onTabTapped,
                icon: Icons.contact_phone,
                text: 'Contact us',
              ),
              MenuTab(
                index: 6,
                selectedIndex: _selectedIndex,
                onTap: _onTabTapped,
                icon: Icons.star,
                text: 'Rate us',
              ),
              MenuTab(
                index: 7,
                selectedIndex: _selectedIndex,
                onTap: _onTabTapped,
                icon: Icons.no_accounts_outlined,
                text: 'Delete Account',
              ),
              Padding(
                padding: EdgeInsets.only(left: 30, top: 20),
                child: GestureDetector(
                  onTap: logout,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    width: MediaQuery.of(context).size.width * 0.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [Color(0xff3576EE), Color(0xff3C80FF)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.logout_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        Text(
                          textAlign: TextAlign.center,
                          " Log out",
                          style: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
