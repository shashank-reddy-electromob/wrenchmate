import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wrenchmate_user_app/app/modules/home/widgits/drawer/tabs.dart';

import '../../routes/app_routes.dart';

class drawerPage extends StatefulWidget {
  const drawerPage({super.key});

  @override
  State<drawerPage> createState() => _drawerPageState();
}

class _drawerPageState extends State<drawerPage> {
  int? _selectedIndex;
  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index ==0){
      Get.toNamed(AppRoutes.CAR);
    }
    else if (index ==1){
      Get.toNamed(AppRoutes.SUBSCRIPTION);
    }
    else if (index ==2){
      Get.toNamed(AppRoutes.TERMSANDCONDITIONS);
    }
    else if (index ==3){
      Get.toNamed(AppRoutes.SUPPORT);
    }
    else if (index ==4){
      print("rate us");
    }
    else{}

  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white60,
    width: double.infinity,
    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30.0,top: 60),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/weekend.png',
                    fit: BoxFit.cover,
                    height: 85.0,
                    width: 85.0,
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                    //"Hi ${user.phoneNumber}",
                    "Firstname",
                    style: TextStyle(
                        fontSize: 22, color: Colors.black),
                  ),
                  IconButton(onPressed: (){}, icon: Icon(Icons.edit,color: Colors.green,size: 20,)),
                ],
              ),
              Text(
                //"Hi ${user.phoneNumber}",
                "9999999999",
                style: TextStyle(
                    fontSize: 16, color: Colors.grey),
              ),
              Text(
                //"Hi ${user.phoneNumber}",
                "email@string.com",
                style: TextStyle(
                    fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
        SizedBox(height: 30,),
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
          icon: Icons.contact_phone,
          text: 'Contact us',
        ),
        MenuTab(
          index: 4,
          selectedIndex: _selectedIndex,
          onTap: _onTabTapped,
          icon: Icons.star,
          text: 'Rate us',
        ),
        Padding(padding: EdgeInsets.only(left: 30,top: 60),
          child: GestureDetector(
          onTap: (){},
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            width: MediaQuery.of(context).size.width * 0.24,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [Color(0xff3576EE),Color(0xff3C80FF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.logout_rounded,color: Colors.white,size: 18,),
                Text(
                  textAlign: TextAlign.center,
                  " Log out",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color:Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),)
      ],
    ),);
  }
}