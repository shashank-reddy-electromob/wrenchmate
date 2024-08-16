import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

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
                  decoration: InputDecoration(
                    hintText: "Search services and packages",
                    hintStyle:
                        TextStyle(color: Color(0xff858585), fontSize: 16),
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
  List<String> selectedServices = [];
  String selecteddiscount = '';
  String selectedrating = '';

  List<String> services = [
    "Car Wash",
    "Detailing",
    "Repair",
    "Wheel",
    "Painting",
    "Denting",
  ];
  List<String> discount = [
    '0-15%',
    '16-35%',
    '36-50%',
  ];
  List<String> rating = [
    '>⭐4.0',
    '>⭐3.0',
    '>⭐2.0',
    '>⭐1.0',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 6,
            margin: EdgeInsets.only(top: 8),
            width: 80,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          RangeSliderWidget(),
          servicetypes(),
          discounttypes(),
          ratingtypes(),
          clearallApply()
        ],
      ),
    );
  }

  Widget servicetypes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Service Type",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
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
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  service,
                  style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontSize: 18),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget discounttypes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Discount",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: discount.map((discount) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selecteddiscount = discount;
                });
                print(discount);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                decoration: BoxDecoration(
                  color: selecteddiscount == discount
                      ? Colors.blue
                      : Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  discount,
                  style: TextStyle(
                      color: selecteddiscount == discount
                          ? Colors.white
                          : Colors.black,
                      fontSize: 18),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget ratingtypes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Rating",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: rating.map((rating) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedrating = rating;
                });
                print(rating);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                decoration: BoxDecoration(
                  color:
                      selectedrating == rating ? Colors.blue : Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  rating,
                  style: TextStyle(
                      color: selectedrating == rating
                          ? Colors.white
                          : Colors.black,
                      fontSize: 18),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget clearallApply() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.45,
          height: 70,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.blue,
              backgroundColor: Colors.white, // Text color
              side: BorderSide(color: Colors.blue), // Border color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onPressed: () {
              selectedrating = '';
              selecteddiscount = '';
              selectedServices = [];
              Navigator.of(context).pop();
            },
            child: Text(
              'CLEAR ALL',
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
          ),
        ),
        SizedBox(width: 10), // Space between buttons
        Container(
          width: MediaQuery.of(context).size.width * 0.45,
          height: 70,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue, // Text color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onPressed: () {
              // apply functionality here
              print(selectedServices);
              print(selecteddiscount);
              print(selectedrating);
              Navigator.of(context).pop();
            },
            child: Text('APPLY'),
          ),
        ),
      ],
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
                color: Colors.blue,
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
                color: Colors.blue,
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
              activeTrackBar:
                  BoxDecoration(color: Colors.blue.withOpacity(0.5)),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '₹ ${_lowerValue.toInt()}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                '₹ ${_upperValue.toInt()}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          //depends on UI
          // FlutterSlider(
          //   values: [_lowerValue, _upperValue],
          //   rangeSlider: true,
          //   max: 5000,
          //   min: 120,
          //   onDragging: (handlerIndex, lowerValue, upperValue) {
          //     setState(() {
          //       _lowerValue = lowerValue;
          //       _upperValue = upperValue;
          //     });
          //   },
          //   handler: FlutterSliderHandler(
          //     decoration: BoxDecoration(),
          //     child: Material(
          //       type: MaterialType.circle,
          //       color: Colors.blue,
          //       elevation: 0,
          //       child: Container(
          //         width: 20,
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(30),
          //         ),
          //       ),
          //     ),
          //   ),
          //   rightHandler: FlutterSliderHandler(
          //     decoration: BoxDecoration(),
          //     child: Material(
          //       type: MaterialType.circle,
          //       color: Colors.blue,
          //       elevation: 3,
          //       child: Container(
          //         width: 20,
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(30),
          //         ),
          //       ),
          //     ),
          //   ),
          //   trackBar: FlutterSliderTrackBar(
          //     activeTrackBar: BoxDecoration(color: Colors.blue.withOpacity(0.5)),
          //   ),
          //   tooltip: FlutterSliderTooltip(
          //     leftPrefix: Container(
          //       child: Text(
          //         '₹ ',
          //         style: TextStyle(fontSize: 17, fontWeight: FontWeight.w300, color: Colors.white),
          //       ),
          //     ),
          //     rightPrefix: Container(
          //       child: Text(
          //         '₹ ',
          //         style: TextStyle(fontSize: 17, fontWeight: FontWeight.w300, color: Colors.white),
          //       ),
          //     ),
          //     alwaysShowTooltip: true,
          //     custom: (value) {
          //       return Container(
          //         padding: EdgeInsets.all(8),
          //         decoration: BoxDecoration(
          //           color: Colors.blue,
          //           borderRadius: BorderRadius.circular(5),
          //         ),
          //         child: Text(
          //           '₹ ${value.toInt()}',
          //           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          //         ),
          //       );
          //     },
          //   ),
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
      ..color = Colors.blue.withOpacity(0.5)
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
