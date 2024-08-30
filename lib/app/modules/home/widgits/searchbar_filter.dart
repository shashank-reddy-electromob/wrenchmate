import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:get/get.dart';
import 'package:wrenchmate_user_app/app/controllers/searchcontroller.dart';
import 'package:wrenchmate_user_app/app/modules/home/searchscreen.dart';
import 'package:wrenchmate_user_app/utils/color.dart';
import 'package:wrenchmate_user_app/utils/textstyles.dart';
import '../../../routes/app_routes.dart';

class searchbar extends StatefulWidget {
  final bool showFilter;
  const searchbar({super.key, this.showFilter = true});

  @override
  State<searchbar> createState() => _searchbarState();
}

class _searchbarState extends State<searchbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.showFilter
          ? EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05)
          : EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              width: MediaQuery.of(context).size.width * 0.75,
              height: 50,
              color: Color(0xffF7F7F7),
              child: Center(
                child: TextField(
                  onTap: () async {
                    print("AppRoutes.SEARCHSCREEN");
                    Get.toNamed(AppRoutes.SEARCHSCREEN);
                  },
                  decoration: InputDecoration(
                    hintText: "Search services and packages",
                    hintStyle: AppTextStyle.mediumRaleway12,
                    prefixIcon: Icon(Icons.search, color: Color(0xff838383)),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              )),
          //filter
          if (widget.showFilter)
            CustomIconButton(
              icon: Icon(
                Icons.filter_list,
                color: Colors.white,
                size: 24,
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return BottomSheet();
                  },
                );
              },
            ),
        ],
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final Icon icon;
  final VoidCallback onPressed;

  CustomIconButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xff3B7FFF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: IconButton(
        icon: icon,
        onPressed: onPressed,
      ),
    );
  }
}

class BottomSheet extends StatefulWidget {
  @override
  State<BottomSheet> createState() => _BottomSheetState();
}

class _BottomSheetState extends State<BottomSheet> {
  final SearchControllerClass searchController =
      Get.put(SearchControllerClass());
  void onApplyFilters(
    List<String> selectedServices,
    String selectedDiscount,
    String selectedRating,
    double minPrice,
    double maxPrice,
  ) async {
    print("onApplyFilters called");
    await searchController.fetchFilteredSearchResults(
      selectedServices: selectedServices,
      selectedDiscount: selectedDiscount,
      selectedRating: selectedRating,
      minPrice: minPrice,
      maxPrice: maxPrice,
    );

    Get.toNamed('/filteredResults');
  }

  List<String> selectedServices = [];
  String selectedDiscount = '';
  String selectedRating = '';
  double minPrice = 0;
  double maxPrice = double.infinity;

