import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wrenchmate_user_app/app/controllers/chat_controller.dart';
import 'package:wrenchmate_user_app/app/widgets/appbar.dart';
import 'package:wrenchmate_user_app/utils/color.dart';
import 'package:wrenchmate_user_app/utils/textstyles.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController controller = TextEditingController();
  ChatController cc = Get.put(ChatController());
  List<Map<String, dynamic>> messages = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String userID;

  @override
  void initState() {
    super.initState();
    userID = FirebaseAuth.instance.currentUser!.uid;
    final argument = Get.arguments;
    if (argument != null && argument is String && argument.isNotEmpty) {
      controller.text = argument;
    }
    _firestore.collection('chats').doc(userID).set({
      'isInChat': true,
      'lastActive': FieldValue.serverTimestamp(),
      'userId': userID,
      'isAdminInChat': false,
      'hasUnreadMessages': false,
    }, SetOptions(merge: true));
  }

  @override
  void dispose() {
    _firestore.collection('chats').doc(userID).update({
      'isInChat': false,
      'lastActive': FieldValue.serverTimestamp(),
    });
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (controller.text.isNotEmpty) {
      final timestamp = FieldValue.serverTimestamp();
      log(controller.text);

      DocumentSnapshot chatDoc =
          await _firestore.collection('chats').doc(userID).get();
      bool isAdminInChat = false;
      bool hasUnreadMessages = false;

      // Check if the document exists
      if (chatDoc.exists) {
        isAdminInChat = chatDoc.get('isAdminInChat') ?? false;
        hasUnreadMessages = chatDoc.get('hasUnreadMessages') ?? false;
      }

      Map<String, dynamic> chatUpdate = {
        'lastActive': timestamp,
        'userId': userID,
        'isInChat': true,
        'isAdminInChat': false,
        'hasUnreadMessages': false
      };
      if (!isAdminInChat && !hasUnreadMessages) {
        chatUpdate['hasUnreadMessages'] = true;
        cc.sendNotification(controller);
      }

      await _firestore
          .collection('chats')
          .doc(userID)
          .set(chatUpdate, SetOptions(merge: true));

      await _firestore
          .collection('chats')
          .doc(userID)
          .collection('messages')
          .add({
        'text': controller.text,
        'isSentByMe': true,
        'timestamp': timestamp,
      });

      controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Chat',
        onBackButtonPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('chats')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(
                    child: SizedBox(
                      width: 30.0,
                      height: 30.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                      ),
                    ),
                  );
                var messages = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index];
                    return Align(
                      alignment: message['isSentByMe']
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.all(12.0),
                        margin: EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 8.0),
                        decoration: BoxDecoration(
                          color: message['isSentByMe']
                              ? Colors.blue[100]
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Text(message['text']),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xffEBEBEB),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 20.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24.0),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Ask me anything..',
                      hintStyle: AppTextStyle.medium14,
                      prefixIcon: IconButton(
                        icon: Icon(Icons.add),
                        color: blackColor,
                        onPressed: () {},
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.mic),
                        color: blackColor,
                        onPressed: () {
                          // Voice input action
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primaryColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
