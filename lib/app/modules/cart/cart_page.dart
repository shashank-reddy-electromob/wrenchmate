import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wrenchmate_user_app/app/modules/cart/widgets/containerButton.dart';
import 'package:wrenchmate_user_app/app/modules/cart/widgets/pricing.dart';
import 'package:wrenchmate_user_app/utils/color.dart';
import 'package:wrenchmate_user_app/utils/textstyles.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/service_controller.dart';
import '../../controllers/booking_controller.dart'; // Import the BookingController
import '../../controllers/home_controller.dart'; // Import the HomeController
import '../../widgets/custombackbutton.dart'; // Import the ServiceController

class CartPage extends StatefulWidget {
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartController cartController = Get.find();
  final ServiceController serviceController = Get.find();
  final BookingController bookingController = Get.put(BookingController());
  final HomeController homeController = Get.put(HomeController());

  double? totalAmount;
  double? tax;
  double? finalAmount;
  List<String> deletedServiceIds = [];
  String? currentCar;

  @override
  void initState() {
    super.initState();
    fetchCartData();
    fetchUserCurrentCar();
    // ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  Future<void> fetchCartData() async {
    await cartController.fetchCartItems();
    calculateTotal();
  }

  Future<void> fetchUserCurrentCar() async {
    currentCar = await homeController.fetchUserCurrentCar();
    setState(() {});
  }

  void calculateTotal() {
    setState(() {
      totalAmount = cartController.cartItems.fold<double>(0, (sum, item) {
        var service = serviceController.services.firstWhere(
          (s) => s.id == item['serviceId'],
        );
        return sum + (service?.price ?? 0);
      });

      tax = totalAmount! * 0.1;
      finalAmount = (totalAmount! + tax!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Cart",
          style: TextStyle(fontWeight: FontWeight.w500, fontFamily: 'Raleway'),
        ),
        leading: Padding(
            padding: const EdgeInsets.all(6.0), child: Custombackbutton()),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Obx(() {
            if (cartController.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8),
                    child: Text(
                      'Order Summary',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins'),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    padding: EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: cartController.cartItems.length,
                      itemBuilder: (context, index) {
                        var cartItem = cartController.cartItems[index];
                        var service = serviceController.services.firstWhere(
                          (s) => s.id == cartItem['serviceId'],
                        );
                        return Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: ExtendedImage.network(
                                            //"https://carfixo.in/wp-content/uploads/2022/05/car-wash-2.jpg",
                                            service.image,
                                            fit: BoxFit.cover,
                                            cache: true,
                                            width: 80,
                                            height: 60),
                                      ),
                                      SizedBox(width: 16),
                                      // Service Details
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(service.name,
                                              style:
                                                  AppTextStyle.mediumRaleway12),
                                          SizedBox(height: 4),
                                          Text(
                                            '₹ ${service.price.toStringAsFixed(2)}', // Display price
                                            style: AppTextStyle.semiboldpurple12
                                                .copyWith(color: blackColor),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  // Remove Item Button
                                  IconButton(
                                    icon: Icon(Icons.delete_rounded,
                                        color: Colors.red),
                                    onPressed: () async {
                                      await cartController
                                          .deleteServicesFromCart(
                                              cartItem['serviceId']);
                                      setState(() {
                                        cartController.cartItems
                                            .removeAt(index);
                                        calculateTotal();
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              color: Color(0xFFF0F0F0),
                              thickness: 1,
                              indent: 16,
                              endIndent: 16,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  containerButton(
                    text: "Apply Coupon",
                    onPressed: () {},
                    icon: Icons.add_card,
                  ),
                  //pricings
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Pricing(
                            text: "Subtotal", price: totalAmount.toString()),
                        Pricing(text: "Tax", price: tax.toString()),
                        Divider(
                          color: Color(0xFFF0F0F0),
                          thickness: 1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Total",
                                style: TextStyle(
                                    fontSize: 16, fontFamily: 'Raleway')),
                            Text('\₹ ${finalAmount?.toStringAsFixed(2)}',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins')),
                          ],
                        ),
                      ],
                    ),
                  ),
                  containerButton(
                    text: "Booking Detail",
                    onPressed: () {},
                    icon: Icons.file_copy_outlined,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                  )
                ],
              ),
            );
          }),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: Color(0xffFAFAFA),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                          '\₹ ${finalAmount?.toStringAsFixed(2)}', // This will now update dynamically
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Poppins')),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          'View Detailed Bill',
                          style: TextStyle(
                              color: primaryColor,
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff3778F2),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: () async {
                        try {
                          List<String> serviceIds = List<String>.from(
                            cartController.cartItems
                                .map((item) => item['serviceId']),
                          );

                          await bookingController.addBooking(
                            serviceIds,
                            'confirmed', // status
                            DateTime.now(), // confirmation_date
                            null, // outForService_date
                            null, // completed_date
                            '', // confirmation_note
                            '', // outForService_note
                            '', // completed_note
                            currentCar!, // Pass the current car
                          );

                          // Optionally show a success message
                          Get.snackbar(
                              "Success", "Booking confirmed successfully!");
                        } catch (e) {
                          // Handle the error
                          Get.snackbar(
                              "Error", "Failed to confirm booking: $e");
                        }
                      },
                      child: Text(
                        "Proceed to Pay",
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
