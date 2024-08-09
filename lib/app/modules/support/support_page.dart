import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wrenchmate_user_app/app/modules/support/widgets/socialmediatabs.dart';
import '../../controllers/support_controller.dart';
import '../booking/widgets/tabButton.dart';

class SupportPage extends StatefulWidget {
  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  String selectedTab='FAQ';
  @override
  Widget build(BuildContext context) {
    final SupportController controller = Get.find();
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Help and Support',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal:  18.0),
        child: Column(
          children: [
            //tabs
            Row(
              children: [
                // Current booking
                TabButton(
                  text: 'FAQ',
                  isSelected: selectedTab == 'FAQ',
                  onTap: () {
                    setState(() {
                      selectedTab = 'FAQ';
                    });
                  },
                ),
                SizedBox(width: 8),
                // History
                TabButton(
                  text: 'Contact Us',
                  isSelected: selectedTab == 'ContactUs',
                  onTap: () {
                    setState(() {
                      selectedTab = 'ContactUs';
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 8,),
            //ciontact us
            CustomContainer(imagePath: 'assets/socials/chatus.png', text: "Chat with Us", onTap: (){}),
            CustomContainer(imagePath: 'assets/socials/facebook.png', text: "Facebook", onTap: (){}),
            CustomContainer(imagePath: 'assets/socials/instagram.png', text: "Instagram", onTap: (){}),
            CustomContainer(imagePath: 'assets/socials/twt.png', text: "Twitter", onTap: (){}),

          ],
        ),
      )
    );
  }
}
