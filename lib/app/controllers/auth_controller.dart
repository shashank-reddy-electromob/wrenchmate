import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();
  var verificationid = ''.obs;
  int? resendToken;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> handleSignIn(PhoneAuthCredential credential,
      TextEditingController otpcontroller) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        verificationCompleted: (PhoneAuthCredential credential) {
          otpcontroller.text = credential.smsCode ?? '';
        },
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: (String verificationId, int? resendToken) {},
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      bool isNewUser =
          FirebaseAuth.instance.currentUser!.metadata.creationTime ==
              FirebaseAuth.instance.currentUser!.metadata.lastSignInTime;
      if (isNewUser) {
        Get.toNamed(AppRoutes.REGISTER, arguments: "");
      } else {
        Get.toNamed(AppRoutes.BOTTOMNAV);
      }
    } catch (e) {
      print("Auto sign-in failed: $e");
      Get.snackbar("Error", "Auto sign-in failed: ${e.toString()}");
    }
  }

  Future<bool> updateUserAddress(String address) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      await _firestore.collection('User').doc(userId).update({
        'User_address': address,
      });
      print("User address updated");
      return true; // Indicate success
    } catch (e) {
      print("Failed to update address: $e");
      Get.snackbar("Error", "Failed to update address: ${e.toString()}");
      return false; // Indicate failure
    }
  }

  void resendOTP(
      String phoneNumber, TextEditingController otpcontroller) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      forceResendingToken: resendToken,
      verificationCompleted: (PhoneAuthCredential credential) =>
          handleSignIn(credential, otpcontroller),
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

  Future<void> verifyOTP(String otp, String phoneNumber,
      TextEditingController otpcontroller) async {
    try {
      print(verificationid);
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationid.toString(), smsCode: otp);
      await FirebaseAuth.instance.signInWithCredential(credential);
      bool isNewUser =
          FirebaseAuth.instance.currentUser!.metadata.creationTime ==
              FirebaseAuth.instance.currentUser!.metadata.lastSignInTime;
      if (isNewUser) {
        Get.toNamed(AppRoutes.REGISTER, arguments: phoneNumber);
      } else {
        Get.toNamed(AppRoutes.BOTTOMNAV);
      }
    } catch (e) {
      print("OTP verification failed: $e");
      Get.snackbar("Error", "OTP verification failed: ${e.toString()}");
    }
  }

  Future<void> googleLogin() async {
    try {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithProvider(googleProvider);
      bool? isNewUser = userCredential.additionalUserInfo?.isNewUser;
      if (isNewUser == true) {
        Get.toNamed(AppRoutes.REGISTER, arguments: "");
      } else {
        Get.toNamed(AppRoutes.BOTTOMNAV);
      }
    } catch (e) {
      print("Google Sign-In failed: $e");
      Get.snackbar("Error", "Google Sign-In failed: ${e.toString()}");
      throw e;
    }
  }

  Future<void> addUserToFirestore({
    required String name,
    required String number,
    required String alternateNumber,
    required String email,
    String? address,
    String? profileImagePath,
  }) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      print(userId);
      await _firestore.collection('User').doc(userId).set({
        'User_name': name,
        'User_number': [number, alternateNumber],
        'User_email': email,
        if (address != null && address.isNotEmpty) 'User_address': address,
        if (profileImagePath != null && profileImagePath.isNotEmpty)
          'User_profile_image': profileImagePath,
        'User_carDetails': [],
      });
      await _firestore
          .collection('User')
          .doc(userId)
          .collection('SearchHistory')
          .add({
        'user search': [],
      });
      print("SearchHistory subcollection added to Firestore");
      print("User added to Firestore");
      Get.toNamed(AppRoutes.MAPSCREEN);
    } catch (e) {
      print("Failed to add user: $e");
      Get.snackbar("Error", "Failed to add user: ${e.toString()}");
    }
  }

  Future<List<dynamic>> getUserCarDetails() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userDoc =
        await _firestore.collection('User').doc(userId).get();
    return userDoc['User_carDetails'] ?? [];
  }

  void logout() async {
    try {
      print("logout in lauth controller");
      await FirebaseAuth.instance.signOut();
      Get.toNamed(AppRoutes.LOGIN);
    } catch (e) {
      print("Logout failed: $e");
      Get.snackbar("Error", "Logout failed: ${e.toString()}");
    }
  }
}
