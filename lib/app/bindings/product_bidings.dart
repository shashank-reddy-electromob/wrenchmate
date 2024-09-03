import 'package:get/get.dart';
import 'package:wrenchmate_user_app/app/controllers/productcontroller.dart';

class ProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductController>(() => ProductController());
  }
}
