import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Header(text: "Services", onTap: () {},),
          SizedBox(height: 12,),
          Row(
            children: [
              ServicesType(
                text: "Car Wash",
                borderSides: [BorderSideEnum.bottom, BorderSideEnum.right],
              ),
              ServicesType(
                text: "Detailing",
                borderSides: [BorderSideEnum.right, BorderSideEnum.bottom],
              ),
              ServicesType(
                text: "Painting",
                borderSides: [BorderSideEnum.bottom, BorderSideEnum.right],
              ),ServicesType(
                text: "repairing",
                borderSides: [BorderSideEnum.bottom],
              ),
            ],
          ),
          Row(
            children: [
              ServicesType(
                text: "Car Wash",
                borderSides: [BorderSideEnum.right],
              ),
              ServicesType(
                text: "Detailing",
                borderSides: [BorderSideEnum.right,],
              ),
              ServicesType(
                text: "Denting and Painting",
                borderSides: [ BorderSideEnum.right],
              ),ServicesType(
                text: "repairing",
                borderSides: [],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ServicesType extends StatelessWidget {
  final String text;
  final List<BorderSideEnum> borderSides;
  final Color borderColor;
  final double borderWidth;

  const ServicesType({
    Key? key,
    required this.text,
    this.borderSides = const [], // Default to no borders
    this.borderColor = const Color(0xffE7E7E7),
    this.borderWidth = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width / 4 - 10,
      width: MediaQuery.of(context).size.width / 4 - 10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: _createBorder(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text),
        ],
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
