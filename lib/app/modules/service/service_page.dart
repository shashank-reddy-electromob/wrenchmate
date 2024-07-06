import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wrenchmate_user_app/app/modules/home/widgits/searchbar_filter.dart';
import 'package:wrenchmate_user_app/app/modules/service/widgits/subservice.dart';

class ServicePage extends StatefulWidget {
  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  @override
  Widget build(BuildContext context) {
    final String service = Get.arguments;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            service,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          leading: IconButton(
            icon: Icon(
              CupertinoIcons.back,
              color: Color(0xff1E1E1E),
              size: 22,
            ),
            onPressed: () {},
          ),
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    color: Color(0xffF7F7F7),
                    child: Center(
                      child: TextField(
                        cursorColor: Colors.grey,
                        decoration: InputDecoration(
                          hintText: "Search services and Packages",
                          hintStyle: TextStyle(
                            color: Color(0xff858585),
                            fontSize: 16,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Color(0xff838383),
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        style: TextStyle(
                          fontSize:
                              20, // Increase the font size for the entered text
                        ),
                      ),
                    ),
                  ),
                  //filter
                  CustomIconButton(
                    icon: Icon(
                      Icons.filter_list,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  subservices(),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.red),
                    child: Stack(
                      children: [ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              "assets/images/weekend.png",
                              fit: BoxFit.fitWidth,
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: MediaQuery.of(context).size.height * 0.17,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal:  8.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [Text("name of service",style: TextStyle(fontSize: 24),),
                                    ],
                                  ),
                                  SizedBox(height: 12,),
                                  Row(
                                    children: [Text("price and review",style: TextStyle(fontSize: 20),)],
                                  ),
                                  SizedBox(height: 8,),
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("time ",style: TextStyle(fontSize: 20),),
                                      Text("warranty",style: TextStyle(fontSize: 20),),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                        Positioned(
                          width: 80,
                            top: MediaQuery.of(context).size.height * 0.18,
                            left: MediaQuery.of(context).size.width * 0.66,
                            child: ElevatedButton(onPressed: (){}, child: Text('+add')))
                      ]
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

//mapping of the list according to the subservice remainnig
  Widget subservices() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SubService(
              imagePath: "assets/services/repair/show_all.png",
              text: "Show All",
            ),
            SubService(
              imagePath: "assets/services/repair/break_maintenance.png",
              text: "Breaks",
            ),
            SubService(
              imagePath: "assets/services/repair/ac.png",
              text: "AC",
            ),
            SubService(
              imagePath: "assets/services/repair/radiator.png",
              text: "Radiator",
            ),
            SubService(
              imagePath: "assets/services/repair/alternator.png",
              text: "Alternator",
            ),
            SubService(
              imagePath: "assets/services/repair/steering.png",
              text: "Steering",
            ),
            SubService(
              imagePath: "assets/services/repair/suspension.png",
              text: "Suspension",
            ),
          ],
        ),
      ),
    );
  }
}
