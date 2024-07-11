import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();
  var verificationid = ''.obs;
  int? resendToken;

  Future<void> _handleSignIn(PhoneAuthCredential credential) async {
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      bool isNewUser = FirebaseAuth.instance.currentUser!.metadata.creationTime ==
          FirebaseAuth.instance.currentUser!.metadata.lastSignInTime;
      if (isNewUser) {
        Get.toNamed(AppRoutes.REGISTER);
      } else {
        Get.toNamed(AppRoutes.BOTTOMNAV);
      }
    } catch (e) {
      print("Auto sign-in failed: $e");
      Get.snackbar("Error", "Auto sign-in failed: ${e.toString()}");
    }
  }

  void login(String phoneNumber) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: _handleSignIn,
      verificationFailed: (FirebaseAuthException e) {
        print("Verification failed: ${e.message}");
        Get.snackbar("Error", e.message ?? "Verification failed");
      },
      codeSent: (String verificationId, int? resendtk) {
        print("OTP sent: $verificationId");
        Get.toNamed(AppRoutes.OTP);
        this.verificationid.value = verificationId;
        this.resendToken = resendtk;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        this.verificationid.value = verificationId;
      },
    );
  }

  void resendOTP(String phoneNumber) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      forceResendingToken: resendToken,
      verificationCompleted: _handleSignIn,
      verificationFailed: (FirebaseAuthException e) {
        print("Verification failed: ${e.message}");
        Get.snackbar("Error", e.message ?? "Verification failed");
      },
      codeSent: (String verificationId, int? resendtk) {
        print("OTP resent: $verificationId");
        Get.toNamed(AppRoutes.OTP);
        this.verificationid.value = verificationId;
        this.resendToken = resendtk;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        this.verificationid.value = verificationId;
      },
    );
  }

  void verifyOTP(String otp) async {
    try {
      print(verificationid);
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationid.toString(), smsCode: otp);
      await FirebaseAuth.instance.signInWithCredential(credential);
      bool isNewUser = FirebaseAuth.instance.currentUser!.metadata.creationTime ==
          FirebaseAuth.instance.currentUser!.metadata.lastSignInTime;
      if (isNewUser) {
        Get.toNamed(AppRoutes.REGISTER);
      } else {
        Get.toNamed(AppRoutes.BOTTOMNAV);
      }
    } catch (e) {
      print("OTP verification failed: $e");
      Get.snackbar("Error", "OTP verification failed: ${e.toString()}");
    }
  }

  void googleLogin() async {
    try {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      UserCredential userCredential = await FirebaseAuth.instance.signInWithProvider(googleProvider);
      bool? isNewUser = userCredential.additionalUserInfo?.isNewUser;
      if (isNewUser == true) {
        Get.toNamed(AppRoutes.REGISTER);
      } else {
        Get.toNamed(AppRoutes.BOTTOMNAV);
      }
    } catch (e) {
      print("Google Sign-In failed: $e");
      Get.snackbar("Error", "Google Sign-In failed: ${e.toString()}");
    }
  }
}
