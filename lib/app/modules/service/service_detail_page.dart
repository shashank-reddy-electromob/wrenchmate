import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wrenchmate_user_app/app/modules/service/widgits/desc_faq_review.dart';
import 'package:wrenchmate_user_app/app/modules/service/widgits/elevatedbutton.dart';
import 'package:wrenchmate_user_app/app/modules/service/widgits/seperator.dart';
import 'package:wrenchmate_user_app/app/modules/service/widgits/servicecardiconswidget.dart';
import 'package:wrenchmate_user_app/app/widgets/custombackbutton.dart';
import 'package:wrenchmate_user_app/utils/color.dart';
import 'package:wrenchmate_user_app/utils/textstyles.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/service_controller.dart';
import '../../data/models/Service_firebase.dart';
import '../../data/models/user_module.dart';
import '../../routes/app_routes.dart';

class ServiceDetailPage extends StatefulWidget {
  @override
  State<ServiceDetailPage> createState() => _ServiceDetailPageState();
}

class _ServiceDetailPageState extends State<ServiceDetailPage> {
  String selectedTab = 'description';
  late List<bool> _isVisibleList;
  final ServiceController controller = Get.find();
  late Servicefirebase service;
  bool addtocart = false;
  late CartController cartController;

  @override
  void initState() {
    super.initState();
    service = Get.arguments;
    cartController = Get.put(CartController());
    fetchData(service);
    _isVisibleList = List<bool>.filled(controller.faqs.length, false);
  }

  void fetchData(Servicefirebase service) async {
    controller.reviews.clear();
    await controller.fetchReviewsForService(service);
    await controller.fetchFAQsForService(service.id);

    _isVisibleList = List<bool>.filled(controller.faqs.length, false);
  }

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void dispose() {
    controller.reviews.clear();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldMessengerKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
      body: Obx(() {
        if (controller.loading.value) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.49,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: ExtendedImage.network(
                        service.image,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.3,
                        fit: BoxFit.cover,
                        cache: true,
                      ),
                    ),
                    Positioned(
                        top: 200, left: 8, child: Center(child: serviceCard())),
                  ]),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 8),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Color(0xffF6F6F5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        descFaqReview(
                          text: 'Description',
                          isSelected: selectedTab == 'description',
                          onTap: () {
                            setState(() {
                              selectedTab = 'description';
                            });
                          },
                        ),
                        descFaqReview(
                          text: 'FAQs',
                          isSelected: selectedTab == 'faq',
                          onTap: () {
                            setState(() {
                              selectedTab = 'faq';
                            });
                          },
                        ),
                        descFaqReview(
                          text: 'Review',
                          isSelected: selectedTab == 'review',
                          onTap: () {
                            setState(() {
                              selectedTab = 'review';
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                // Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12),
                    child: selectedTab == 'faq'
                        ? ExpandingListFAQs()
                        : selectedTab == 'description'
                            ? DescriptionWidget()
                            : selectedTab == 'review'
                                ? ReviewWidget()
                                : Container(),
                  ),
                ),
              ],
            ),
          );
        }
      }),
    );
  }

  Widget serviceCard() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.86,
      height: MediaQuery.of(context).size.height * 0.23,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 15,
          ),
        ],
      ),
      child: Stack(children: [
        Padding(
          padding: EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("Service  ",
                      style: AppTextStyle.mediumRaleway12
                          .copyWith(color: Color(0xff6F6F6F))),
                  Icon(
                    CupertinoIcons.greaterthan,
                    size: 12,
                  ),
                  Text('  ${service.name}',
                      style: AppTextStyle.mediumRaleway12
                          .copyWith(color: primaryColor))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                service.name,
                style: AppTextStyle.semibold18,
              ),
              Text("₹ ${service.price}", style: AppTextStyle.semibold14),
              SizedBox(
                height: 5,
              ),
              MySeparator(),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DurationWidget(
                    icon: CupertinoIcons.clock,
                    titleText: "Duration:",
                    subtitleText: "Hours",
                    durationText: service.time,
                  ),
                  DurationWidget(
                    icon: CupertinoIcons.checkmark_shield,
                    titleText: "Warrnaty:",
                    durationText: service.warranty,
                    subtitleText: '',
                  ),
                  DurationWidget(
                    icon: CupertinoIcons.star,
                    titleText: "Rating",
                    durationText: service.averageReview.toString(),
                    subtitleText: '',
                  ),
                ],
              )
            ],
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.055,
          right: MediaQuery.of(context).size.width * 0.04,
          child: (addtocart == false)
              ? CustomElevatedButton(
                  onPressed: () {
                    cartController.addToCartSnackbar(
                      context,
                      cartController,
                      service,
                      scaffoldMessengerKey,
                    );
                    setState(() {
                      addtocart = true;
                    });
                  },
                  text: '+Add',
                )
              : CustomElevatedButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.CART);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                  text: 'Go to cart',
                ),
          // child: CustomElevatedButton(
          //   onPressed: () {
          //
          //     // showModalBottomSheet(
          //     //   context: context,
          //     //   isScrollControlled: true,
          //     //   builder: (context) {
          //     //     return BottomSheet();
          //     //   },
          //     // );
          //   },
          //   text: 'Add+',
          // )
        ),
      ]),
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
          service.description,
          style: AppTextStyle.medium10.copyWith(color: Color(0xff6D6D6D)),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget ExpandingListFAQs() {
    return ListView.builder(
      itemCount: controller.faqs.length,
      itemBuilder: (context, serviceIndex) {
        var faq = controller.faqs[serviceIndex];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                faq.question,
                style: AppTextStyle.medium10.copyWith(
                  color: _isVisibleList[serviceIndex]
                      ? Color(0xff3778F2)
                      : Color(0xff7B7B7B),
                ),
                // style: TextStyle(
                //     color: _isVisibleList[serviceIndex]
                //         ? Color(0xff3778F2)
                //         : Color(0xff7B7B7B),
                //     fontSize: 16),
              ),
              trailing: _isVisibleList[serviceIndex]
                  ? Icon(Icons.arrow_drop_up, color: Color(0xff3778F2))
                  : Icon(Icons.arrow_drop_down, color: Color(0xff7B7B7B)),
              onTap: () {
                setState(() {
                  _isVisibleList[serviceIndex] = !_isVisibleList[serviceIndex];
                });
              },
              tileColor: Color(0xffF6F6F5),
            ),
            Visibility(
              visible: _isVisibleList[serviceIndex],
              child: Container(
                color: Color(0xffF6F6F5),
                width: double.infinity,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Text(
                    faq.answer, // Use FAQ model
                    style: AppTextStyle.medium10.copyWith(
                      color: Color(0xff6D6D6D),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget ReviewWidget() {
    return ListView.builder(
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
                        child: user.userProfileImage.isNotEmpty
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
                SizedBox(
                  height: 10,
                ),
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
