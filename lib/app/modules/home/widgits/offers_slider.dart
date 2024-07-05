import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class offersSliders extends StatefulWidget {
  const offersSliders({super.key});

  @override
  State<offersSliders> createState() => _offersSlidersState();
}

class _offersSlidersState extends State<offersSliders> {
  final _offersslidercontroller = CarouselController();
  int active_index_offer = 0;
  final List<Widget> offer_widgits = [
    Container(color: Colors.red, height: 100, width: 330),
    Container(color: Colors.green, height: 200, width: 330),
    Container(color: Colors.blue, height: 200, width: 330),
    Container(color: Colors.yellow, height: 200, width: 330),
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: offer_widgits.length,
          itemBuilder: (context, index, realIndex) {
            return build_offers(index);
          },
          carouselController: _offersslidercontroller,
          options: CarouselOptions(
              height: MediaQuery.of(context).size.height * 0.176,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              viewportFraction: 1,
              onPageChanged: (index, reason) {
                setState(() {
                  active_index_offer = index;
                });
              }),
        ),
        SizedBox(height: 12),
        buildindicator(),
      ],
    );
  }

  Widget build_offers(int index) {
    return InkWell(
        onTap: () {},
        child: offer_widgits[index]);
  }

  Widget buildindicator() {
    return AnimatedSmoothIndicator(
      activeIndex: active_index_offer,
      count: offer_widgits.length,
      onDotClicked: dotclicking,
      effect: ExpandingDotsEffect(
          dotHeight: 10,
          dotWidth: 10,
          dotColor: Color(0xffD9D9D9),
          activeDotColor: Color(0xffFF5402),),
    );
  }

  dotclicking(int index)=>_offersslidercontroller.animateToPage(index);
}
