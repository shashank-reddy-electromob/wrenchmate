import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:wrenchmate_user_app/app/controllers/productcontroller.dart';
import 'package:wrenchmate_user_app/app/data/models/Service_firebase.dart';
import 'package:wrenchmate_user_app/app/data/models/product_model.dart';
import 'package:wrenchmate_user_app/app/modules/cart/bookslotpage.dart';
import 'package:wrenchmate_user_app/app/modules/cart/widgets/api/paymemtapi.dart';
import 'package:wrenchmate_user_app/app/modules/cart/widgets/containerButton.dart';
import 'package:wrenchmate_user_app/app/modules/cart/widgets/pricing.dart';
import 'package:wrenchmate_user_app/globalVariables.dart';
import 'package:wrenchmate_user_app/utils/color.dart';
import 'package:wrenchmate_user_app/utils/textstyles.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/service_controller.dart';
import '../../controllers/booking_controller.dart';
import '../../controllers/home_controller.dart';
import '../../widgets/custombackbutton.dart';
import '../../routes/app_routes.dart'; // Import AppRoutes
import 'package:crypto/crypto.dart';

import '../home/home_page.dart';

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
  Razorpay _razorpay = Razorpay();
  double totalAmount = 0.0;
  double? tax;
  double? finalAmount;
  List<String> deletedServiceIds = [];
  String? currentCar;
  String? selectedAddress;
  DateTime? selectedDate;
  SfRangeValues? selectedTimeRange;
  PaymentService paymentService = PaymentService();

  HomePage tracking = new HomePage();

  @override
  void initState() {
    super.initState();
    // phonepeInit();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      fetchUserCurrentCar();
      fetchCartData();
    });
  }

  Future<void> fetchCartData() async {
    await cartController.fetchCartItems();
    if (cartController.cartItems.isEmpty &&
        cartController.cartSubsItems.isEmpty) {
      // Navigator.pop(context);
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
        totalAmount = 0.0; // Initialize totalAmount to 0.0
        for (var item in cartController.cartItems) {
          double price = item['price'] != null
              ? double.parse(item['price'].toString())
              : 0.0;
          int unitsQuantity =
              item['unitsquantity'] ?? 1; // Default to 1 if null

          // Update totalAmount based on price and quantity
          totalAmount += price * unitsQuantity;
        }
        for (var item in cartController.cartSubsItems) {
          double price = item['price'] != null
              ? double.parse(item['price'].toString())
              : 0.0;
          int unitsQuantity =
              item['unitsquantity'] ?? 1; // Default to 1 if null

          // Update totalAmount based on price and quantity
          totalAmount += price * unitsQuantity;
        }

        // Calculate tax as 10% of totalAmount
        tax = totalAmount * 0.1;
        // Final amount is totalAmount + tax
        finalAmount = totalAmount + tax!;
        log('final amount from cart page ${finalAmount.toString()}');
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

              if (cartController.cartItems.isEmpty &&
                  cartController.cartSubsItems.isEmpty) {
                return Center(child: Text("Your cart is empty"));
              }
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
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
                                            print(
                                                "${cartItem['productId']} is being deleted ");
                                            // print("cartItem['unitsquantity']");
                                            await cartController
                                                .deleteProductsFromCart(
                                              cartItem['productId'],
                                              cartItem['productQuantity'],
                                            );
                                          } else if (cartItem['serviceId'] !=
                                              "NA") {
                                            print(
                                                "${cartItem['serviceId']} is being deleted ");

                                            await cartController
                                                .deleteServicesFromCart(
                                                    cartItem['serviceId']);
                                          }

                                          if (cartController
                                              .cartItems.isEmpty) {
                                            Get.toNamed(AppRoutes.BOTTOMNAV,
                                                arguments: {
                                                  'tracking_button': false,
                                                });
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
                    Obx(() {
                      return cartController.cartSubsItems.isEmpty
                          ? SizedBox()
                          : Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(16),
                              margin: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade300,
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Subscription',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          cartController
                                              .deleteSubscriptionFromCart(
                                                  cartController
                                                          .cartSubsItems[0]
                                                      ['subscriptionId']);
                                        },
                                        child: Icon(
                                          Icons.delete_rounded,
                                          color: Colors.red,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Pricing(
                                    text: cartController.cartSubsItems[0]
                                            ['packDesc']
                                        .toString(),
                                    price:
                                        '${cartController.cartSubsItems[0]['price'].toString()}',
                                  ),
                                ],
                              ),
                            );
                    }),
                    Obx(() {
                      return cartController.appliedCoupon.value.isNotEmpty
                          ? ContainerButton(
                              text:
                                  '"${cartController.appliedCoupon.value}" Applied',
                              onPressed: () {
                                cartController.deleteCoupon();
                              },
                              icon: Icons.add_card,
                              trailingWidget: Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: Text(
                                  'Remove',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            )
                          : ContainerButton(
                              text: "Apply Coupon",
                              onPressed: () {
                                Get.toNamed(AppRoutes.COUPOUNS);
                              },
                              icon: Icons.add_card,
                            );
                    }),
                    // containerButton(
                    //   text: "Apply Coupon",
                    //   onPressed: () {
                    //     Get.toNamed(AppRoutes.COUPOUNS);
                    //   },
                    //   icon: Icons.add_card,
                    // ),
                    // cartController.appliedCoupon.value.isNotEmpty
                    //     ? containerButton(
                    //         text: cartController.appliedCoupon.value,
                    //         onPressed: () {
                    //           Get.toNamed(AppRoutes.COUPOUNS);
                    //         },
                    //         icon: Icons.add_card,
                    //       )
                    //     : SizedBox(),
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
                              text: "Subtotal",
                              price: totalAmount.toStringAsFixed(2)),
                          Pricing(text: "Tax", price: tax!.toStringAsFixed(2)),
                          if (cartController.discountAmount.value > 0)
                            Pricing(
                              text: "Discount Applied:",
                              price:
                                  '-${cartController.discountAmount.value.toStringAsFixed(2)}',
                            ),
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
                                  '₹ ${cartController.totalPayableAmount.value}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins')),
                            ],
                          ),
                        ],
                      ),
                    ),

                    GestureDetector(
                        onTap: () async {
                          var result = await Get.toNamed(AppRoutes.BOOK_SLOT);
                          if (result != null) {
                            setState(() {
                              selectedDate = result['selectedDate'] ?? '';
                              selectedTimeRange =
                                  result['selectedTimeRange'] ?? '';
                              selectedAddress = result['selectAddress'] ?? '';
                            });
                          }
                        },
                        child: Container(
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                                // height: 70,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade300,
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(width: 8),
                                            Icon(
                                              Icons.file_copy_outlined,
                                              color: Colors.blue,
                                              size: 24,
                                            ),
                                            SizedBox(width: 18),
                                            Text(
                                              "Booking Detail",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Icon(
                                            Icons.navigate_next_rounded,
                                            color: CupertinoColors.black,
                                          ),
                                        )
                                        // IconButton(
                                        //     onPressed: () async {
                                        //       var result = await Get.toNamed(
                                        //           AppRoutes.BOOK_SLOT);
                                        //       log(result);
                                        //       if (result != null) {
                                        //         setState(() {
                                        //           selectedDate =
                                        //               result['selectedDate'] ??
                                        //                   '';
                                        //           selectedTimeRange = result[
                                        //                   'selectedTimeRange'] ??
                                        //               '';
                                        //           selectedAddress =
                                        //               result['selectAddress'] ??
                                        //                   '';
                                        //         });
                                        //       }
                                        //     },
                                        //     icon: Icon(
                                        //       Icons.navigate_next_rounded,
                                        //       color: CupertinoColors.black,
                                        //     )),
                                      ],
                                    ),
                                    if (selectedDate != null &&
                                        selectedTimeRange != null) ...[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                      width: 0.5,
                                                      color: Colors
                                                          .grey.shade300)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15,
                                                        vertical: 10),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "Address",
                                                      style: const TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black54,
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Text(
                                                      "${'${cartController.formatAddress(selectedAddress ?? '')}'}",
                                                      style: const TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                      width: 0.5,
                                                      color: Colors
                                                          .grey.shade300)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15,
                                                        vertical: 10),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "Date",
                                                      style: const TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black54,
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Text(
                                                      "${DateFormat('d MMMM, yyyy').format(selectedDate!)}",
                                                      style: const TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                      width: 0.5,
                                                      color: Colors
                                                          .grey.shade300)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15,
                                                        vertical: 10),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "Time",
                                                      style: const TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black54,
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Text(
                                                      "${'${cartController.formatTime(selectedTimeRange!.start)} - ${cartController.formatTime(selectedTimeRange!.end)}'}",
                                                      style: const TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                    // if (selectedDate != null && selectedTimeRange != null) ...[
                    //   Padding(
                    //     padding: const EdgeInsets.symmetric(horizontal: 16),
                    //     child: Container(
                    //       width: double.infinity,
                    //       padding: EdgeInsets.all(16),
                    //       decoration: BoxDecoration(
                    //         color: Colors.grey.shade100,
                    //         borderRadius: BorderRadius.circular(8),
                    //       ),
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Text(
                    //             "Selected Date: ${DateFormat('MMMM d, yyyy, h:mm a').format(selectedDate!)}",
                    //             style: const TextStyle(
                    //               fontSize: 13,
                    //               fontWeight: FontWeight.w400,
                    //               color: Colors.grey,
                    //             ),
                    //           ),
                    //           SizedBox(height: 2),
                    //           Text(
                    //             "Selected Time Range: ${'${cartController.formatTime(selectedTimeRange!.start)}-${cartController.formatTime(selectedTimeRange!.end)}'}",
                    //             style: const TextStyle(
                    //               fontSize: 13,
                    //               fontWeight: FontWeight.w400,
                    //               color: Colors.grey,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ]
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
                    Obx(() {
                      return Text(
                          '₹ ${cartController.totalPayableAmount.value.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Poppins'));
                    }),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20)),
                            ),
                            builder: (context) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Pricing(
                                        text: "Subtotal",
                                        price: totalAmount.toStringAsFixed(2),
                                      ),
                                      Pricing(
                                        text: "Tax",
                                        price: tax!.toStringAsFixed(2),
                                      ),
                                      if (cartController.discountAmount.value >
                                          0)
                                        Pricing(
                                          text: "Discount Applied:",
                                          price:
                                              '-${cartController.discountAmount.value.toStringAsFixed(2)}',
                                        ),
                                      Divider(
                                        color: Color(0xFFF0F0F0),
                                        thickness: 1,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Total",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Raleway',
                                            ),
                                          ),
                                          Text(
                                            '₹ ${cartController.totalPayableAmount.value}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Text(
                          'View Detailed Bill',
                          style: TextStyle(
                              color: primaryColor,
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500),
                        ),
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
                        onProceedToPayPressed();

                        //   // _proceedToPayment(context);
                        // await paymentService.makeTestPayment(
                        //     "MT7850590068188104",
                        //     "MUID123",
                        //     10000,
                        //     "https://webhook.site/callback-url");
                        // } else {
                        //   Get.snackbar(
                        //       "Error", "Please confirm your booking first.");
                        // }
                      } catch (e) {
                        Get.snackbar("Error", "Failed to confirm booking: $e");
                      }
                    },
                    child: Text(
                      "Proceed to Pay",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
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

  String environment = "PRODUCTION";
  String appId = "";
  // String transactionId = DateTime.now().millisecondsSinceEpoch.toString();
  String merchantId = "M22JKU8ER0YL4";
  bool enableLogging = true;
  String checksum = "";
  String saltKey = "c4682fa3-53ab-4edc-b433-cd4c4c63c0a1";

  String saltIndex = "1";

  String callbackUrl = "https://wrenchmate.in/";

  String body = "";
  String apiEndPoint = "/pg/v1/pay";

  Object? result;

  // void onProceedToPayPressed() async {
  //   try {
  //     final transactionId = bookingController.generateUniqueTransactionId();

  //     List<String> serviceIds = List<String>.from(
  //       cartController.cartItems.map((item) => item['serviceId']),
  //     );

  //     bool hasServices =
  //         cartController.cartItems.any((item) => item['serviceId'] != "NA");
  //     print("hasServices :: $hasServices");

  //     if (hasServices && bookingController.bookingStatus.value != 'confirmed') {
  //       var result = await Get.toNamed(AppRoutes.BOOK_SLOT);
  //       if (result != null) {
  //         setState(() {
  //           selectedDate = result['selectedDate'] ?? '';
  //           selectedTimeRange = result['selectedTimeRange'] ?? '';
  //           selectedAddress = result['selectAddress'] ?? '';
  //         });
  //       }
  //     } else if (!hasServices ||
  //         bookingController.bookingStatus.value == 'confirmed') {
  //       print("Proceed to pay");
  //       print("environment :: $environment");
  //       print("appId :: $appId");
  //       print("merchantId :: $merchantId");
  //       print("enableLogging :: $enableLogging");
  //       print("transactionId :: $transactionId");
  //       body = getChecksum(transactionId).toString();
  //       print("body :: $body");

  //       // await initiatePaymentFlow();
  //       print("Simulating payment success...");
  //       await initiatePaymentFlow();
  //     } else {
  //       Get.snackbar("Error", "Please confirm your booking first.");
  //     }
  //   } catch (e) {
  //     Get.snackbar("Error", "Failed to process payment: $e");
  //   }
  // }

  // Future<void> initiatePaymentFlow() async {
  //   try {
  //     String base64Body = body;
  //     print("base64Body :: $base64Body");

  //     final response = await PhonePePaymentSdk.startTransaction(
  //         base64Body, callbackUrl, checksum, 'com.phonepe');

  //     if (response != null) {
  //       String status = response['status'].toString();
  //       String error = response['error'].toString();

  //       if (status == 'SUCCESS') {
  //         result = "Flow complete - status : SUCCESS";

  //         // Only add booking/subscription after successful payment
  //         if (cartController.cartItems.isNotEmpty) {
  //           List<String> serviceIds = List<String>.from(
  //             cartController.cartItems.map((item) => item['serviceId']),
  //           );

  //           if (serviceIds.isNotEmpty) {
  //             await bookingController.addBooking(
  //               serviceIds,
  //               'confirmed',
  //               DateTime.now(),
  //               null,
  //               null,
  //               '',
  //               '',
  //               '',
  //               currentCar!,
  //               selectedAddress!,
  //               selectedDate,
  //               selectedTimeRange,
  //             );
  //           }
  //         }

  //         // Handle subscription bookings if present
  //         if (cartController.cartSubsItems.isNotEmpty) {
  //           await bookingController.addSubscriptionBooking(
  //               cartController.cartSubsItems[0]['packDesc'].toString(),
  //               cartController.cartSubsItems[0]['price'],
  //               cartController.cartSubsItems[0]['startDate'],
  //               cartController.cartSubsItems[0]['endDate'],
  //               "confirmed",
  //               DateTime.now(),
  //               null,
  //               null,
  //               currentCar!,
  //               selectedAddress!,
  //               selectedDate,
  //               selectedTimeRange,
  //               cartController.cartSubsItems[0]['subscriptionId'],
  //               cartController.cartSubsItems[0]['subscriptionName'],
  //               context);
  //         }
  //         await cartController.clearCart();
  //         cartController.totalAmount.value = 0;

  //         Get.back();
  //         await Future.delayed(Duration(milliseconds: 50), () async {
  //           await Get.toNamed(AppRoutes.BOTTOMNAV, arguments: {
  //             'tracking_button': true,
  //           });
  //         });
  //       } else {
  //         result = "Flow complete - status : $status and error $error";
  //         Get.snackbar("Error", "Payment failed. Please try again.");
  //       }
  //     } else {
  //       result = "Flow Incomplete";
  //       Get.snackbar("Error", "Payment process was incomplete");
  //     }
  //   } catch (error) {
  //     handleError(error);
  //     Get.snackbar("Error", "Payment processing failed: $error");
  //   }
  // }

  // getChecksum(String transactionId) {
  //   final requestData = {
  //     "merchantId": merchantId,
  //     "merchantTransactionId": transactionId,
  //     "merchantUserId": "90223250",
  //     "amount": (cartController.totalPayableAmount.value.round()) * 100,
  //     // "amount": 100,

  //     "mobileNumber": "8058965210",
  //     "callbackUrl": callbackUrl,
  //     "paymentInstrument": {"type": "PAY_PAGE"}
  //   };

  //   String base64Body = base64.encode(utf8.encode(json.encode(requestData)));

  //   checksum =
  //       '${sha256.convert(utf8.encode(base64Body + apiEndPoint + saltKey)).toString()}###$saltIndex';
  //   print("checksum :: $checksum");
  //   return base64Body;
  // }

  void onProceedToPayPressed() async {
    try {
      final transactionId = bookingController.generateUniqueTransactionId();
      int amount = (cartController.totalPayableAmount.value *
          100).toInt(); // Razorpay accepts amount in paise
      List<String> serviceIds = List<String>.from(
        cartController.cartItems.map((item) => item['serviceId']),
      );

      bool hasServices =
          cartController.cartItems.any((item) => item['serviceId'] != "NA");
      if (hasServices && bookingController.bookingStatus.value != 'confirmed') {
        var result = await Get.toNamed(AppRoutes.BOOK_SLOT);
        if (result != null) {
          setState(() {
            selectedDate = result['selectedDate'] ?? '';
            selectedTimeRange = result['selectedTimeRange'] ?? '';
            selectedAddress = result['selectAddress'] ?? '';
          });
        }
      } else if (!hasServices ||
          bookingController.bookingStatus.value == 'confirmed') {
        var options = {
          'key': 'rzp_live_l2WP2ZjwHh1Ltp', // Replace with your Razorpay API key
          'amount': amount, // Amount in paise
          'name': 'Wrenchmate',
          'description': 'Payment for Services',
          'prefill': {
            'contact': '8058965210',
            'email': 'customer@example.com',
          },
          'external': {
            'wallets': ['paytm']
          }
        };

        _razorpay.open(options);
      } else {
        Get.snackbar("Error", "Please confirm your booking first.");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to process payment: $e");
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // On successful payment
    print("Payment Success: ${response.paymentId}");

    try {
      List<String> serviceIds = List<String>.from(
        cartController.cartItems.map((item) => item['serviceId']),
      );

      if (serviceIds.isNotEmpty) {
        await bookingController.addBooking(
          serviceIds,
          'confirmed',
          DateTime.now(),
          null,
          null,
          '',
          '',
          '',
          currentCar!,
          selectedAddress!,
          selectedDate,
          selectedTimeRange,
        );
      }

      if (cartController.cartSubsItems.isNotEmpty) {
        await bookingController.addSubscriptionBooking(
          cartController.cartSubsItems[0]['packDesc'].toString(),
          cartController.cartSubsItems[0]['price'],
          cartController.cartSubsItems[0]['startDate'],
          cartController.cartSubsItems[0]['endDate'],
          "confirmed",
          DateTime.now(),
          null,
          null,
          currentCar!,
          selectedAddress!,
          selectedDate,
          selectedTimeRange,
          cartController.cartSubsItems[0]['subscriptionId'],
          cartController.cartSubsItems[0]['subscriptionName'],
          context,
        );
      }

      await cartController.clearCart();
      cartController.totalAmount.value = 0;

      Get.back();
      await Future.delayed(Duration(milliseconds: 50), () async {
        await Get.toNamed(AppRoutes.BOTTOMNAV, arguments: {
          'tracking_button': true,
        });
      });
    } catch (e) {
      Get.snackbar("Error", "Failed to save booking: $e");
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // On payment error
    print("Payment Error: ${response.code} - ${response.message}");
    Get.snackbar("Error", "Payment failed: ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // On external wallet selected
    print("External Wallet: ${response.walletName}");
    Get.snackbar("Info", "External wallet selected: ${response.walletName}");
  }

  void phonepeInit() {
    // PhonePePaymentSdk.init(environment, appId, merchantId, enableLogging)
    //     .then((val) => {
    //           setState(() {
    //             result = 'PhonePe SDK Initialized - $val';
    //           })
    //         })
    //     .catchError((error) {
    //   handleError(error);
    //   return <dynamic>{};
    // });
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void startPgTransaction() async {
    try {
      // String base64Body = base64.encode(utf8.encode(json.encode(body)));
      String base64Body = body;
      print("base64Body :: $base64Body");
      var response = PhonePePaymentSdk.startTransaction(
          base64Body, callbackUrl, checksum, 'com.phonepe');
      response.then((val) async {
        print("startPgTransaction success!");
        if (val != null) {
          String status = val['status'].toString();
          String error = val['error'].toString();

          if (status == 'SUCCESS') {
            result = "Flow complete - status : SUCCESS";

            await cartController.clearCart();
            await Get.toNamed(AppRoutes.BOTTOMNAV, arguments: {
              'tracking_button': true,
            });
          } else {
            result = "Flow complete - status : $status and error $error";
          }
        } else {
          result = "Flow Incomplete";
        }
      }).catchError((error) {
        handleError(error);
        return <dynamic>{};
      });
    } catch (error) {
      handleError(error);
    }
  }

  void handleError(error) {
    setState(() {
      result = {"error": error};
    });
  }
}
