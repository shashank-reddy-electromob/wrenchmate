import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();
  var verificationid = ''.obs;
  int? resendToken;

  void login(String phoneNumber) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            await FirebaseAuth.instance.signInWithCredential(credential);
            Get.toNamed(AppRoutes.BOTTOMNAV);
          } catch (e) {
            print("Auto sign-in failed: $e");
            Get.snackbar("Error", "Auto sign-in failed: ${e.toString()}");
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          print("Verification failed: ${e.message}");
          Get.snackbar("Error", e.message ?? "Verification failed");
        },
        codeSent: (String verificationId, int? resendtk) {
          print("OTP sent: $verificationId");
          Get.toNamed(AppRoutes.OTP);
          this.verificationid.value = verificationId;
          this.resendToken = resendToken;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          this.verificationid.value = verificationId;
        });
  }

  void resendOTP(String phoneNumber) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      forceResendingToken: resendToken,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto sign-in logic
        try {
          await FirebaseAuth.instance.signInWithCredential(credential);
          Get.toNamed(AppRoutes.BOTTOMNAV);
        } catch (e) {
          print("Auto sign-in failed: $e");
          Get.snackbar("Error", "Auto sign-in failed: ${e.toString()}");
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        // Handle verification failure
        print("Verification failed: ${e.message}");
        Get.snackbar("Error", e.message ?? "Verification failed");
      },
      codeSent: (String verificationId, int? resendToken) {
        // OTP sent successfully
        print("OTP resent: $verificationId");
        Get.toNamed(AppRoutes.OTP);
        this.verificationid.value = verificationId;
        this.resendToken = resendToken; // Update the resend token
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Handle timeout
        this.verificationid.value = verificationId;
      },
    );
  }

  void verifyOTP(otp) async {
    try {
      print(verificationid);
      PhoneAuthCredential credential = await PhoneAuthProvider.credential(
          verificationId: verificationid.toString(), smsCode: otp);
      await FirebaseAuth.instance.signInWithCredential(credential);
      Get.toNamed(AppRoutes.BOTTOMNAV);
    } catch (e) {
      print("OTP verification failed: $e");
      Get.snackbar("Error", "OTP verification failed: ${e.toString()}");
    }
  }

  void googleLogin() async {
    try {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithProvider(googleProvider);
      bool? isNewUser = userCredential.additionalUserInfo?.isNewUser;
      if (isNewUser == true) {
        Get.toNamed(AppRoutes.REGISTER);
      } else {
        Get.toNamed(AppRoutes.HOME);
      }
    } catch (e) {
      print("Google Sign-In failed: $e");
      Get.snackbar("Error", "Google Sign-In failed: ${e.toString()}");
    }
  }
}
