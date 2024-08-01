import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var userData = {}.obs;
  var profileImageUrl = ''.obs;

  //display in edit page
  void fetchUserData() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      print("aryan is great"+userId);
      DocumentSnapshot userDoc = await _firestore.collection('User').doc(userId).get();
      if (userDoc.exists) {
        userData.value = userDoc.data() as Map<String, dynamic>;
        profileImageUrl.value = userData.value['profileImagePath'] ?? '';
        print("User data fetched successfully: ${userData.value}");
      } else {
        print("User not found");
        Get.snackbar("Error", "User not found");
      }
    } catch (e) {
      print("Failed to fetch user data: $e");
      Get.snackbar("Error", "Failed to fetch user data: ${e.toString()}");
    }
  }

  //updating is remaining
}