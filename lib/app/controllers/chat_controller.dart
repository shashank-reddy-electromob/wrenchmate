import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendNotification(TextEditingController controller) async {
    try {
      DocumentSnapshot userDoc = await _firestore
          .collection('Admin')
          .doc('7cBWtr3synaTWCwIOmVfqbtlXpx1')
          .get();
      if (userDoc.exists) {
        DocumentSnapshot adminSnapshot = await FirebaseFirestore.instance
            .collection('Admin')
            .doc('7cBWtr3synaTWCwIOmVfqbtlXpx1')
            .get();
        String? fcmToken = adminSnapshot['fcmToken'];

        if (fcmToken != null) {
          await sendFCMNotification(
              fcmToken, 'New message from a User', controller.text);
        }
        print("Notification sent to admin");
      } else {
        print("User document not found.");
      }
    } catch (e) {
      print('Error sending message or adding notification: $e');
    }
  }

  Future<Map<String, dynamic>> loadServiceAccountKey() async {
    final data =
        await rootBundle.loadString('assets/json/user-app-private-key.json');
    return json.decode(data);
  }

  Future<String> getAccessToken() async {
    final serviceAccountKey = await loadServiceAccountKey();

    final accountCredentials =
        ServiceAccountCredentials.fromJson(serviceAccountKey);

    const scopes = ['https://www.googleapis.com/auth/cloud-platform'];

    final authClient =
        await clientViaServiceAccount(accountCredentials, scopes);
    final accessToken = (await authClient.credentials.accessToken).data;

    return accessToken;
  }

  Future<void> sendFCMNotification(
      String fcmToken, String title, String body) async {
    try {
      String accessToken = await getAccessToken();
      var url = Uri.parse(
          'https://fcm.googleapis.com/v1/projects/user-app-6aaf1/messages:send');
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${accessToken}',
      };

      var data = {
        'message': {
          'token': fcmToken,
          'notification': {
            'title': title,
            'body': body,
          },
          'android': {
            'priority': 'high',
            'notification': {
              'channel_id': 'testing',
            },
          },
          'apns': {
            'headers': {
              'apns-priority': '10',
            },
            'payload': {
              'aps': {
                'alert': {
                  'title': title,
                  'body': body,
                },
                'sound': 'default',
              },
            },
          },
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'target_page': 'chat',
            'extra_info': 'someExtraData',
          },
        },
      };

      var response =
          await http.post(url, headers: headers, body: jsonEncode(data));
      if (response.statusCode == 200) {
        log('FCM Notification Sent');
      } else {
        log('Error sending FCM Notification: ${response.body}');
      }
    } catch (e) {
      log('Exception in FCM Notification: $e');
    }
  }
}
