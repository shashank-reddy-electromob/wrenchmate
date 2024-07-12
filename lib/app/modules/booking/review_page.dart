import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wrenchmate_user_app/app/modules/booking/widgets/review%20widgets/deliveryReview.dart';
import 'package:wrenchmate_user_app/app/modules/booking/widgets/review%20widgets/serviceReview.dart';

import '../../data/models/service_model.dart';
import '../../widgets/blueButton.dart';

class reviewPage extends StatefulWidget {
  const reviewPage({super.key});

  @override
  State<reviewPage> createState() => _reviewPageState();
}

class _reviewPageState extends State<reviewPage> {
  final Service services = Get.arguments;


  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:  18.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [ SizedBox(
              height: 40,
            ),
              //appbar
              Row(
                children: [
                  //back button
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffF6F6F5),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: IconButton(
                      icon: Icon(
                        CupertinoIcons.back,
                        color: Color(0xff1E1E1E),
                        size: 22,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Text(
                    "Write a Review",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  )
                ],
              ),            SizedBox(height: 32,),

              serviceReview(),
            SizedBox(height: 32,),
              deliveryReview(),
              SizedBox(height: 32,),
              blueButton(text: 'SUBMIT REVIEW', onTap: (){
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return BottomSheet();
                  },
                ); },)
            ],
          ),
        ),
      ),
    );
  }
  Widget BottomSheet(){
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 32,),
          ClipOval(
            child: Image.asset(
              'assets/images/feedbackack.png',
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 16,),
          Text("Thanks for giving \nyour feedback ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 36),textAlign: TextAlign.center,),
          SizedBox(height: 8,),

          Text("Your feedback means a lot for us and \nhelp us to improve our services.",style: TextStyle(fontSize: 20),textAlign: TextAlign.center,),
          SizedBox(height: 16,),

          blueButton(text: "DONE", onTap:(){ Navigator.pop(context);} )
        ],
      ),

    );
  }
}
