import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wrenchmate_user_app/app/Map%20screens/MapScreen.dart';
import 'package:wrenchmate_user_app/app/modules/payment/payment.dart';
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
      home: PaymentScreen(),
      // initialRoute: FirebaseAuth.instance.currentUser == null ? AppPages.INITIAL : AppPages.CAR_REGISTER,
      getPages: AppPages.routes,
    );
  }
}
