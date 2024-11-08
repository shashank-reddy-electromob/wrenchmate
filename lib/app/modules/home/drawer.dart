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
  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Get.toNamed(AppRoutes.CAR);
    } else if (index == 1) {
      Get.toNamed(AppRoutes.SUBSCRIPTION);
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
                text: 'Your Subscription',
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
              Padding(
                padding: EdgeInsets.only(left: 30, top: 20),
                child: GestureDetector(
                  onTap: logout,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
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
                            fontSize: 16,
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
