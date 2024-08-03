import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'service_controller.dart'; // Import the ServiceController

class CartController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ServiceController serviceController = Get.find();
  var isLoading = true.obs; // Loading state
  var cartItems = <Map<String, dynamic>>[].obs;

  Future<void> addToCart({required String serviceId}) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      await _firestore.collection('Cart').add({
        'serviceId': serviceId,
        'userId': userId,
      });
    } catch (e) {
      print("Error adding to cart: $e");
    }
  }

  Future<void> fetchCartItems() async {
    try {
      isLoading.value = true;
      String userId = FirebaseAuth.instance.currentUser!.uid;
      QuerySnapshot snapshot = await _firestore.collection('Cart')
          .where('userId', isEqualTo: userId)
          .get();
      
      cartItems.value = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      
      print("Cart Items: $cartItems");

      Set<String> uniqueServiceIds = {};
      for (var item in cartItems) {
        uniqueServiceIds.add(item['serviceId']);
      }

      for (var serviceId in uniqueServiceIds) {
        await serviceController.fetchServiceDataById(serviceId);
      }
    } catch (e) {
      print("Error fetching cart items: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteServicesFromCart(String deletedServiceId) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

        QuerySnapshot snapshot = await _firestore.collection('Cart')
            .where('serviceId', isEqualTo: deletedServiceId)
            .where('userId', isEqualTo: userId)
            .get();

        for (var doc in snapshot.docs) {
          await _firestore.collection('Cart').doc(doc.id).delete();
        }

    } catch (e) {
      print("Error deleting services from cart: $e");
    }
  }
}