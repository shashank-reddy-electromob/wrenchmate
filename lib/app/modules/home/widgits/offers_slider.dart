import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wrenchmate_user_app/utils/textstyles.dart';

class OffersSliders extends StatefulWidget {
  const OffersSliders({super.key});

  @override
  State<OffersSliders> createState() => _OffersSlidersState();
}

class _OffersSlidersState extends State<OffersSliders> {
  final CarouselController _offersSliderController = CarouselController();
  int _activeIndexOffer = 0;
  List<String> _imageUrls = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOfferWidgets();
  }

  Future<void> _loadOfferWidgets() async {
    try {
      _imageUrls = await fetchBannerImageUrls();
    } catch (e) {
      print('Error fetching banner images: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<List<String>> fetchBannerImageUrls() async {
    List<String> imageUrls = [];
    final storageRef = FirebaseStorage.instance.ref().child('Banner');

    try {
      final ListResult result = await storageRef.listAll();
      for (final ref in result.items) {
        String url = await ref.getDownloadURL();
        imageUrls.add(url);
      }
    } catch (e) {
      print('Error fetching banner images: $e');
    }

    return imageUrls;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_imageUrls.isNotEmpty)
          CarouselSlider.builder(
            itemCount: _imageUrls.length,
            itemBuilder: (context, index, realIndex) {
              return buildOffers(index);
            },
            carouselController: _offersSliderController,
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height * 0.27,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              viewportFraction: 1,
              onPageChanged: (index, reason) {
                setState(() {
                  _activeIndexOffer = index;
                });
              },
            ),
          )
        else
          Text('No offers available'),
        buildIndicator(),
      ],
    );
  }

  Widget buildOffers(int index) {
    return InkWell(
      onTap: () {
        print("details wala fun");
      },
      child: OfferCard(
        discountText: '30%',
        offerTitle: 'Get Best Offer',
        imagePath: _imageUrls[index],
      ),
    );
  }

  Widget buildIndicator() {
    return AnimatedSmoothIndicator(
      activeIndex: _activeIndexOffer,
      count: _imageUrls.length,
      onDotClicked: dotClicking,
      effect: ExpandingDotsEffect(
        dotHeight: 10,
        dotWidth: 10,
        dotColor: Color(0xffD9D9D9),
        activeDotColor: Color(0xffFF5402),
      ),
    );
  }

  void dotClicking(int index) => _offersSliderController.animateToPage(index);
}

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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: NetworkImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
        // child: Padding(
        //   padding: EdgeInsets.symmetric(vertical: 26, horizontal: 18),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Container(
        //         padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        //         decoration: BoxDecoration(
        //           color: Color(0xffF7FAFF),
        //           borderRadius: BorderRadius.circular(12),
        //         ),
        //         child: Text('Latest Offer',
        //             style: AppTextStyle.medium10
        //                 .copyWith(color: Color(0xff00246B))),
        //       ),
        //       Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           Text(
        //             offerTitle,
        //             style:
        //                 AppTextStyle.semibold16.copyWith(color: Colors.white),
        //           ),
        //           Row(
        //             children: [
        //               Text(
        //                 'Get upto ',
        //                 style:
        //                     AppTextStyle.medium10.copyWith(color: Colors.white),
        //               ),
        //               Text(
        //                 discountText,
        //                 style:
        //                     AppTextStyle.bold24.copyWith(color: Colors.white),
        //               ),
        //             ],
        //           ),
        //           Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             children: [
        //               ElevatedButton(
        //                 onPressed: () {},
        //                 style: ElevatedButton.styleFrom(
        //                   backgroundColor: Color(0xffFF5402),
        //                   shape: RoundedRectangleBorder(
        //                     borderRadius: BorderRadius.circular(8),
        //                   ),
        //                 ),
        //                 child: Text(
        //                   'Book Now',
        //                   style: TextStyle(
        //                       color: Colors.white, fontFamily: 'Poppins'),
        //                 ),
        //               ),
        //               Text(
        //                 'All washing services included | T&C applied',
        //                 style: TextStyle(
        //                   fontFamily: 'Poppins',
        //                   color: Colors.white.withOpacity(0.8),
        //                   fontSize: 6,
        //                 ),
        //                 maxLines: 1,
        //                 overflow: TextOverflow.ellipsis,
        //               ),
        //             ],
        //           ),
        //         ],
        //       ),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
