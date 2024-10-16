
import 'package:get/get.dart';
import '../controllers/bottomnav_controller.dart';

class bottomnavigationBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<bottomnavigationController>(() => bottomnavigationController());
  }
}
