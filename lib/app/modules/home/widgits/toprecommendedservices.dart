import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wrenchmate_user_app/app/modules/home/widgits/header.dart';

class toprecommendedservices extends StatefulWidget {
  const toprecommendedservices({super.key});

  @override
  State<toprecommendedservices> createState() => _toprecommendedservicesState();
}

class _toprecommendedservicesState extends State<toprecommendedservices> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0,right: 20),
      child: Column(
        children: [
          Header(text: "Top Recommended Services",onTap: (){}, seeall: 'See all',),
          Row(
            children: [
              GradientContainer(
                width: MediaQuery.of(context).size.width/2-36,
                height: 120,
                colors: [Color(0xff9DB3E5), Color(0xff3E31BF)], // Define the gradient colors
                child: Text(""),
              ),GradientContainer(
                width: MediaQuery.of(context).size.width/2-36,
                height: 120,
                colors: [Color(0xffFEA563), Color(0xffFF5F81)], // Define the gradient colors
                child:  Text(""),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
class GradientContainer extends StatelessWidget {
  final double width;
  final double height;
  final List<Color> colors;
  final Widget child;

  const GradientContainer({
    Key? key,
    required this.width,
    required this.height,
    required this.colors,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
          borderRadius: BorderRadius.circular(12), // Optional: Adjust for rounded corners
        ),
        child: child,
      ),
    );
  }
}