import 'package:carousel_slider/carousel_slider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart' hide CarouselController;
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
              height: MediaQuery.of(context).size.height * 0.24,
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
          Container(
            height: MediaQuery.of(context).size.height * 0.24,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: ExtendedImage.network(
            imagePath,
            fit: BoxFit.cover,
          ),
        ));
  }
}
