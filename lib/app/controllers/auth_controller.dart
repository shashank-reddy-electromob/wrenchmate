import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:wrenchmate_user_app/app/localstorage/localstorage.dart';
import 'package:wrenchmate_user_app/main.dart';
import '../routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();
  var verificationid = ''.obs;
  int? resendToken;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  SharedPreferences? prefs;

  @override
  void onInit() {
    super.onInit();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

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
        Get.toNamed(AppRoutes.BOTTOMNAV, arguments: {
          'tracking_button': false,
        });
      }
    } catch (e) {
      print("Auto sign-in failed: $e");
      Get.snackbar("Error", "Auto sign-in failed: ${e.toString()}");
    }
  }

  // Future<bool> updateUserAddress(String address) async {
  //   try {
  //     String userId = FirebaseAuth.instance.currentUser!.uid;
  //     await _firestore.collection('User').doc(userId).update({
  //       'User_address': address,
  //     });
  //     print("User address updated");
  //     return true; // Indicate success
  //   } catch (e) {
  //     print("Failed to update address: $e");
  //     Get.snackbar("Error", "Failed to update address: ${e.toString()}");
  //     return false; // Indicate failure
  //   }
  // }

  Future<bool> updateUserAddress(String address) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userDoc =
          await _firestore.collection('User').doc(userId).get();

      List<dynamic> userAddressArray = userDoc['User_address'];
      int currentAddressIndex = userDoc['current_address'];

      userAddressArray[currentAddressIndex] = address;

      await _firestore.collection('User').doc(userId).update({
        'User_address': userAddressArray,
      });

      print("User address updated at index $currentAddressIndex");
      return true; // Indicate success
    } catch (e) {
      print("Failed to update address: $e");
      Get.snackbar("Error", "Failed to update address: ${e.toString()}");
      return false; // Indicate failure
    }
  }

  Future<bool> addAddressToList(String newAddress) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userDoc =
          await _firestore.collection('User').doc(userId).get();

      List<dynamic> userAddressArray = userDoc['User_address'] ?? [];
      int userAddressArrayLen = userAddressArray.length;
      userAddressArray.add(newAddress);

      await _firestore.collection('User').doc(userId).update({
        'User_address': userAddressArray,
        'current_address': userAddressArrayLen
      });

      print("New address added to the list");
      return true; // Indicate success
    } catch (e) {
      print("Failed to add address: $e");
      Get.snackbar("Error", "Failed to add address: ${e.toString()}");
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
      if (verificationid.value.isEmpty) {
        throw Exception("Verification ID is null or empty");
      }
      if (otp.isEmpty) {
        throw Exception("OTP is null or empty");
      }

      print("Verification ID: ${verificationid.value}");
      print("OTP: $otp");

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationid.value, smsCode: otp);
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;
      if (prefs == null) {
        throw Exception("Preferences object is null");
      }
      prefs?.setBool(LocalStorage.isLogin, true) ?? false;
      print(
          "prefs?.getBool(LocalStorage.isLogin) :: ${prefs?.getBool(LocalStorage.isLogin)}");

      if (user != null) {
        try {
          DocumentSnapshot userDoc = await _firestore
              .collection('User') 
              .doc(user.uid)
              .get();
          log(userDoc.id);
          if (!userDoc.exists) {
            Get.toNamed(AppRoutes.REGISTER, arguments: "");
          } else {
            Get.toNamed(AppRoutes.BOTTOMNAV, arguments: {
              'tracking_button': false,
            });
          }
        } catch (firestoreError) {
          Get.snackbar("Error",
              "Failed to verify user status: ${firestoreError.toString()}");
        }
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
      prefs?.setBool(LocalStorage.isLogin, true) ?? false;
      print(
          "prefs?.getBool(LocalStorage.isLogin) :: ${prefs?.getBool(LocalStorage.isLogin)}");
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

Future<void> signInWithApple() async {
  try {
    AppleAuthProvider appleProvider = AppleAuthProvider();
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithProvider(appleProvider);

    bool? isNewUser = userCredential.additionalUserInfo?.isNewUser;
    prefs?.setBool(LocalStorage.isLogin, true) ?? false;
    print(
        "prefs?.getBool(LocalStorage.isLogin) :: ${prefs?.getBool(LocalStorage.isLogin)}");

    if (isNewUser == true) {
      Get.toNamed(AppRoutes.REGISTER, arguments: "");
    } else {
      Get.toNamed(AppRoutes.BOTTOMNAV);
    }
    // if (user != null && isNewUser == true) {
    //   await _firestore.collection('User').doc(user.uid).set({
    //     'User_name': appleCredential.givenName ?? "",
    //     'User_email': appleCredential.email ?? "",
    //     'User_number': [], // Placeholder, if phone number is used later
    //     'User_address': [""],
    //     'current_address': 0,
    //     'User_carDetails': [],
    //     'User_currentCar': 0,
    //   });
    //   print("New Apple user added to Firestore");
    // }
  } catch (e) {
    print("Apple Sign-In failed: $e");
    Get.snackbar("Error", "Apple Sign-In failed: ${e.toString()}");
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
        'current_address': 0,
        'User_address': [""],
        if (profileImagePath != null && profileImagePath.isNotEmpty)
          'User_profile_image': profileImagePath,
        'User_carDetails': [],
        'User_currentCar': 0,
      });
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
      print("Attempting to log out...");
      if (FirebaseAuth.instance == null) {
        throw Exception("FirebaseAuth instance is null");
      }
      await FirebaseAuth.instance.signOut();
      print("Sign-out successful");

      if (AppRoutes.LOGIN == null) {
        throw Exception("AppRoutes.LOGIN is null");
      }
      Get.toNamed(AppRoutes.LOGIN);
    } catch (e) {
      print("Logout failed: $e");
      //Get.snackbar("Error", "Logout failed: ${e.toString()}");
    }
  }

  Future<void> updateCurrentAddress(int selectedAddressIndex) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      await _firestore.collection('User').doc(userId).update({
        'current_address': selectedAddressIndex,
      });
      print("Current address updated to index $selectedAddressIndex");
    } catch (e) {
      print("Failed to update current address: $e");
      Get.snackbar(
          "Error", "Failed to update current address: ${e.toString()}");
    }
  }
}
