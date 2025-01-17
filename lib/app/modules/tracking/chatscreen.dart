import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wrenchmate_user_app/app/controllers/cart_controller.dart';
import 'package:wrenchmate_user_app/app/controllers/chat_controller.dart';
import 'package:wrenchmate_user_app/app/controllers/service_controller.dart';
import 'package:wrenchmate_user_app/app/data/models/Service_firebase.dart';
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
  CartController cartController = Get.put(CartController());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String userID;
  String? serviceId;

  ServiceController sc = Get.put(ServiceController());

  @override
  void initState() {
    super.initState();
    userID = FirebaseAuth.instance.currentUser!.uid;
    final argument = Get.arguments;
    // if (argument != null && argument is String && argument.isNotEmpty) {
    //   controller.text = argument;
    // }

    if (argument != null &&
        argument is Map<String, dynamic> &&
        argument.isNotEmpty) {
      controller.text = argument['message'] ?? '';
      serviceId = argument['serviceId'];
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
      if (chatDoc.exists) {
        isAdminInChat = chatDoc.get('isAdminInChat') ?? false;
        hasUnreadMessages = chatDoc.get('hasUnreadMessages') ?? false;
      }

      if (!isAdminInChat) {
        cc.sendNotification(controller);
      }

      Map<String, dynamic> chatUpdate = {'hasUnreadMessages': false};

      if (!isAdminInChat && !hasUnreadMessages) {
        chatUpdate['hasUnreadMessages'] = true;
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
        'serviceId': serviceId ?? '',
        'text': controller.text,
        'isSentByMe': true,
        'timestamp': timestamp,
        'imageUrl': null, // Indicate this is a text message
        'isUploading': false
      });

      controller.clear();
    }
  }

  Future<void> _sendImage() async {
    await cc
        .sendImage(userID); // Calls the image sending logic in the controller
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
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                var messages = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index];
                    bool isSentByMe = message['isSentByMe'] ?? false;
                    bool isUploading = message['isUploading'] ?? false;
                    bool isQuotationMessage =
                        message.data() is Map<String, dynamic> &&
                            (message.data() as Map<String, dynamic>)
                                .containsKey('type') &&
                            (message.data() as Map<String, dynamic>)['type'] ==
                                'quotation';

                    return Align(
                      alignment: isSentByMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.all(12.0),
                        margin: EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 8.0),
                        decoration: BoxDecoration(
                          color:
                              isSentByMe ? Colors.blue[100] : Colors.grey[200],
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: isUploading
                            ? SizedBox(
                                width: 100,
                                height: 100,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.blue,
                                  ),
                                ),
                              )
                            : message['imageUrl'] != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: ExtendedImage.network(
                                      message['imageUrl'],
                                      width: 200,
                                      height: 200,
                                      fit: BoxFit.cover,
                                      cache: true,
                                    ),
                                  )
                                : isQuotationMessage
                                    ? _buildQuotationMessage(
                                        message['quotation_service_price'],
                                        isSentByMe)
                                    : Text(message['text'] ?? ''),
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
                IconButton(
                  icon: Icon(Icons.image, color: primaryColor),
                  onPressed: _sendImage,
                ),
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
                      hintText: 'Type your message...',
                      hintStyle: AppTextStyle.medium14,
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuotationMessage(
      Map<String, dynamic> quotationData, bool isSentByMe) {
    if (quotationData == null) return SizedBox.shrink();
    final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
        GlobalKey<ScaffoldMessengerState>();
    double price = quotationData['price'] ?? 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Service Quotation',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: isSentByMe ? Colors.blue : Colors.black,
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          'Price: \$${price.toStringAsFixed(2)}',
          style: TextStyle(fontSize: 14.0),
        ),
        SizedBox(height: 8.0),
        if (!isSentByMe) // Only show the button on the user's side
          ElevatedButton(
            onPressed: () async {
              Servicefirebase? service = await sc
                  .fetchServiceForChat(quotationData['serviceId'] ?? '');
              print(service);

              if (service != null) {
                // Update the service price with the quotation price
                service.price = quotationData['price'] ??
                    service.price; // Update price if available

                // Add the updated service to the cart
                await cartController.addToCartSnackbar(
                    context, cartController, service, scaffoldMessengerKey);
                Get.snackbar('Success', 'Service added to the cart');
              } else {
                Get.snackbar(
                    'Error', 'Failed to fetch service. Please try again.');
              }
            },
            child: Text(
              'Add to Cart',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
          ),
      ],
    );
  }
}
