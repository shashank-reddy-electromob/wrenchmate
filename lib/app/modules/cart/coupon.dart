import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wrenchmate_user_app/app/controllers/cart_controller.dart';
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
  final CartController cartController = Get.find<CartController>();

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

  Future<List<Map<String, dynamic>>> _fetchCoupons() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('Coupon').get();
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchCoupons(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No Coupons Available'));
          } else {
            final coupons = snapshot.data!;
            return SingleChildScrollView(
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
                                  print(
                                      "Coupon code applied: ${_controller.text}");
                                }
                              : null,
                          child: Text(
                            'Apply',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color:
                                  _isButtonEnabled ? Colors.blue : Colors.grey,
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
                      'Available Coupons',
                      style: TextStyle(
                        color: Color(0xff5D5D5D),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 12),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: coupons.length,
                      itemBuilder: (context, index) {
                        final coupon = coupons[index];
                        return CouponCard(
                          color: primaryColor,
                          code: coupon['name'] ?? 'N/A',
                          discount: 'Save up to ${coupon['price']}',
                          description: coupon['description'] ??
                              'No Description Available',
                          onApply: () {
                            String couponCode = coupon['name'];
                            if (couponCode.isNotEmpty) {
                              cartController.applyCoupon(
                                  couponCode, coupon['price']);
                            } else {
                              Get.snackbar("Invalid Input",
                                  "Please enter a valid coupon code");
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        },
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
