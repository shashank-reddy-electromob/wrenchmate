import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:wrenchmate_user_app/app/data/models/product_model.dart';

class ProductController extends GetxController {
  var products = <Product>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading(true);
      final snapshot = await FirebaseFirestore.instance.collection('Product').get();

      final productList = snapshot.docs.map((doc) => Product.fromDocument(doc.data())).toList();

      products.assignAll(productList);
    } catch (e) {
      errorMessage.value = 'Failed to fetch products: $e';
    } finally {
      isLoading(false);
    }
  }
}
