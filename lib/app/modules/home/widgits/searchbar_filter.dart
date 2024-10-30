import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:get/get.dart';
import 'package:wrenchmate_user_app/utils/color.dart';
import 'package:wrenchmate_user_app/utils/textstyles.dart';
import '../../../routes/app_routes.dart';

class searchbar extends StatefulWidget {
  final bool showFilter;
  final bool readonly;

  const searchbar({super.key, this.showFilter = true, this.readonly = false});

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
              decoration: BoxDecoration(
                color: Color(0xffF7F7F7),
                borderRadius: BorderRadius.circular(10), // Rounded corners
                border: Border.all(
                  color: Color(0xffF7F7F7), // Border color
                  width: 1.0, // Border width
                ),
              ),
              width: MediaQuery.of(context).size.width * 0.75,
              height: 50,
              child: Center(
                child: TextField(
                  readOnly: widget.readonly,
                  onTap: () async {
                    if (widget.readonly) {
                      print("AppRoutes.SEARCHSCREEN");
                      Get.toNamed(AppRoutes.SEARCHSCREEN);
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    }
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
  final VoidCallback onPressed;

  CustomIconButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color(0xff3B7FFF),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Image.asset(
          width: 28,
          'assets/icons/IC_Filter.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class BottomSheet extends StatefulWidget {
  @override
  State<BottomSheet> createState() => _BottomSheetState();
}

class _BottomSheetState extends State<BottomSheet> {
  void onApplyFilters(
    List<String> selectedServices,
    String selectedDiscount,
    String selectedRating,
    double minPrice,
    double maxPrice,
  ) async {
    print("onApplyFilters called");
    print(selectedServices);
    print(selectedDiscount);
    print(selectedRating);
    print(minPrice);
    print(maxPrice);

    Get.toNamed(AppRoutes.SEARCHSCREEN, arguments: {
      'selectedServices': selectedServices,
      'selectedDiscount': selectedDiscount,
      'selectedRating': selectedRating,
      'minPrice': minPrice,
      'maxPrice': maxPrice,
    });
  }

  List<String> selectedServices = [];
  String selectedDiscount = '';
  String selectedRating = '';
  double minPrice = 0;
  double maxPrice = 100000;

  List<String> services = [
    "Car Wash",
    "Detailing",
    "Repair",
    "Wheel",
    "Painting",
    "Denting",
  ];
  List<String> discounts = [
    '0-15%',
    '16-35%',
    '36-50%',
  ];
  List<String> ratings = [
    '>⭐4.0',
    '⭐3.0',
    '⭐2.0',
    '⭐1.0',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height * 0.85,
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
            // SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RangeSliderWidget(
                  onRangeChanged: (min, max) {
                    setState(() {
                      minPrice = min;
                      maxPrice = max;
                    });
                  },
                ),
                _buildServiceTypes(),
                SizedBox(height: 8),
                _buildDiscountTypes(),
                SizedBox(height: 8),
                _buildRatingTypes(),
                SizedBox(height: 8),
                _buildClearAllApplyButtons(),
              ],
            ),
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
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  decoration: BoxDecoration(
                    color: isSelected ? primaryColorLight : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    service,
                    style: TextStyle(
                        color: isSelected ? primaryColor : greyColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
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
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
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
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
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
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
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
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
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
                  borderRadius: BorderRadius.circular(12.0),
                ),
                minimumSize: Size(double.infinity, 50),
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
                  borderRadius: BorderRadius.circular(12.0),
                ),
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () {
                onApplyFilters(
                  selectedServices,
                  selectedDiscount,
                  selectedRating,
                  minPrice,
                  maxPrice,
                );
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
  final Function(double, double) onRangeChanged;

  RangeSliderWidget({required this.onRangeChanged});

  @override
  _RangeSliderWidgetState createState() => _RangeSliderWidgetState();
}

class _RangeSliderWidgetState extends State<RangeSliderWidget> {
  double _lowerValue = 20000;
  double _upperValue = 80000;
  List<double> barHeights = [];
  final double totalMin = 500;
  final double totalMax = 100000;

  @override
  void initState() {
    super.initState();
    _generateBars();
  }

  void _generateBars() {
    final range = _upperValue - _lowerValue;
    int numberOfBars = (range / 2500).round().clamp(3, 15);

    barHeights = List.generate(numberOfBars, (index) {
      return 0.2 + (Random().nextDouble() * 0.8);
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            height: 80,
            width: double.infinity,
            padding: EdgeInsets.only(left: 10, right: 10),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return CustomPaint(
                  size: Size(constraints.maxWidth, constraints.maxHeight),
                  painter: RangeBarChartPainter(
                    barHeights: barHeights,
                    lowerValue: _lowerValue,
                    upperValue: _upperValue,
                    totalMin: totalMin,
                    totalMax: totalMax,
                    primaryColor: primaryColor,
                  ),
                );
              },
            ),
          ),
          Container(
            height: 20,
            child: FlutterSlider(
              values: [_lowerValue, _upperValue],
              rangeSlider: true,
              step: FlutterSliderStep(
                step: 500,
              ),
              max: totalMax,
              min: totalMin,
              onDragging: (handlerIndex, lowerValue, upperValue) {
                setState(() {
                  _lowerValue = lowerValue;
                  _upperValue = upperValue;
                  _generateBars();
                });
                widget.onRangeChanged(lowerValue, upperValue);
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
                  top: 40,
                ),
                leftPrefix: Container(
                  child: Text(
                    '₹ ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                  ),
                ),
                rightPrefix: Container(
                  child: Text(
                    '₹ ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                  ),
                ),
                alwaysShowTooltip: true,
                custom: (value) {
                  return Container(
                    height: 40,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '₹ ${value.toInt()}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }
}

class RangeBarChartPainter extends CustomPainter {
  final List<double> barHeights;
  final double lowerValue;
  final double upperValue;
  final double totalMin;
  final double totalMax;
  final Color primaryColor;

  RangeBarChartPainter({
    required this.barHeights,
    required this.lowerValue,
    required this.upperValue,
    required this.totalMin,
    required this.totalMax,
    required this.primaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primaryColor.withOpacity(0.1)
      ..style = PaintingStyle.fill;
    double totalWidth = size.width;
    double startX =
        (lowerValue - totalMin) / (totalMax - totalMin) * totalWidth;
    double endX = (upperValue - totalMin) / (totalMax - totalMin) * totalWidth;
    double availableWidth = endX - startX;
    print(availableWidth);
    double barWidth = (availableWidth / barHeights.length) * 1;
    double barSpacing = (availableWidth / barHeights.length) * 0;

    for (int i = 0; i < barHeights.length; i++) {
      double barHeight = barHeights[i] * size.height;
      double barX = startX + (i * (barWidth + barSpacing));

      canvas.drawRect(
        Rect.fromLTWH(
          barX,
          size.height - barHeight,
          barWidth,
          barHeight,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(RangeBarChartPainter oldDelegate) {
    return oldDelegate.barHeights != barHeights ||
        oldDelegate.lowerValue != lowerValue ||
        oldDelegate.upperValue != upperValue;
  }
}
