import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wrenchmate_user_app/app/widgets/custombackbutton.dart';
import '../../controllers/home_controller.dart';
import '../../data/providers/notifications_provider.dart';

List readList = [];
List archiveList = [];

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Custombackbutton(),
        title: Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.w500, fontFamily: 'Raleway'),
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Text(
              "Mark all as read",
              style: TextStyle(
                  color: Color(0xff2E70E8),
                  fontSize: 12,
                  fontFamily: 'Poppins'),
            ),
          ),
          SizedBox(
            width: 20,
          )
        ],
        backgroundColor: Colors.transparent,
      ),
      body: ListView.builder(
        itemCount: dummyNotifications.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: ValueKey(dummyNotifications[index]),
            //left
            background: Container(
              color: Color(0xff039855),
              child: Column(
                children: [Icon(Icons.home), Text("home")],
              ),
            ),
            //right
            secondaryBackground: Container(color: Color(0xff1671D8)),
            onDismissed: (direction) {
              if (direction == DismissDirection.startToEnd) {
                readList
                    .add(dummyNotifications[index]);
              } else if (direction == DismissDirection.endToStart) {
                archiveList.add(
                    dummyNotifications[index]);
              }
            },
            child: Container(
              margin: EdgeInsets.all(4),
              width: double.infinity,
              height: 100,
              child: Row(
                children: [
                  // Icon based on category
                  Container(
                      width: MediaQuery.of(context).size.width * 0.15,
                      child: Icon(Icons.notifications)),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.82,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(dummyNotifications[index].title,
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  color: Color(0xff1E293B),
                                  fontWeight: FontWeight.w500)),
                          Expanded(
                            child: Text(
                              dummyNotifications[index].description,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  color: Color(0xff334155),
                                  fontWeight: FontWeight.w100),
                              softWrap:
                                  true, // Allow description to wrap to the next line
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
