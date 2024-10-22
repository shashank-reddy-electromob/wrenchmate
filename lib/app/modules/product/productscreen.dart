import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wrenchmate_user_app/app/controllers/auth_controller.dart';
import 'package:wrenchmate_user_app/app/controllers/cart_controller.dart';
import 'package:wrenchmate_user_app/app/controllers/productcontroller.dart';
import 'package:wrenchmate_user_app/app/modules/home/widgits/searchbar_filter.dart';
import 'package:wrenchmate_user_app/app/modules/service/widgits/elevatedbutton.dart';
import 'package:wrenchmate_user_app/app/routes/app_routes.dart';
import 'package:wrenchmate_user_app/app/widgets/appbar.dart';
import 'package:wrenchmate_user_app/utils/color.dart';
import 'package:wrenchmate_user_app/utils/textstyles.dart';
import '../../widgets/custombackbutton.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late final ProductController productController;
  List<bool> addToCartStates = [];
  final AuthController authController = Get.put(AuthController());
  late CartController cartController;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    productController = Get.put(ProductController());
    cartController = Get.put(CartController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Product",
              style: AppTextStyle.semiboldRaleway19,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          searchbar(),
          SizedBox(height: 16.0),
          Expanded(
            child: Obx(() {
              if (productController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              if (productController.errorMessage.isNotEmpty) {
                return Center(
                    child: Text(productController.errorMessage.value));
              }

              // Initialize addToCartStates here when products are loaded
              if (addToCartStates.isEmpty) {
                addToCartStates =
                    List<bool>.filled(productController.products.length, false);
              }

              return ListView.builder(
                itemCount: productController.products.length,
                itemBuilder: (context, index) {
                  final product = productController.products[index];
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.PRODUCT_DETAILS,
                          arguments: product);
                                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                    child: Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 50.0),
                          child: Card(
                            color: Color(0xffF7F7F7),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              side: BorderSide(width: 1, color: lightGreyColor),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 56.0,
                                top: 16.0,
                                right: 0.0,
                                bottom: 16.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.productName,
                                    style: AppTextStyle.semibold15,
                                  ),
                                  SizedBox(height: 4.0),
                                  Text(
                                    'QUANTITY=${product.quantity}',
                                    style: AppTextStyle.mediumdmsans11,
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    '₹ ${product.price}',
                                    style: AppTextStyle.mediumdmsans13,
                                  ),
                                  SizedBox(height: 4.0),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          product.description,
                                          style: AppTextStyle.medium10,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: !addToCartStates[index]
                                            ? CustomElevatedButton(
                                                onPressed: () {
                                                  cartController
                                                      .addProductToCartSnackbar(
                                                    context,
                                                    cartController,
                                                    product,
                                                    product.quantity,
                                                    scaffoldMessengerKey,
                                                  );
                                                  setState(() {
                                                    addToCartStates[index] =
                                                        true;
                                                  });
                                                },
                                                text: '+Add',
                                              )
                                            : CustomElevatedButton(
                                                onPressed: () {
                                                  Get.toNamed(AppRoutes.CART);
                                                  ScaffoldMessenger.of(context)
                                                      .hideCurrentSnackBar();
                                                },
                                                text: 'Go to cart',
                                              ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 4.0,
                          top: 35.0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              product.image,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
