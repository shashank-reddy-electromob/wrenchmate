import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:wrenchmate_user_app/app/data/models/product_model.dart';
import 'package:wrenchmate_user_app/app/data/models/review_model.dart';
import 'package:wrenchmate_user_app/app/data/models/user_module.dart';

class ProductController extends GetxController {
  var products = <Product>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var reviews = <Review>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading(true);
      log('is loading is : ${isLoading.toString()}');
      final snapshot =
          await FirebaseFirestore.instance.collection('Product').get();

      final productList = snapshot.docs.map((doc) {
        print('Fetched Document: ${doc.data()}');
        return Product.fromDocument(doc.data(), doc.id);
      }).toList();

      products.assignAll(productList);
    } catch (e) {
      errorMessage.value = 'Failed to fetch products: $e';
      print("errorMessage.value :: ${errorMessage.value}");
    } finally {
      isLoading(false);
    }
  }

  var selectedProduct = Rxn<Product>();

  Future<void> fetchProductById(String productId) async {
    try {
      print("Fetching product data by ID: $productId");
      // isLoading(true);
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Product')
          .doc(productId)
          .get();

      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;
        print("Returned product data: $data");

        selectedProduct.value = Product(
          id: doc.id,
          description: data['description'] ?? '',
          price:
              (data['price'] is int) ? (data['price'] as int) : data['price'],
          productName: data['product_name'] ?? '',
          image: data['image'] ?? 'https://via.placeholder.com/150',
          quantitiesAvailable:
              List<String>.from(data['quantities_available'] ?? []),
          pricesAvailable: List<String>.from(data['prices_available'] ?? []),
          quantity: data['quantity'] ?? '',
          averageReview: (data['averageReview'] is int
              ? (data['averageReview'] as int).toDouble()
              : data['averageReview'] as double? ?? 0.0),
          numberOfReviews: data['numberofReviews'] ?? 0,
        );
        await fetchReviewsForProduct(selectedProduct.value!);
      } else {
        print("No product found with ID: $productId");
      }
    } catch (e) {
      print("Error fetching product by ID: $e");
    } finally {
      // isLoading(false);
    }
  }

  Future<void> fetchReviewsForProduct(Product product) async {
    try {
      QuerySnapshot reviewSnapshot = await FirebaseFirestore.instance
          .collection('Review')
          .where('productId', isEqualTo: product.id)
          .get();
      print(
          "Number of reviews fetched for service ${product.id}: ${reviewSnapshot.size}");

      List<String> userIds = [];

      for (var doc in reviewSnapshot.docs) {
        var reviewData = doc.data() as Map<String, dynamic>;
        print("Review Data for service ${product.id}: $reviewData");
        reviews.add(Review(
          productId: reviewData['productId'],
          serviceId: "NA",
          userId: reviewData['userId'],
          message: reviewData['message'],
          rating: (reviewData['rating'] is int)
              ? (reviewData['rating'] as int).toDouble()
              : reviewData['rating'] as double,
        ));
        userIds.add(reviewData['userId']);
      }

      await fetchUsers(userIds);
    } catch (e) {
      print("Error fetching reviews: $e");
    }
  }

  Future<void> fetchUsers(List<String> userIds) async {
    for (String userId in userIds) {
      await fetchUser(userId);
    }
  }

  var users = <User>[].obs;

  Future<void> fetchUser(String userId) async {
    try {
      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('User').doc(userId).get();

      if (userSnapshot.exists) {
        var userData = userSnapshot.data() as Map<String, dynamic>;
        print("User Data for user $userId: $userData");

        if (!users.any((user) => user.userEmail == userData['User_email'])) {
          users.add(User(
            userAddress: userData['User_address'] ?? '',
            userEmail: userData['User_email'] ?? '',
            userName: userData['User_name'] ?? '',
            userNumber: List<int>.from(userData['User_number'].map((num) {
              // Ensure each number is parsed correctly
              if (num is int) return num;
              return int.tryParse(num.toString()) ?? 0;
            })), // Convert to List<int>
            userProfileImage: userData['User_profile_image'] ?? '',
          ));
        }
      } else {
        print("User with ID $userId does not exist.");
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }
}
