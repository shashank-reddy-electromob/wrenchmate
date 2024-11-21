import 'dart:io';
import 'dart:math';

import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
// import 'package:location_app/ui/controller/home_controller.dart';
// import 'package:location_app/ui/location2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wrenchmate_user_app/app/routes/app_routes.dart';
// import '../ui/homepage.dart';

class NotificationServicesFCM {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationPlugin =
      FlutterLocalNotificationsPlugin();
  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('user granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('user granted provisional permission');
    } else {
      AppSettings.openAppSettings(type: AppSettingsType.notification);
      print('user denied permission');
    }
  }

  void initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    var darwinInitializationSettings = DarwinInitializationSettings();
    var initializationSetting = InitializationSettings(
        android: androidInitializationSettings,
        iOS: darwinInitializationSettings);
    await _flutterLocalNotificationPlugin.initialize(initializationSetting,
        onDidReceiveNotificationResponse: (payload) {
      handleMessage(context, message);
    });
  }

  void createNotificationChannel() {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'testing', // id
      'location channel', // title
      importance: Importance.high,
      playSound: true,
    );

    _flutterLocalNotificationPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  void FirebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      print('${message.notification!.title.toString()}');
      print('${message.notification!.body.toString()}');

      if (Platform.isAndroid) {
        initLocalNotifications(context, message);
        showNotification(message);
      }
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
        Random.secure().nextInt(100000).toString(),
        'High importance notification',
        importance: Importance.max);
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            channel.id.toString(), channel.name.toString(),
            channelDescription: 'Your channel description',
            importance: Importance.high,
            priority: Priority.high,
            ticker: 'ticker');

    final DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails);
    });
  }

  void handleMessage(BuildContext context, RemoteMessage message) async {
    if (message.data.containsKey('target_page')) {
      String targetPage = message.data['target_page'];

      if (targetPage == 'chat') {
        Get.toNamed(AppRoutes.CHATSCREEN);
      }
    }
  }

  void setUpInteractMessage(BuildContext context) async {
    //when app is terminated
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      handleMessage(context, initialMessage);
    }
    //when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleMessage(context, message);
    });
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    print('device token ${token}');
    if (token != null) {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      FirebaseFirestore.instance.collection('User').doc(userId).update({
        'fcmToken': token,
      });
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('deviceToken', token ?? '');
    return token!;
  }

  void isTokenRefreshed() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      await FirebaseFirestore.instance
          .collection('User')
          .doc(userId)
          .update({'fcmToken': newToken});
    });
  }
}
