import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wrenchmate_user_app/app/modules/home/widgits/searchbar_filter.dart';
import 'package:wrenchmate_user_app/app/modules/service/widgits/subservice.dart';

import '../../data/providers/service_provider.dart';

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
            SizedBox(height: 8,),
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
            SizedBox(height: 8,),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    subservices(),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: services.length,
                      itemBuilder: (context, index) {
                        final service = services[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Color(0xffF7F7F7)),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        service.imagePath,
                                        fit: BoxFit.fitWidth,
                                        width: MediaQuery.of(context).size.width-32,
                                        height: MediaQuery.of(context).size.height * 0.17,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  service.name,
                                                  style: TextStyle(fontSize: 24,fontWeight: FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8  ),
                                            Row(
                                              children: [
                                                Text(
                                                  '\₹${service.price}  ',
                                                  style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),
                                                ),
                                                Icon(CupertinoIcons.star,size: 16,color: Color(0xffFFE262),),
                                                Text(
                                                  ' ${service.averageRating.toStringAsFixed(1)}',
                                                  style: TextStyle(fontSize: 20, color: Color(0xff636363)),
                                                ),
                                                Text(
                                                  ' (${service.numberOfReviews} reviews)',
                                                  style: TextStyle(fontSize: 18,color: Color(0xff858585)),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8),
                                            //TIME AND WARRANTY
                                            Row (
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                //TIME
                                                Row(
                                                  children: [
                                                    Icon(CupertinoIcons.clock,size: 16,color: Color(0xff797979),),
                                                    Text(
                                                      ' Takes ${service.time} Hours',
                                                      style: TextStyle(fontSize: 16,color: Color(0xff797979),),
                                                    ),
                                                  ],
                                                ),
                                                //WARRANTY
                                                Row(
                                                  children: [
                                                    Icon(CupertinoIcons.checkmark_shield,size: 18,color: Color(0xff797979),),
                                                    Text(
                                                      ' ${service.warrantyDuration} Warranty',
                                                      style: TextStyle(fontSize: 16,color: Color(0xff797979),),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //add button
                                Positioned(
                                  width: 80,
                                  top: MediaQuery.of(context).size.height * 0.18,
                                  right: MediaQuery.of(context).size.width * 0.04,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xff3778F2), // Background color
                                      foregroundColor: Colors.white,
                                      elevation: 0
                                    ),
                                    onPressed: () {},
                                    child: Text('+Add',style: TextStyle(fontSize: 14),),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
    );
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
