import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:wrenchmate_user_app/app/controllers/productcontroller.dart';
import 'package:wrenchmate_user_app/app/data/models/Service_firebase.dart';
import 'package:wrenchmate_user_app/app/data/models/product_model.dart';
import 'package:wrenchmate_user_app/app/modules/cart/bookslotpage.dart';
import 'package:wrenchmate_user_app/app/modules/cart/widgets/containerButton.dart';
import 'package:wrenchmate_user_app/app/modules/cart/widgets/pricing.dart';
import 'package:wrenchmate_user_app/utils/color.dart';
import 'package:wrenchmate_user_app/utils/textstyles.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/service_controller.dart';
import '../../controllers/booking_controller.dart';
import '../../controllers/home_controller.dart';
import '../../widgets/custombackbutton.dart';
import '../../routes/app_routes.dart'; // Import AppRoutes

class CartPage extends StatefulWidget {
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartController cartController = Get.put(CartController());
  final ServiceController serviceController = Get.put(ServiceController());
  final ProductController productController = Get.put(ProductController());
  final BookingController bookingController = Get.put(BookingController());
  final HomeController homeController = Get.put(HomeController());

  double totalAmount = 0.0;
  double? tax;
  double? finalAmount;
  List<String> deletedServiceIds = [];
  String? currentCar;
  String? selectedAddress;
  DateTime? selectedDate;
  SfRangeValues? selectedTimeRange;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      fetchUserCurrentCar();
      fetchCartData();
    });
  }

  Future<void> fetchCartData() async {
    await cartController.fetchCartItems();
    if (cartController.cartItems.isEmpty) {
      Navigator.pop(context);
    } else {
      calculateTotal();
    }
  }

  Future<void> fetchUserCurrentCar() async {
    try {
      var result = await homeController.fetchUserCurrentCar();
      print("cart page pe hu" + result.toString());
      currentCar = result.toString();
      setState(() {});
    } catch (e) {
      print("Failed to fetch user current car: $e");
    }
  }

  void calculateTotal() {
    try {
      setState(() {
        totalAmount = 0.0; // Initialize totalAmount
        for (var item in cartController.cartItems) {
          double price = item['price'] ?? 0.0;
          int unitsQuantity = item['unitsquantity'] ?? 0;

          // Ensure we only add valid items
          if (price > 0 && unitsQuantity > 0) {
            totalAmount += price * unitsQuantity;
          }
        }

        tax = totalAmount! * 0.1;
        finalAmount = (totalAmount! + tax!);
      });
    } catch (e) {
      print("Error calculating total: $e");
    }
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
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (cartController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              if (cartController.cartItems.isEmpty) {
                return Center(child: Text("Your cart is empty"));
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

                            if (cartItem['productId'] == "NA" &&
                                cartItem['serviceId'] == "NA") {
                              return SizedBox.shrink();
                            }

                            Widget itemWidget;

                            if (cartItem['productId'] != "NA") {
                              var product =
                                  productController.products.firstWhere(
                                (p) => p.id == cartItem['productId'],
                                orElse: () => Product(
                                  id: cartItem['productId'],
                                  description: '',
                                  price: 0,
                                  productName: '',
                                  image: 'https://via.placeholder.com/150',
                                  quantitiesAvailable: [],
                                  pricesAvailable: [],
                                  quantity: '',
                                  averageReview: 0.0,
                                  numberOfReviews: 0,
                                ),
                              );

                              itemWidget = Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: ExtendedImage.network(
                                      product.image,
                                      fit: BoxFit.cover,
                                      cache: true,
                                      width: 80,
                                      height: 60,
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(product.productName,
                                          style: AppTextStyle.mediumRaleway12),
                                      SizedBox(height: 4),
                                      Text(
                                        cartItem['unitsquantity'] > 1
                                            ? '₹ ${cartItem['price']} x ${cartItem['unitsquantity']}'
                                            : '₹ ${cartItem['price']}',
                                        style: AppTextStyle.semiboldpurple12
                                            .copyWith(color: blackColor),
                                      ),
                                      Text(
                                        '${cartItem['productQuantity']}',
                                        style: AppTextStyle.mediumdmsans11
                                            .copyWith(color: blackColor),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            } else if (cartItem['serviceId'] != "NA") {
                              var service =
                                  serviceController.services.firstWhere(
                                (s) => s.id == cartItem['serviceId'],
                                orElse: () => Servicefirebase(
                                  id: cartItem['serviceId'],
                                  category: '',
                                  description: '',
                                  discount: 0,
                                  name: '',
                                  image: 'https://via.placeholder.com/150',
                                  price: 0.0,
                                  time: '',
                                  warranty: '',
                                  averageReview: 0.0,
                                  numberOfReviews: 0,
                                  carmodel: [],
                                ),
                              );

                              itemWidget = Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: ExtendedImage.network(
                                      service.image,
                                      fit: BoxFit.cover,
                                      cache: true,
                                      width: 80,
                                      height: 60,
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(service.name,
                                          style: AppTextStyle.mediumRaleway12),
                                      SizedBox(height: 4),
                                      Text(
                                        '₹ ${service.price.toStringAsFixed(2)}',
                                        style: AppTextStyle.semiboldpurple12
                                            .copyWith(color: blackColor),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            } else {
                              itemWidget = SizedBox.shrink();
                            }

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
                                      itemWidget,
                                      IconButton(
                                        icon: Icon(Icons.delete_rounded,
                                            color: Colors.red),
                                        onPressed: () async {
                                          if (cartItem['productId'] != "NA") {
                                            await cartController
                                                .deleteProductsFromCart(
                                              cartItem['productId'],
                                              cartItem['unitsquantity'],
                                            );
                                          } else if (cartItem['serviceId'] !=
                                              "NA") {
                                            await cartController
                                                .deleteServicesFromCart(
                                                    cartItem['serviceId']);
                                          }

                                          if (cartController
                                              .cartItems.isEmpty) {
                                            Get.toNamed(AppRoutes.BOTTOMNAV);
                                          } else {
                                            calculateTotal();
                                          }
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
                          }),
                    ),
                    containerButton(
                      text: "Apply Coupon",
                      onPressed: () {
                        Get.toNamed(AppRoutes.COUPOUNS);
                      },
                      icon: Icons.add_card,
                    ),
                    //pricings
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(16),
                      margin:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
                          if (cartController.discountAmount.value > 0)
                            Pricing(
                                text: "Discount Applied:",
                                price:
                                    '-${cartController.discountAmount.value.toStringAsFixed(2)}'),
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
                              Text(
                                  '₹ ${(cartController.totalAmount.value - cartController.discountAmount.value).toStringAsFixed(2)}',
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
                      onPressed: () async {
                        var result = await Get.toNamed(AppRoutes.BOOK_SLOT);
                        if (result != null) {
                          setState(() {
                            selectedDate = result['selectedDate']??'';
                            selectedTimeRange = result['selectedTimeRange']??'';
                            selectedAddress = result['selectAddress']??'';
                          });
                        }
                      },
                      icon: Icons.file_copy_outlined,
                    ),
                  ],
                ),
              );
            }),
          ),
          Container(
            color: Color(0xffFAFAFA),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                        '₹${(cartController.totalAmount.value - cartController.discountAmount.value).toStringAsFixed(2)}',
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
                          currentCar!, // Ensure currentCar is passed as a String
                          selectedAddress!,
                          selectedDate, // Pass the selected date
                          selectedTimeRange, // Pass the selected time range
                        );

                        // Optionally show a success message
                        Get.snackbar(
                            "Success", "Booking confirmed successfully!");
                      } catch (e) {
                        // Handle the error
                        Get.snackbar("Error", "Failed to confirm booking: $e");
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
        ],
      ),
    );
  }
}
