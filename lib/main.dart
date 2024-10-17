import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wrenchmate_user_app/app/modules/cart/coupon.dart';
import 'package:wrenchmate_user_app/app/modules/cart/dummypayment.dart';
import 'package:wrenchmate_user_app/app/modules/payment/payment.dart';
import 'package:wrenchmate_user_app/app/modules/product/productscreen.dart';
import 'package:wrenchmate_user_app/app/modules/tracking/chatscreen.dart';
import 'package:wrenchmate_user_app/app/modules/tracking/tracking_page.dart';
import 'app/bindings/initial_binding.dart';
import 'app/routes/app_pages.dart';
import 'firebase_options.dart';

SharedPreferences? prefs;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(),
      //home: PhonePePayment(),
       initialRoute: FirebaseAuth.instance.currentUser == null
           ? AppPages.INITIAL
           : AppPages.BOTTOMNAV,
       getPages: AppPages.routes,
    );
  }
}
