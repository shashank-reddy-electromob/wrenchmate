import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/home_controller.dart';
import '../controllers/service_controller.dart';
import '../controllers/subscription_controller.dart';
import '../controllers/cart_controller.dart';
import '../controllers/booking_controller.dart';
import '../controllers/car_controller.dart';
import '../controllers/support_controller.dart';
import '../controllers/tracking_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<ServiceController>(() => ServiceController());
    Get.lazyPut<SubscriptionController>(() => SubscriptionController());
    Get.lazyPut<CartController>(() => CartController());
    Get.lazyPut<BookingController>(() => BookingController());
    Get.lazyPut<CarController>(() => CarController());
    Get.lazyPut<SupportController>(() => SupportController());
    Get.lazyPut<TrackingController>(() => TrackingController());
  }
}
