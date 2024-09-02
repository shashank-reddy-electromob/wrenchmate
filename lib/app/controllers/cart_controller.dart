import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'service_controller.dart';

class CartController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ServiceController serviceController = Get.find();
  var isLoading = true.obs;
  var cartItems = <Map<String, dynamic>>[].obs;
  RxDouble totalAmount = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTotalCost();
  }

  Future<void> fetchTotalCost() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userDoc =
          await _firestore.collection('User').doc(userId).get();

      if (userDoc.exists) {
        // setS
        totalAmount.value = userDoc['total_cost_cart'] ?? 0.0;
      }
    } catch (e) {
      print("Error fetching total cost: $e");
    }
  }

  Future<void> addToCart({required String serviceId}) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      await _firestore.collection('Cart').add({
        'serviceId': serviceId,
        'userId': userId,
      });
      await fetchCartItems();
      await updateTotalCost();
    } catch (e) {
      print("Error adding to cart: $e");
    }
  }

  Future<void> fetchCartItems() async {
    try {
      isLoading.value = true;
      String userId = FirebaseAuth.instance.currentUser!.uid;
      QuerySnapshot snapshot = await _firestore
          .collection('Cart')
          .where('userId', isEqualTo: userId)
          .get();

      cartItems.value = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      Set<String> uniqueServiceIds = {};
      for (var item in cartItems) {
        uniqueServiceIds.add(item['serviceId']);
      }

      for (var serviceId in uniqueServiceIds) {
        await serviceController.fetchServiceDataById(serviceId);
      }

      await updateTotalCost();
    } catch (e) {
      print("Error fetching cart items: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteServicesFromCart(String deletedServiceId) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      QuerySnapshot snapshot = await _firestore
          .collection('Cart')
          .where('serviceId', isEqualTo: deletedServiceId)
          .where('userId', isEqualTo: userId)
          .get();

      for (var doc in snapshot.docs) {
        await _firestore.collection('Cart').doc(doc.id).delete();
      }
      // await fetchTotalCost();
      await fetchCartItems();
      await updateTotalCost();
    } catch (e) {
      print("Error deleting services from cart: $e");
    }
  }

  Future<void> updateTotalCost() async {
    double total = cartItems.fold<double>(0, (sum, item) {
      var service = serviceController.services.firstWhere(
        (s) => s.id == item['serviceId'],
        // orElse: () => null,
      );
      return sum + (service?.price ?? 0);
    });

    double tax = total * 0.1;
    double totalWithTax = total + tax;

    String userId = FirebaseAuth.instance.currentUser!.uid;
    await _firestore.collection('User').doc(userId).update({
      'total_cost_cart': totalWithTax,
    });

    totalAmount.value = totalWithTax;
  }
}
