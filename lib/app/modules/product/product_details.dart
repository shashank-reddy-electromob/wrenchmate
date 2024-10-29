import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wrenchmate_user_app/app/controllers/auth_controller.dart';
import 'package:wrenchmate_user_app/app/controllers/productcontroller.dart';
import 'package:wrenchmate_user_app/app/data/models/product_model.dart';
import 'package:wrenchmate_user_app/app/modules/home/widgits/persistentnotification.dart';
import 'package:wrenchmate_user_app/app/modules/service/widgits/desc_faq_review.dart';
import 'package:wrenchmate_user_app/app/modules/service/widgits/elevatedbutton.dart';
import 'package:wrenchmate_user_app/app/modules/service/widgits/seperator.dart';
import 'package:wrenchmate_user_app/app/modules/service/widgits/servicecardiconswidget.dart';
import 'package:wrenchmate_user_app/app/widgets/custombackbutton.dart';
import 'package:wrenchmate_user_app/utils/color.dart';
import 'package:wrenchmate_user_app/utils/textstyles.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/service_controller.dart';
import '../../routes/app_routes.dart';

class ProductDetailPage extends StatefulWidget {
  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  String selectedTab = 'description';
  late List<bool> _isVisibleList;
  final ProductController controller = Get.find();
  late Product product;
  bool addtocart = false;
  late CartController cartController;
  late final ProductController productController;
  List<bool> addToCartStates = [];
  final AuthController authController = Get.put(AuthController());

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    product = Get.arguments;
    cartController = Get.put(CartController());
    productController = Get.put(ProductController());
    selectedPrice = product.price.toDouble();
    fetchData(product);
    // _isVisibleList = List<bool>.filled(controller.faqs.length, false);
  }

  void fetchData(Product product) async {
    controller.reviews.clear();
    await controller.fetchReviewsForProduct(product);
  }

  @override
  void dispose() {
    // controller.reviews.clear();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Obx(
        () => Visibility(
          visible: !cartController.cartItems.isEmpty,
          child: FloatingActionButton(
            onPressed: () {
              Get.toNamed(AppRoutes.CART);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
            backgroundColor: primaryColor,
            child: Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            shape: CircleBorder(),
          ),
        ),
      ),
      key: scaffoldMessengerKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Custombackbutton(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xffF6F6F5),
                borderRadius: BorderRadius.circular(30),
              ),
              child: IconButton(
                icon: Icon(
                  CupertinoIcons.suit_heart,
                  color: Color(0xff1E1E1E),
                  size: 22,
                ),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (addToCartStates.isEmpty) {
          addToCartStates =
              List<bool>.filled(productController.products.length, false);
        }
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else {
          return SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.45,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: ExtendedImage.network(
                          product.image,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.3,
                          fit: BoxFit.cover,
                          cache: true,
                        ),
                      ),
                      Positioned(
                        bottom: -10,
                        left: 10,
                        right: 10,
                        child: serviceCard(),
                      ),
                    ]),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 1, vertical: 8),
                    decoration: BoxDecoration(
                      color: Color(0xffF6F6F5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildTab('Description'),
                        buildTab('Review'),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  if (selectedTab == 'description') DescriptionWidget(),
                  if (selectedTab == 'review') ReviewWidget(),
                  // Positioned(
                  //   bottom: 0,
                  //   left: 0,
                  //   right: 0,
                  //   child: PersistentNotification(
                  //     totalAmount: cartController.totalAmount,
                  //     discountAmount: cartController.discountAmount,
                  //   ),
                  // ),
                ],
              ),
            ),
          );
        }
      }),
    );
  }

  Widget buildTab(String text) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = text.toLowerCase();
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: selectedTab == text.toLowerCase()
              ? primaryColor
              : Colors.transparent,
        ),
        child: Text(
          text,
          style: TextStyle(
            color:
                selectedTab == text.toLowerCase() ? Colors.white : Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget serviceCard() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 15,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("Product > ",
                  style: AppTextStyle.mediumRaleway12
                      .copyWith(color: Color(0xff6F6F6F))),
              Text(product.productName,
                  style: AppTextStyle.mediumRaleway12
                      .copyWith(color: primaryColor))
            ],
          ),
          SizedBox(height: 8),
          Text(product.productName, style: AppTextStyle.semibold18),
          Row(
            children: [
              Text("₹ ${selectedPrice ?? product.price}",
                  style: AppTextStyle.semibold14),
              // Spacer(),
              Icon(Icons.star, color: Colors.yellow, size: 16),
              Text("${product.averageReview}",
                  style: TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.bold)),
              Text("(${product.numberOfReviews} reviews)",
                  style: TextStyle(color: Colors.black54)),
              Spacer(),
              Positioned(
                  top: MediaQuery.of(context).size.height * 0.055,
                  right: MediaQuery.of(context).size.width * 0.04,
                  child:
                      //  addtocart == false
                      //     ?
                      CustomElevatedButton(
                    onPressed: () {
                      cartController.addProductToCartSnackbar(
                        context,
                        cartController,
                        product,
                        selectedQuantity ?? product.quantity,
                        scaffoldMessengerKey,
                      );
                      setState(() {
                        addtocart = true;
                      });
                    },
                    text: '+Add',
                  )
                  // : CustomElevatedButton(
                  //     onPressed: () {
                  //       Get.toNamed(AppRoutes.CART);
                  //       ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  //     },
                  //     textSize: 12,
                  //     text: 'Go to cart',
                  //   ),
                  ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: product.quantitiesAvailable
                .asMap()
                .entries
                .map((entry) => buildQuantityButton(entry.value,
                    double.parse(product.pricesAvailable[entry.key])))
                .toList(),
          ),
        ],
      ),
    );
  }

  String? selectedQuantity;
  double? selectedPrice;

  Widget buildQuantityButton(String quantity, double price) {
    bool isSelected = selectedQuantity == quantity;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedQuantity = quantity;
          selectedPrice = price; // Update the selected price
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isSelected ? primaryColor : Colors.grey.shade200,
          ),
          child: Text(
            quantity,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black54,
            ),
          ),
        ),
      ),
    );
  }

  Widget DescriptionWidget() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Color(0xffF6F6F5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Text(
          product.description,
          style: AppTextStyle.medium10.copyWith(color: Color(0xff6D6D6D)),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget ReviewWidget() {
    if (controller.reviews.isEmpty) {
      return Center(
        child: Text("No review yet"),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: controller.reviews.length,
      itemBuilder: (context, serviceIndex) {
        var review = controller.reviews[serviceIndex];
        var user = controller.users[serviceIndex];
        return Container(
          color: Color(0xffF6F6F5),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipOval(
                        child: user.userProfileImage.isEmpty
                            ? Icon(Icons.account_circle, size: 45.0)
                            : Image.network(
                                user.userProfileImage,
                                fit: BoxFit.cover,
                                height: 45.0,
                                width: 45.0,
                              )),
                    SizedBox(
                      width: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.userName.isNotEmpty ? user.userName : 'Unknown',
                          style: AppTextStyle.semibold14,
                        ),
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < review.rating
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.yellow,
                              size: 20,
                            );
                          }),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  review.message,
                  style:
                      AppTextStyle.medium10.copyWith(color: Color(0xff575757)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
