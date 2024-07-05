import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wrenchmate_user_app/app/modules/home/widgits/offers_slider.dart';
import 'package:wrenchmate_user_app/app/modules/home/widgits/searchbar_filter.dart';
import 'package:wrenchmate_user_app/app/modules/home/widgits/services.dart';
import 'package:wrenchmate_user_app/app/modules/home/widgits/toprecommendedservices.dart';
import '../../controllers/home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();
    return Scaffold(
      appBar: AppBar(
        title: Row(
        children: [
          ClipOval(
            child: Image.asset(
              'assets/images/weekend.png',
              fit: BoxFit.cover,
              height: 45.0,
              width: 45.0,
            ),
          ),
          SizedBox(width: 10),
          Container(
            height: 45,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hi firstname",
                  style:
                  TextStyle(fontSize: 22, color: Colors.black),
                ),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined,size: 16,color: Color(0xffFF5402),),
                    Text("234, FTS Colony, HYD",
                        style: TextStyle(
                            fontSize: 16, color: Colors.black)),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
        actions: [
          //notification button
          Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Color(0xffE7E7E7), // Set the border color to grey
              width: 1.0, // Set the border width
            ),
          ),
          child: IconButton(
            icon: Icon(Icons.notifications_none_outlined,color: Color(0xff515151),),
            onPressed:(){},
          ),
        ),
          Container(width: 20,)
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(height: 12,),
            searchbar(),
            SizedBox(height: 12,),
            offersSliders(),
            serviceswidgit(),
            toprecommendedservices(),
          ],
        ),
      ),
    );
  }
}
