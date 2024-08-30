import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wrenchmate_user_app/app/modules/product/productscreen.dart';
import 'package:wrenchmate_user_app/app/modules/tracking/chatscreen.dart';
import 'package:wrenchmate_user_app/app/modules/tracking/tracking_page.dart';
import 'app/bindings/initial_binding.dart';
import 'app/routes/app_pages.dart';
import 'firebase_options.dart';

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
      // home: TrackingPage(),
      initialRoute: FirebaseAuth.instance.currentUser == null
          ? AppPages.INITIAL
          : AppPages.BOTTOMNAV,
      getPages: AppPages.routes,
    );
  }
}
