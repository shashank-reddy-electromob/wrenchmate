import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wrenchmate_user_app/app/modules/service/widgits/desc_faq_review.dart';
import 'package:wrenchmate_user_app/app/modules/service/widgits/elevatedbutton.dart';
import 'package:wrenchmate_user_app/app/modules/service/widgits/seperator.dart';
import 'package:wrenchmate_user_app/app/modules/service/widgits/servicecardiconswidget.dart';
import 'package:wrenchmate_user_app/app/widgets/custombackbutton.dart';
import '../../controllers/service_controller.dart';
import '../../data/models/Service_Firebase.dart';
import '../../data/models/user_module.dart';

class ServiceDetailPage extends StatefulWidget {
  @override
  State<ServiceDetailPage> createState() => _ServiceDetailPageState();
}

class _ServiceDetailPageState extends State<ServiceDetailPage> {
  String selectedTab = 'description';
  late List<bool> _isVisibleList;
  final ServiceController controller = Get.find();
  late ServiceFirebase service;

  @override
  void initState() {
    super.initState();
    service = Get.arguments;
    fetchData(service);
    _isVisibleList = List<bool>.filled(controller.faqs.length, false);
  }

  void fetchData(ServiceFirebase service) async {
    await controller.fetchReviewsForService(service);
    await controller.fetchFAQsForService(service.id);
    
    // Fetch user data for each review
    for (var review in controller.reviews) {
      await controller.fetchUser(review.userId);
    }

    _isVisibleList = List<bool>.filled(controller.faqs.length, false);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,
      leading: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Custombackbutton(),
      ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xffF6F6F5),
                borderRadius: BorderRadius.circular(30),
              ),
              child: IconButton(
                icon: Icon(
                  CupertinoIcons.suit_heart,
                  color: Color(0xff1E1E1E),
                  size: 22,
                ),
                onPressed: () {
                  //add to fav logic
                },
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                //service card
                Container(
                  height: MediaQuery.of(context).size.height*0.49,
                  child: Stack(
                      children:[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network("https://carfixo.in/wp-content/uploads/2022/05/car-wash-2.jpg",
                            fit: BoxFit.fitWidth,
                          )
                        ),
                        Positioned(
                          top: 200,
                            left: 20,
                            child: serviceCard()),
                  ]),
                ),
                // Tabs
                Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20,top: 8),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Color(0xffF6F6F5),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        descFaqReview(
                          text: 'Description',
                          isSelected: selectedTab == 'description',
                          onTap: () {
                            setState(() {
                              selectedTab = 'description';
                            });
                          },
                        ),
                        descFaqReview(
                          text: 'FAQs',
                          isSelected: selectedTab == 'faq',
                          onTap: () {
                            setState(() {
                              selectedTab = 'faq';
                            });
                          },
                        ),
                        descFaqReview(
                          text: 'Review',
                          isSelected: selectedTab == 'review',
                          onTap: () {
                            setState(() {
                              selectedTab = 'review';
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                // Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                    child: selectedTab == 'faq'
                        ? ExpandingListFAQs()
                        : selectedTab == 'description'
                         ? DescriptionWidget()
                        : selectedTab == 'review'
                        ? ReviewWidget()
                        : Container(),
                  ),
                ),
              ],
            ),
          );
        }
      }),
    );
  }

  Widget serviceCard(){
    return Container(
      width: MediaQuery.of(context).size.width*0.82,
      height: MediaQuery.of(context).size.height*0.23,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 15,
          ),
        ],
      ),
      child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("Service  ",style: TextStyle(fontSize: 16)),
                      Icon(CupertinoIcons.greaterthan,size: 12,),
                      Text('  ${service.name}',style: TextStyle(color: Color(0xff3778F2),fontSize: 16),)
                    ],
                  ),
                  SizedBox(height: 10,),
                  Text(service.name,style: TextStyle(color: Colors.black,fontSize: 22,fontWeight: FontWeight.w500),),
                  Text("₹ ${service.price}",style: TextStyle(color: Colors.black,fontSize: 22,fontWeight: FontWeight.w500),),
                  SizedBox(height: 10,),
                  MySeparator(),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DurationWidget(
                        icon: CupertinoIcons.clock,
                        titleText: "Duration:",
                        subtitleText: "Hours",
                        durationText: service.time,
                      ),
                      DurationWidget(
                        icon: CupertinoIcons.checkmark_shield,
                        titleText: "Warrnaty:",
                        durationText: service.warranty, subtitleText: '',
                      ),
                      DurationWidget(
                        icon: CupertinoIcons.star,
                        titleText: "Rating",
                        durationText: service.averageRating.toString(), subtitleText: '',
                      ),
                    ],
                  )
                ],
              ),
            ),
            //button
            Positioned(
                width: 80,
                top: MediaQuery.of(context).size.height * 0.055,
                right: MediaQuery.of(context).size.width * 0.04,
                child: CustomElevatedButton(onPressed: () {
                  showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return BottomSheet();
                  },
                ); },)
            ),
          ]
      ),
    );
  }

  Widget BottomSheet(){
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 6,
            margin: EdgeInsets.only(top: 8),
            width: 80,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          SizedBox(height: 18,),
          Text("Choose a Service Type",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 24),),
          SizedBox(height: 36,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Showroom Quality\n ₹ ${service.price}",style: TextStyle(color: Colors.black,fontSize: 22,fontWeight: FontWeight.w400),),
                    CustomElevatedButton(onPressed: (){}),
                  ],
                ),
                SizedBox(height: 18,),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Normal Quality\n ₹ ${service.price}",style: TextStyle(color: Colors.black,fontSize: 22,fontWeight: FontWeight.w400),),
                    CustomElevatedButton(onPressed: (){}),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget DescriptionWidget() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Color(0xffF6F6F5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Text(
          service.description,
          style: TextStyle(color: Color(0xff6D6D6D), fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget ExpandingListFAQs() {
    return ListView.builder(
      itemCount: controller.faqs.length,
      itemBuilder: (context, serviceIndex) {
        var faq = controller.faqs[serviceIndex];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                faq.question, // Use FAQ model
                style: TextStyle(
                    color: _isVisibleList[serviceIndex]
                        ? Color(0xff3778F2)
                        : Color(0xff7B7B7B),
                    fontSize: 16),
              ),
              trailing: _isVisibleList[serviceIndex]
                  ? Icon(Icons.arrow_drop_up, color: Color(0xff3778F2))
                  : Icon(Icons.arrow_drop_down, color: Color(0xff7B7B7B)),
              onTap: () {
                setState(() {
                  _isVisibleList[serviceIndex] = !_isVisibleList[serviceIndex];
                });
              },
              tileColor: Color(0xffF6F6F5),
            ),
            Visibility(
              visible: _isVisibleList[serviceIndex],
              child: Container(
                color: Color(0xffF6F6F5),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8),
                  child: Text(
                    faq.answer, // Use FAQ model
                    style: TextStyle(color: Color(0xff6D6D6D), fontSize: 14),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget ReviewWidget() {
    return ListView.builder(
      itemCount: controller.reviews.length,
      itemBuilder: (context, serviceIndex) {
        var review = controller.reviews[serviceIndex];
        var user = controller.users.firstWhere(
          (user) => user.userEmail == review.userId, // Updated to match userEmail
          orElse: () => User(
            userAddress: '',
            userEmail: 'Unknown',
            userName: '',
            userNumber: [],
            userProfileImage: '',
          ),
        );

        return Container(
          color: Color(0xffF6F6F5),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipOval(
                      child: user.userProfileImage.isNotEmpty
                          ? Image.network(
                              user.userProfileImage,
                              fit: BoxFit.cover,
                              height: 45.0,
                              width: 45.0,
                            )
                          : Icon(Icons.account_circle, size: 45.0),
                    ),
                    SizedBox(width: 16,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.userName.isNotEmpty ? user.userName : 'Unknown', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),),
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < review.rating
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.yellow,
                              size: 20,
                            );
                          }),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 10,),
                Text(review.message, style: TextStyle(color: Color(0xff575757), fontSize: 16),),
              ],
            ),
          ),
        );
      },
    );
  }
}