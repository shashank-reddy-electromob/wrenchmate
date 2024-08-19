import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OnBoarding extends StatefulWidget {
  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);


  final List<String> _pages = [
    'assets/onboarding/iPhoneX.svg','assets/onboarding/iPhoneX2.svg','assets/onboarding/iPhoneX3.svg'
    // OnboardingData(
    //   image: 'assets/onboarding/iPhoneX.svg',
    //   title: 'Create Your Profile',
    //   description:
    //       'Start by setting up your profile to find your ideal roommate and make the most out of Tribzy.',
    // ),
    // OnboardingData(
    //   image: 'assets/onboarding/iPhoneX2.svg',
    //   title: 'Explore Communities',
    //   description:
    //       'Find and join communities that match your interests and lifestyle for a more connected experience.',
    // ),
    // OnboardingData(
    //   image: 'assets/onboarding/iPhoneX3.svg',
    //   title: 'Network at Events',
    //   description:
    //       'Connect with attendees at events and form tribes to collaborate and grow together.',
    // ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // SvgPicture.asset('assets/onboarding/iPhoneX2.svg'),
            PageView.builder(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(28.0),
                          child: SvgPicture.asset(_pages[index]),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: CustomBottomSheet(
                currentPage: _currentPage,
                totalPages: _pages.length,
                onNextPressed: () {
                  if (_currentPage < _pages.length - 1) {
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  } else {}
                },
                onSkipPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomBottomSheet extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onNextPressed;
  final VoidCallback onSkipPressed;

  CustomBottomSheet({
    required this.currentPage,
    required this.totalPages,
    required this.onNextPressed,
    required this.onSkipPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Color(0xFF1976D2),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lorem ipsum dolor sit amet consectetur.',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'In publishing and graphic design, Lorem is a placeholder text commonly used.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: onSkipPressed,
                child: Text(
                  'Skip',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ),
              Row(
                children: List.generate(
                  totalPages,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: CircleAvatar(
                      radius: 4,
                      backgroundColor:
                          index == currentPage ? Colors.white : Colors.white38,
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: onNextPressed,
                child: Text(
                  currentPage == totalPages - 1 ? 'Finish' : 'Next',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OnboardingData {
  final String image;
  final String title;
  final String description;

  OnboardingData({
    required this.image,
    required this.title,
    required this.description,
  });
}
