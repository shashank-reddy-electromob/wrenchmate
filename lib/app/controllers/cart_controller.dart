import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wrenchmate_user_app/app/controllers/productcontroller.dart';
import 'package:wrenchmate_user_app/app/data/models/Service_firebase.dart';
import 'package:wrenchmate_user_app/app/data/models/product_model.dart';
import 'package:wrenchmate_user_app/app/routes/app_routes.dart';
import 'package:wrenchmate_user_app/utils/color.dart';
import 'service_controller.dart';

class CartController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ServiceController serviceController = Get.find();
  final ProductController productController = Get.put(ProductController());
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
      Set<String> uniqueProductIds = {};

      for (var item in cartItems) {
        if (item['serviceId'] != "NA") {
          uniqueServiceIds.add(item['serviceId']);
        }
        if (item['productId'] != "NA") {
          uniqueProductIds.add(item['productId']);
        }
      }

      for (var serviceId in uniqueServiceIds) {
        await serviceController.fetchServiceDataById(serviceId);
      }
      for (var productId in uniqueProductIds) {
        await productController.fetchProductById(productId);
      }
      // await fetchProductDetails(uniqueProductIds);

      await updateTotalCost();
    } catch (e) {
      print("Error fetching cart items: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateTotalCost() async {
    try {
      double subtotal = 0.0;

      for (var item in cartItems) {
        double price = (item['price'] ?? 0).toDouble(); // Handle null
        int quantity = (item['unitsquantity'] ?? 1); // Handle null

        subtotal += price * quantity;
      }

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

Future<void> addToCart({
  required String serviceId,
  required String productId,
  required String quantity,
  required double price,
}) async {
  try {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    if (productId != "NA") {
      // Check if the same productId with the same quantity already exists
      QuerySnapshot existingItems = await _firestore
          .collection('Cart')
          .where('userId', isEqualTo: userId)
          .where('productId', isEqualTo: productId)
          .where('productQuantity', isEqualTo: quantity) // Check for quantity as well
          .limit(1)
          .get();

      if (existingItems.docs.isNotEmpty) {
        // If the same product with the same quantity exists, update it
        DocumentSnapshot item = existingItems.docs.first;
        int currentUnitsQuantity = item.get('unitsquantity') ?? 1;
        await _firestore.collection('Cart').doc(item.id).update({
          'unitsquantity': currentUnitsQuantity + 1,
        });
      } else {
        // Add as a new entry if the product and quantity combination is unique
        await _firestore.collection('Cart').add({
          'serviceId': serviceId,
          'productId': productId,
          'userId': userId,
          'productQuantity': quantity,
          'price': price, // Correctly pass the price
          'unitsquantity': 1, // Default quantity
        });
      }
    } else {
      // Logic for adding services to the cart
      QuerySnapshot existingItems = await _firestore
          .collection('Cart')
          .where('userId', isEqualTo: userId)
          .where('serviceId', isEqualTo: serviceId)
          .where('productId', isEqualTo: "NA")
          .limit(1)
          .get();

      if (existingItems.docs.isEmpty) {
        await _firestore.collection('Cart').add({
          'serviceId': serviceId,
          'productId': "NA",
          'userId': userId,
          'productQuantity': quantity,
          'price': price,
        });
      }
    }

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

Future<void> deleteProductsFromCart(
    String productId, String productQuantity) async {
  try {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    
    QuerySnapshot snapshot = await _firestore
        .collection('Cart')
        .where('userId', isEqualTo: userId)
        .where('productId', isEqualTo: productId)
        .where('productQuantity', isEqualTo: productQuantity)
        .get();

    for (var doc in snapshot.docs) {
      int currentUnitsQuantity = doc['unitsquantity'];

      if (currentUnitsQuantity > 1) {
        await doc.reference.update({
          'unitsquantity': currentUnitsQuantity - 1,
        });
      } else {
        await doc.reference.delete();
      }
    }

    // Fetch the updated cart items after deletion
    await fetchCartItems();
  } catch (e) {
    print("Error deleting product from cart: $e");
  }
}

  void addToCartSnackbar(
    BuildContext context,
    CartController cartController,
    Servicefirebase service,
    GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey,
  ) async {
    print("adding to cart");

    double price = service.price;

    await cartController.addToCart(
      serviceId: service.id,
      productId: 'NA',
      quantity: 'NA',
      price: price,
    );

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

    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     key: ValueKey('cartSnackBar'),
    //     backgroundColor: primaryColor,
    //     content: snackBarContent,
    //     duration: Duration(days: 1),
    //   ),
    // );

    cartController.totalAmount.listen((newTotal) {
      if (!context.mounted) return;

      // ScaffoldMessenger.of(context).removeCurrentSnackBar();
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     key: ValueKey('cartSnackBar'),
      //     backgroundColor: primaryColor,
      //     content: Obx(() => Padding(
      //           padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children: [
      //               Expanded(
      //                 child: Text(
      //                   'Total Amount: \₹${newTotal.toStringAsFixed(2)}',
      //                   style: TextStyle(
      //                     color: Colors.white,
      //                     fontSize: 18,
      //                     fontWeight: FontWeight.bold,
      //                   ),
      //                 ),
      //               ),
      //               ElevatedButton(
      //                 onPressed: () {
      //                   Get.toNamed(AppRoutes.CART);
      //                   ScaffoldMessenger.of(context).hideCurrentSnackBar();
      //                 },
      //                 child: Text(
      //                   'Checkout',
      //                   style: TextStyle(
      //                     fontSize: 16,
      //                     color: primaryColor,
      //                     fontFamily: 'Raleway',
      //                   ),
      //                 ),
      //                 style: ElevatedButton.styleFrom(
      //                   backgroundColor: Colors.white,
      //                 ),
      //               ),
      //             ],
      //           ),
      //         )),
      //     duration: Duration(days: 1),
      //   ),
      // );
    });
  }

  void addProductToCartSnackbar(
    BuildContext context,
    CartController cartController,
    Product product,
    String productQuantity,
    GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey,
  ) async {
    print("product adding to cart");

    double totalPrice = product.getPriceForQuantity(productQuantity);

    await cartController.addToCart(
      serviceId: 'NA',
      productId: product.id,
      quantity: productQuantity,
      price: totalPrice,
    );

    print("product added to cart");

    double updatedAmount = cartController.totalAmount.value;

    if (!context.mounted) return;

    final snackBarContent = Obx(() => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Total Amount: ₹${updatedAmount.toStringAsFixed(2)}',
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
                        'Total Amount: ₹${newTotal.toStringAsFixed(2)}',
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
// bool isServiceInCart(Servicefirebase service) {
//   return cartItems.any((item) => item.id == service.id);
// }

  Future<bool> isServiceInCart(String serviceId) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Cart')
          .where('userId', isEqualTo: userId)
          .where('serviceId', isEqualTo: serviceId)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print("Error checking if service is in cart: $e");
      return false;
    }
  }

  RxString appliedCoupon = ''.obs;
  RxDouble discountAmount = 0.0.obs;

  void applyCoupon(String couponCode, double amount) {
    if (appliedCoupon.value.isNotEmpty) {
      totalAmount.value += discountAmount.value;
    }

    appliedCoupon.value = couponCode;
    if (couponCode != '') {
      discountAmount.value = amount;
      totalAmount.value -= discountAmount.value;
    } else {
      discountAmount.value = 0.0;
      Get.snackbar("Invalid Coupon", "The coupon code is not valid");
    }

    updateTotalWithDiscount();
  }

  void updateTotalWithDiscount() {
    totalAmount.value -= discountAmount.value;
    String userId = FirebaseAuth.instance.currentUser!.uid;

    _firestore.collection('User').doc(userId).update({
      'total_cost_cart': totalAmount.value,
    });

    Get.toNamed(AppRoutes.CART);
  }
}
