import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wrenchmate_user_app/app/routes/app_routes.dart';
import 'package:wrenchmate_user_app/app/widgets/custombackbutton.dart';

class NotificationPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
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
            onTap: () async {
              var notifications = await _firestore
                  .collection('notifications')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('user_notifications')
                  .get();
              for (var doc in notifications.docs) {
                await doc.reference.delete();
              }
            },
            child: Text(
              "Mark all as read",
              style: TextStyle(
                  color: Color(0xff2E70E8),
                  fontSize: 12,
                  fontFamily: 'Poppins'),
            ),
          ),
          SizedBox(width: 20),
        ],
        backgroundColor: Colors.transparent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('notifications')
            .doc(FirebaseAuth
                .instance.currentUser!.uid)
            .collection('user_notifications')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          var notifications = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              var notification = notifications[index];
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            offset: Offset(0, 5),
                            spreadRadius: 3,
                            blurRadius: 5)
                      ]),
                  child: ListTile(
                    title: Text(
                      notification['title'],
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                    subtitle: Text(notification['description']),
                    onTap: () async {
                      Get.toNamed(AppRoutes.CHATSCREEN);

                      await _firestore
                          .collection('notifications')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('user_notifications')
                          .doc(notification.id)
                          .delete();
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
