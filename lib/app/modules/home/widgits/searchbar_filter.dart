import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

class searchbar extends StatefulWidget {
  const searchbar({super.key});

  @override
  State<searchbar> createState() => _searchbarState();
}

class _searchbarState extends State<searchbar> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.05),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(width: MediaQuery.of(context).size.width*0.75,height:50,
            color: Color(0xffF7F7F7),
            child: Center(
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search services and packages",
                  hintStyle: TextStyle(color: Color(0xff858585),fontSize: 16),
                  prefixIcon: Icon(Icons.search, color: Color(0xff838383)),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            )
          ),
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
                  return Container(
                    height: MediaQuery.of(context).size.height*0.85,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.center,
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

                      ]
                    ),
                  );
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

class RangeSliderWidget extends StatefulWidget {
  @override
  _RangeSliderWidgetState createState() => _RangeSliderWidgetState();
}

class _RangeSliderWidgetState extends State<RangeSliderWidget> {
  double _lowerValue = 1299;
  double _upperValue = 3999;
  List<int> itemCounts = [80, 10, 20, 60, 70,  100, 30, 40,90, 50,];

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
                elevation: 3,
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
              activeTrackBar: BoxDecoration(color: Colors.blue.withOpacity(0.5)),
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
        Rect.fromLTWH(i * barWidth, size.height - barHeight, barWidth, barHeight),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}