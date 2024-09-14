import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wrenchmate_user_app/app/modules/home/widgits/header.dart';

class toprecommendedservices extends StatefulWidget {
  const toprecommendedservices({super.key});

  @override
  State<toprecommendedservices> createState() => _toprecommendedservicesState();
}

class _toprecommendedservicesState extends State<toprecommendedservices> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Header(
          text: "Top Recommended Services",
          onTap: () {},
          seeall: '',
        ),
        SizedBox(height: 8,),
        Row(
          children: [
            ServiceCard(
              serviceName: "General Wash",
              price: "1,400",
              rating: 4.9,
              imagePath: 'assets/car/toprecommended1.png',
              colors: [
                Color(0xff9DB3E5),
                Color(0xff3E31BF)
              ], // Make sure you have an image in your assets
            ),
            // GradientContainer(
            //   width: MediaQuery.of(context).size.width/2-36,
            //   height: 120,
            //   colors: [Color(0xff9DB3E5), Color(0xff3E31BF)], // Define the gradient colors
            //   child: Text(""),
            // ),
            ServiceCard(
              serviceName: "General Check-up",
              price: "1,400",
              rating: 4.9,
              imagePath: 'assets/car/toprecommended2.png',
              colors: [
                Color(0xffFEA563),
                Color(0xffFF5F81)
              ], // Make sure you have an image in your assets
            ),
            // GradientContainer(
            //   width: MediaQuery.of(context).size.width / 2 - 36,
            //   height: 120,
            //   colors: [
            //     Color(0xffFEA563),
            //     Color(0xffFF5F81)
            //   ], // Define the gradient colors
            //   child: Text(""),
            // ),
          ],
        ),
      ],
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
      padding: const EdgeInsets.only(right:16.0,bottom: 20),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: child,
      ),
    );
  }
}
// import 'package:flutter/material.dart';

class ServiceCard extends StatelessWidget {
  final String serviceName;
  final String price;
  final double rating;
  final List<Color> colors;

  final String imagePath;

  ServiceCard({
    required this.serviceName,
    required this.price,
    required this.rating,
    required this.colors,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      width: MediaQuery.of(context).size.width / 2 - 36,
      height: 120,
      colors: colors,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  imagePath,
                  height: 50,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      SizedBox(width: 4),
                      Text(
                        rating.toString(),
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              serviceName,
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            // SizedBox(height: 8),
            Text(
              '₹ $price',
              style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