  List<String> services = [
    "Car Wash",
    "Detailing",
    "Repair",
    "Wheel Service",
    "Accessories",
    "Denting and Painting",
  ];
  List<String> discounts = [
    '0-15%',
    '16-35%',
    '36-50%',
  ];
  List<String> ratings = [
    '>⭐4.0',
    '>⭐3.0',
    '>⭐2.0',
    '>⭐1.0',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 8),
            Container(
              height: 6,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            SizedBox(height: 16),
            RangeSliderWidget(
                // onRangeChanged: (min, max) {
                //   setState(() {
                //     minPrice = min;
                //     maxPrice = max;
                //   });
                // },
                ),
            SizedBox(height: 16),
            _buildServiceTypes(),
            SizedBox(height: 16),
            _buildDiscountTypes(),
            SizedBox(height: 16),
            _buildRatingTypes(),
            SizedBox(height: 32),
            _buildClearAllApplyButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceTypes() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Service Type",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: services.map((service) {
              bool isSelected = selectedServices.contains(service);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedServices.remove(service);
                    } else {
                      selectedServices.add(service);
                    }
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  decoration: BoxDecoration(
                    color: isSelected ? primaryColorLight : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    service,
                    style: TextStyle(
                        color: isSelected ? primaryColor : greyColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountTypes() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Discount",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: discounts.map((discount) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDiscount = discount;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  decoration: BoxDecoration(
                    color: selectedDiscount == discount
                        ? primaryColorLight
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    discount,
                    style: TextStyle(
                        color: selectedDiscount == discount
                            ? primaryColor
                            : greyColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingTypes() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Rating",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: ratings.map((rating) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedRating = rating;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  decoration: BoxDecoration(
                    color: selectedRating == rating
                        ? primaryColorLight
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    rating,
                    style: TextStyle(
                        color:
                            selectedRating == rating ? primaryColor : greyColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildClearAllApplyButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
                side: BorderSide(color: Colors.blue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                minimumSize: Size(double.infinity, 60),
              ),
              onPressed: () {
                setState(() {
                  selectedRating = '';
                  selectedDiscount = '';
                  selectedServices = [];
                  minPrice = 0;
                  maxPrice = double.infinity;
                });
                Navigator.of(context).pop();
              },
              child: Text(
                "CLEAR ALL",
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                minimumSize: Size(double.infinity, 60),
              ),
              onPressed: () {
                onApplyFilters(
                  selectedServices,
                  selectedDiscount,
                  selectedRating,
                  minPrice,
                  maxPrice,
                );
                // Navigator.of(context).push(
                // MaterialPageRoute(
                //   builder: (context) => SearchPage(
                //       // filters: {
                //       //   'selectedServices': selectedServices,
                //       //   'selectedDiscount': selectedDiscount,
                //       //   'selectedRating': selectedRating,
                //       //   'minPrice': minPrice,
                //       //   'maxPrice': maxPrice,
                //       // },
                //       ),
                // ),
                // );
              },
              child: Text(
                "APPLY",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RangeSliderWidget extends StatefulWidget {
  @override
  _RangeSliderWidgetState createState() => _RangeSliderWidgetState();
}

class _RangeSliderWidgetState extends State<RangeSliderWidget> {
  double _lowerValue = 1299;
  double _upperValue = 3999;
  List<int> itemCounts = [
    80,
    10,
    20,
    60,
    70,
    100,
    30,
    40,
    90,
    50,
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            height: 100,
            width: 300,
            child: CustomPaint(
              painter: BarChartPainter(itemCounts),
            ),
          ),
          FlutterSlider(
            values: [_lowerValue, _upperValue],
            rangeSlider: true,
            max: 5000,
            min: 120,
            onDragging: (handlerIndex, lowerValue, upperValue) {
              setState(() {
                _lowerValue = lowerValue;
                _upperValue = upperValue;
              });
            },
            handler: FlutterSliderHandler(
              decoration: BoxDecoration(),
              child: Material(
                type: MaterialType.circle,
                color: primaryColor,
                elevation: 0,
                child: Container(
                  width: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            rightHandler: FlutterSliderHandler(
              decoration: BoxDecoration(),
              child: Material(
                type: MaterialType.circle,
                color: primaryColor,
                elevation: 3,
                child: Container(
                  width: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            trackBar: FlutterSliderTrackBar(
              activeTrackBar: BoxDecoration(
                color: primaryColor.withOpacity(0.5),
              ),
            ),
            tooltip: FlutterSliderTooltip(
              positionOffset: FlutterSliderTooltipPositionOffset(
                top: 50,
              ),
              leftPrefix: Container(
                child: Text(
                  '₹ ',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                ),
              ),
              rightPrefix: Container(
                child: Text(
                  '₹ ',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                ),
              ),
              alwaysShowTooltip: true,
              custom: (value) {
                return Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '₹ ${value.toInt()}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       '₹ ${_lowerValue.toInt()}',
          //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          //     ),
          //     Text(
          //       '₹ ${_upperValue.toInt()}',
          //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}

class BarChartPainter extends CustomPainter {
  final List<int> itemCounts;

  BarChartPainter(this.itemCounts);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primaryColor.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    double barWidth = 300 / itemCounts.length;
    for (int i = 0; i < itemCounts.length; i++) {
      double barHeight = (itemCounts[i] / 100) * size.height;
      canvas.drawRect(
        Rect.fromLTWH(
            i * barWidth, size.height - barHeight, barWidth, barHeight),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
