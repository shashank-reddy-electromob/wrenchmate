import 'package:flutter/material.dart';
import 'package:wrenchmate_user_app/app/widgets/appbar.dart';
import 'package:wrenchmate_user_app/utils/color.dart';

class ApplyCouponScreen extends StatefulWidget {
  const ApplyCouponScreen({super.key});

  @override
  State<ApplyCouponScreen> createState() => _ApplyCouponScreenState();
}

class _ApplyCouponScreenState extends State<ApplyCouponScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _isButtonEnabled = _controller.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Apply Coupon',
        onBackButtonPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Enter Coupon Code',
                  hintStyle: TextStyle(fontFamily: 'Poppins'),
                  suffixIcon: TextButton(
                    onPressed: _isButtonEnabled
                        ? () {
                            // Handle apply coupon code logic here
                            print("Coupon code applied: ${_controller.text}");
                          }
                        : null, // Disable the button when the text is empty
                    child: Text(
                      'Apply',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: _isButtonEnabled
                            ? Colors.blue // Enabled color
                            : Colors.grey, // Disabled color
                      ),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Best Coupon',
                style: TextStyle(
                  color: Color(0xff5D5D5D),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 12),
              CouponCard(
                color: Colors.blue,
                code: 'WM023',
                discount: 'Save upto 40%',
                description:
                    'Lorem ipsum dolor sit amet consectetur. Tristique ridiculus nulla eget eget ac risus arcu natoque.',
                onApply: () {},
              ),
              SizedBox(height: 24),
              Text(
                'More Offers',
                style: TextStyle(
                  color: Color(0xff5D5D5D),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 12),
              ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  CouponCard(
                    color: Colors.grey.shade300,
                    code: 'WM023',
                    discount: 'Save upto 40%',
                    description:
                        'Lorem ipsum dolor sit amet consectetur. Tristique ridiculus nulla eget eget ac risus arcu natoque.',
                    onApply: () {
                      // Handle apply more offer
                    },
                  ),
                  CouponCard(
                    color: Colors.grey.shade300,
                    code: 'WM023',
                    discount: 'Save upto 40%',
                    description:
                        'Lorem ipsum dolor sit amet consectetur. Tristique ridiculus nulla eget eget ac risus arcu natoque.',
                    onApply: () {
                      // Handle apply more offer
                    },
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

class CouponCard extends StatelessWidget {
  final Color color;
  final String code;
  final String discount;
  final String description;
  final VoidCallback onApply;

  const CouponCard({
    required this.color,
    required this.code,
    required this.discount,
    required this.description,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 80,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        code,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      TextButton(
                        onPressed: onApply,
                        child: Text(
                          'Apply',
                          style: TextStyle(
                            color: Color(0xff3371FF),
                            fontSize: 14,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    discount,
                    style: TextStyle(
                        color: Color(0xff4CD964),
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 4),
                  Divider(),
                  Text(
                    description,
                    style: TextStyle(
                      color: textgrey,
                      fontFamily: 'Poppins',
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
