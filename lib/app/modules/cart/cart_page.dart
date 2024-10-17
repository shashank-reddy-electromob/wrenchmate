import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:wrenchmate_user_app/app/controllers/productcontroller.dart';
import 'package:wrenchmate_user_app/app/data/models/Service_firebase.dart';
import 'package:wrenchmate_user_app/app/data/models/product_model.dart';
import 'package:wrenchmate_user_app/app/modules/cart/bookslotpage.dart';
import 'package:wrenchmate_user_app/app/modules/cart/widgets/api/paymemtapi.dart';
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
import 'package:crypto/crypto.dart';

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
  PaymentService paymentService = PaymentService();

  @override
  void initState() {
    super.initState();
    phonepeInit();

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

        // Calculate tax as 10% of totalAmount
        tax = totalAmount * 0.1;
        // Final amount is totalAmount + tax
        finalAmount = totalAmount + tax!;
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
                    containerButton(
                      text: "Booking Detail",
                      onPressed: () async {
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
                    Text('₹ ${cartController.totalPayableAmount.value}',
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
                        bool hasServices = cartController.cartItems
                            .any((item) => item['serviceId'] != "NA");
                        print("hasServices :: $hasServices");

                        // bool hasServices = cartController.cartItems
                        //     .any((item) => item['serviceId'] != "NA");
                        // print("hasServices :: $hasServices");
                        if (hasServices &&
                            bookingController.bookingStatus.value !=
                                'confirmed') {
                          var result = await Get.toNamed(AppRoutes.BOOK_SLOT);
                          if (result != null) {
                            setState(() {
                              selectedDate = result['selectedDate'] ?? '';
                              selectedTimeRange =
                                  result['selectedTimeRange'] ?? '';
                              selectedAddress = result['selectAddress'] ?? '';
                            });
                          }
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
                        } else if (!hasServices ||
                            bookingController.bookingStatus.value ==
                                'confirmed') {
                          print("Proceed to pay");
                          print("environment :: $environment");
                          print("appId :: $appId");
                          print("merchantId :: $merchantId");
                          print("enableLogging :: $enableLogging");
                          print("transactionId :: $transactionId");
                          body = getChecksum().toString();
                          print("body :: $body");
                          startPgTransaction();

                          // _proceedToPayment(context);
                          // await paymentService.makeTestPayment(
                          //     "MT7850590068188104",
                          //     "MUID123",
                          //     10000,
                          //     "https://webhook.site/callback-url");
                        } else {
                          Get.snackbar(
                              "Error", "Please confirm your booking first.");
                        }
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
  String transactionId = DateTime.now().millisecondsSinceEpoch.toString();
  String merchantId = "M22JKU8ER0YL4";
  bool enableLogging = true;
  String checksum = "";
  String saltKey = "c4682fa3-53ab-4edc-b433-cd4c4c63c0a1";

  String saltIndex = "1";

  String callbackUrl = "https://wrenchmate.in/";

  String body = "";
  String apiEndPoint = "/pg/v1/pay";

  Object? result;

  getChecksum() {
    final requestData = {
      "merchantId": merchantId,
      "merchantTransactionId": transactionId,
      "merchantUserId": "90223250",
      // "amount": (cartController.totalPayableAmount.value.round()) * 100,
      "amount": 100,

      "mobileNumber": "8058965210",
      "callbackUrl": callbackUrl,
      "paymentInstrument": {"type": "PAY_PAGE"}
    };

    String base64Body = base64.encode(utf8.encode(json.encode(requestData)));

    checksum =
        '${sha256.convert(utf8.encode(base64Body + apiEndPoint + saltKey)).toString()}###$saltIndex';
    print("checksum :: $checksum");
    return base64Body;
  }

  void phonepeInit() {
    PhonePePaymentSdk.init(environment, appId, merchantId, enableLogging)
        .then((val) => {
              setState(() {
                result = 'PhonePe SDK Initialized - $val';
              })
            })
        .catchError((error) {
      handleError(error);
      return <dynamic>{};
    });
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
            await Get.toNamed(AppRoutes.BOTTOMNAV);
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
