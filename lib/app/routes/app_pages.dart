import 'package:get/get.dart';
import 'package:wrenchmate_user_app/app/bindings/product_bidings.dart';
import 'package:wrenchmate_user_app/app/modules/auth/car_deetail.dart';
import 'package:wrenchmate_user_app/app/modules/auth/car_register.dart';
import 'package:wrenchmate_user_app/app/modules/bottomnavigation/bottomnavigation.dart';
import 'package:wrenchmate_user_app/app/modules/home/filterdatascreen.dart';
import 'package:wrenchmate_user_app/app/modules/home/searchscreen.dart';
import 'package:wrenchmate_user_app/app/modules/product/product_details.dart';
import 'package:wrenchmate_user_app/app/modules/tracking/chatscreen.dart';
import '../modules/auth/MapScreen.dart';
import '../bindings/auth_binding.dart';
import '../bindings/bottomnav_bindings.dart';
import '../bindings/home_binding.dart';
import '../bindings/service_binding.dart';
import '../bindings/subscription_binding.dart';
import '../bindings/cart_binding.dart';
import '../bindings/booking_binding.dart';
import '../bindings/car_binding.dart';
import '../bindings/support_binding.dart';
import '../bindings/tracking_binding.dart';
import '../modules/auth/login_page.dart';
import '../modules/auth/otp_page.dart';
import '../modules/auth/register_page.dart';
import '../modules/booking/review_page.dart';
import '../modules/home/editProfile.dart';
import '../modules/home/notification_page.dart';
import '../modules/home/termsAndConditions.dart';
import '../modules/service/service_page.dart';
import '../modules/service/service_detail_page.dart';
import '../modules/subscription/subscription_page.dart';
import '../modules/subscription/payment_page.dart';
import '../modules/cart/cart_page.dart';
import '../modules/booking/booking_page.dart';
import '../modules/booking/booking_detail_page.dart';
import '../modules/car/car_page.dart';
import '../modules/support/support_page.dart';
import '../modules/support/contact_us_page.dart';
import '../modules/tracking/tracking_page.dart';
import 'app_routes.dart';

class AppPages {
  static const INITIAL = AppRoutes.LOGIN;
  static const BOTTOMNAV = AppRoutes.BOTTOMNAV;

  static final routes = [
    GetPage(
        name: AppRoutes.LOGIN, page: () => LoginPage(), binding: AuthBinding()),
    GetPage(
        name: AppRoutes.SEARCHSCREEN,
        page: () => SearchPage(),
        binding: HomeBinding()),
    GetPage(name: AppRoutes.OTP, page: () => optpage(), binding: AuthBinding()),
    GetPage(
        name: AppRoutes.REGISTER,
        page: () => RegisterPage(),
        binding: AuthBinding()),
    GetPage(
        name: AppRoutes.MAPSCREEN,
        page: () => MapScreen(),
        binding: AuthBinding()),
    GetPage(
        name: AppRoutes.FILTERED_RESULTS, page: () => FilteredResultsPage()),
    GetPage(
        name: AppRoutes.EDITPROFILE,
        page: () => EditProfile(),
        binding: AuthBinding()),
    GetPage(
        name: AppRoutes.NOTIFICATIONS,
        page: () => NotificationPage(),
        binding: HomeBinding()),
    GetPage(
        name: AppRoutes.TERMSANDCONDITIONS,
        page: () => termsAndConditions(),
        binding: HomeBinding()),
    GetPage(
        name: AppRoutes.BOTTOMNAV,
        page: () => bottomnavigation(),
        binding: bottomnavigationBindings()),
    GetPage(
        name: AppRoutes.SERVICE,
        page: () => ServicePage(),
        binding: ServiceBinding()),
    GetPage(
        name: AppRoutes.SERVICE_DETAIL,
        page: () => ServiceDetailPage(),
        binding: ServiceBinding()),
    GetPage(
        name: AppRoutes.SUBSCRIPTION,
        page: () => SubscriptionPage(),
        binding: SubscriptionBinding()),
    GetPage(
        name: AppRoutes.PAYMENT,
        page: () => PaymentPage(),
        binding: SubscriptionBinding()),
    GetPage(
        name: AppRoutes.CART, page: () => CartPage(), binding: CartBinding()),
    GetPage(
        name: AppRoutes.BOOKING_DETAILS,
        page: () => BookingDetailPage(),
        binding: CartBinding()),
    GetPage(
        name: AppRoutes.BOOKING,
        page: () => BookingPage(),
        binding: BookingBinding()),
    GetPage(
        name: AppRoutes.BOOKING_DETAIL,
        page: () => BookingDetailPage(),
        binding: BookingBinding()),
    GetPage(
        name: AppRoutes.REVIEW,
        page: () => reviewPage(),
        binding: BookingBinding()),
    GetPage(name: AppRoutes.CAR, page: () => CarPage(), binding: CarBinding()),
    GetPage(
        name: AppRoutes.CAR_REGISTER,
        page: () => CarRegister(),
        binding: CarBinding()),
    GetPage(
        name: AppRoutes.CAR_DETALS,
        page: () => CarDetails(),
        binding: CarBinding()),
    GetPage(
        name: AppRoutes.SUPPORT,
        page: () => SupportPage(),
        binding: SupportBinding()),
    GetPage(
        name: AppRoutes.CONTACT_US,
        page: () => ContactUsPage(),
        binding: SupportBinding()),
    GetPage(
        name: AppRoutes.TRACKING,
        page: () => TrackingPage(),
        binding: TrackingBinding()),
    GetPage(
        name: AppRoutes.CHATSCREEN,
        page: () => ChatScreen(),
        binding: TrackingBinding()),
    GetPage(
        name: AppRoutes.PRODUCT_DETAILS,
        page: () => ProductDetailPage(),
        binding: ProductBinding()),
  ];
}
