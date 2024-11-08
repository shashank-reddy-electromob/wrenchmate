// import 'package:flutter/material.dart';

// class BaseScreen extends StatelessWidget {
//   final Widget child;

//   BaseScreen({required this.child});

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: child,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SafeAreaGetMaterialApp extends GetMaterialApp {
  SafeAreaGetMaterialApp({
    Key? key,
    required Widget home,
    // other parameters
  }) : super(key: key, home: SafeArea(child: home));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: super.build(context),
    );
  }
}

