import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wrenchmate_user_app/utils/textstyles.dart';

import '../../../routes/app_routes.dart';
import '../../service/service_page.dart';
import 'header.dart';

class serviceswidgit extends StatefulWidget {
  const serviceswidgit({super.key});

  @override
  State<serviceswidgit> createState() => _serviceswidgitState();
}

class _serviceswidgitState extends State<serviceswidgit> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Column(
        children: [
          Header(
            text: "Services",
          ),
          SizedBox(
            height: 12,
          ),
          Row(
            children: [
              ServicesType(
                text: "Car Wash",
                borderSides: [BorderSideEnum.bottom, BorderSideEnum.right],
                imagePath: 'assets/services/car wash.png',
                onTap: () => navigateToServicePage("Car Wash"),
              ),
              ServicesType(
                text: "Detailing",
                borderSides: [BorderSideEnum.right, BorderSideEnum.bottom],
                imagePath: 'assets/services/detailing.png',
                onTap: () => navigateToServicePage("Detailing"),
              ),
              ServicesType(
                text: "Denting and Painting",
                borderSides: [BorderSideEnum.bottom, BorderSideEnum.right],
                imagePath: 'assets/services/painting.png',
                onTap: () => navigateToServicePage("Denting and Painting"),
              ),
              ServicesType(
                text: "Repairs",
                borderSides: [BorderSideEnum.bottom],
                imagePath: 'assets/services/repair.png',
                onTap: () => navigateToServicePage("Repairing"),
              ),
            ],
          ),
          Row(
            children: [
              ServicesType(
                text: "Accessories",
                borderSides: [BorderSideEnum.right],
                imagePath: 'assets/services/accessories.png',
                onTap: () => navigateToServicePage("Accessories"),
              ),
              ServicesType(
                text: "Wheel Service",
                borderSides: [BorderSideEnum.right],
                imagePath: 'assets/services/wheelservice.png',
                onTap: () => navigateToServicePage("Wheel Service"),
              ),
              ServicesType(
                text: "Body Parts",
                borderSides: [BorderSideEnum.right],
                imagePath: 'assets/services/body parts.png',
                onTap: () => navigateToServicePage("Body Parts"),
              ),
              ServicesType(
                text: "General Service",
                borderSides: [],
                imagePath: 'assets/services/general service.png',
                onTap: () => navigateToServicePage("General Service"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void navigateToServicePage(String service) {
    Get.toNamed(AppRoutes.SERVICE, arguments: service);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}

class ServicesType extends StatelessWidget {
  final String text;
  final List<BorderSideEnum> borderSides;
  final Color borderColor;
  final double borderWidth;
  final String imagePath;
  final VoidCallback onTap;

  const ServicesType({
    Key? key,
    required this.text,
    this.borderSides = const [],
    this.borderColor = const Color(0xffE7E7E7),
    this.borderWidth = 1.0,
    required this.imagePath,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: MediaQuery.of(context).size.width / 4,
        width: MediaQuery.of(context).size.width / 4 - 10,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: _createBorder(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.start,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Image.asset(
                width: 35,
                imagePath,
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 2, 0),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: AppTextStyle.mediumRaleway12.copyWith(
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.fade,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Border _createBorder() {
    return Border(
      top: borderSides.contains(BorderSideEnum.top)
          ? BorderSide(color: borderColor, width: borderWidth)
          : BorderSide.none,
      bottom: borderSides.contains(BorderSideEnum.bottom)
          ? BorderSide(color: borderColor, width: borderWidth)
          : BorderSide.none,
      left: borderSides.contains(BorderSideEnum.left)
          ? BorderSide(color: borderColor, width: borderWidth)
          : BorderSide.none,
      right: borderSides.contains(BorderSideEnum.right)
          ? BorderSide(color: borderColor, width: borderWidth)
          : BorderSide.none,
    );
  }
}

enum BorderSideEnum {
  top,
  bottom,
  left,
  right,
}
