import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wrenchmate_user_app/utils/textstyles.dart';

class offersSliders extends StatefulWidget {
  const offersSliders({super.key});

  @override
  State<offersSliders> createState() => _offersSlidersState();
}

class _offersSlidersState extends State<offersSliders> {
  final _offersslidercontroller = CarouselController();
  int active_index_offer = 0;
  final List<Widget> offer_widgits = [
    OfferCard(
      discountText: '30%',
      offerTitle: 'Get Best Offer',
      imagePath: 'assets/images/casousel_img.png',
    ),
    OfferCard(
      discountText: '30%',
      offerTitle: 'Get Best Offer',
      imagePath: 'assets/images/casousel_img.png',
    ),
    OfferCard(
      discountText: '30%',
      offerTitle: 'Get Best Offer',
      imagePath: 'assets/images/casousel_img.png',
    ),
    OfferCard(
      discountText: '30%',
      offerTitle: 'Get Best Offer',
      imagePath: 'assets/images/casousel_img.png',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CarouselSlider.builder(
          itemCount: offer_widgits.length,
          itemBuilder: (context, index, realIndex) {
            return build_offers(index);
          },
          carouselController: _offersslidercontroller,
          options: CarouselOptions(
              height: MediaQuery.of(context).size.height * 0.27,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              viewportFraction: 1,
              onPageChanged: (index, reason) {
                setState(() {
                  active_index_offer = index;
                });
              }),
        ),
        buildindicator(),
      ],
    );
  }

  Widget build_offers(int index) {
    return InkWell(
        onTap: () {
          print("details wala fun");
        },
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
        activeDotColor: Color(0xffFF5402),
      ),
    );
  }

  dotclicking(int index) => _offersslidercontroller.animateToPage(index);
}

// import 'package:flutter/material.dart';

class OfferCard extends StatelessWidget {
  final String discountText;
  final String offerTitle;
  final String imagePath;

  OfferCard({
    required this.discountText,
    required this.offerTitle,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        // height and width can be set based on the available space or made flexible
        // height: 150,
        // width: 330,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: AssetImage(imagePath),
            // fit: BoxFit.fitHeight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 26, horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                decoration: BoxDecoration(
                  color: Color(0xffF7FAFF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('Latest Offer',
                    style: AppTextStyle.medium10
                        .copyWith(color: Color(0xff00246B))),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    offerTitle,
                    style:
                        AppTextStyle.semibold16.copyWith(color: Colors.white),
                  ),
                  // SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        'Get upto ',
                        style:
                            AppTextStyle.medium10.copyWith(color: Colors.white),
                      ),
                      Text(
                        discountText,
                        style:
                            AppTextStyle.bold24.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                  // SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffFF5402),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Book Now',
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'Poppins'),
                        ),
                      ),
                      Text(
                        'All washing services included | T&C applied',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 6,
                        ),
                        maxLines: 1, // Avoid overflow with ellipsis
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
