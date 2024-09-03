import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wrenchmate_user_app/app/data/models/Service_firebase.dart';
import 'package:wrenchmate_user_app/app/routes/app_routes.dart';
import 'package:wrenchmate_user_app/utils/color.dart';
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
    fetchCartItems();
  }

  Future<void> fetchTotalCost() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userDoc =
          await _firestore.collection('User').doc(userId).get();

      if (userDoc.exists) {
        totalAmount.value = (userDoc['total_cost_cart'] ?? 0.0).toDouble();
      }
    } catch (e) {
      print("Error fetching total cost: $e");
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

  Future<void> updateTotalCost() async {
    try {
      double subtotal = cartItems.fold(0.0, (sum, item) {
        var service = serviceController.services
            .firstWhere((s) => s.id == item['serviceId']);
        return sum + (service?.price?.toDouble() ?? 0.0);
      });

      double tax = subtotal * 0.10;

      double totalWithTax = subtotal + tax;

      totalAmount.value = totalWithTax;

      String userId = FirebaseAuth.instance.currentUser!.uid;
      await _firestore.collection('User').doc(userId).update({
        'total_cost_cart': totalAmount.value,
      });
    } catch (e) {
      print("Error updating total cost: $e");
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

  Future<void> deleteServicesFromCart(String serviceId) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      QuerySnapshot snapshot = await _firestore
          .collection('Cart')
          .where('userId', isEqualTo: userId)
          .where('serviceId', isEqualTo: serviceId)
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      await fetchCartItems();
    } catch (e) {
      print("Error deleting service from cart: $e");
    }
  }

  void addToCartSnackbar(
    BuildContext context,
    CartController cartController,
    Servicefirebase service,
    GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey,
  ) async {
    print("adding to cart");

    await cartController.addToCart(serviceId: service.id);

    print("added to cart");

    double updatedAmount = cartController.totalAmount.value;

    if (!context.mounted) return;

    final snackBarContent = Obx(() => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Total Amount: \₹${updatedAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.CART);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
                child: Text(
                  'Checkout',
                  style: TextStyle(
                    fontSize: 16,
                    color: primaryColor,
                    fontFamily: 'Raleway',
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ));

    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        key: ValueKey('cartSnackBar'),
        backgroundColor: primaryColor,
        content: snackBarContent,
        duration: Duration(days: 1),
      ),
    );

    cartController.totalAmount.listen((newTotal) {
      if (!context.mounted) return;

      scaffoldMessengerKey.currentState?.removeCurrentSnackBar();
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          key: ValueKey('cartSnackBar'),
          backgroundColor: primaryColor,
          content: Obx(() => Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Total Amount: \₹${newTotal.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.CART);
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      },
                      child: Text(
                        'Checkout',
                        style: TextStyle(
                          fontSize: 16,
                          color: primaryColor,
                          fontFamily: 'Raleway',
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              )),
          duration: Duration(days: 1),
        ),
      );
    });
  }
}
