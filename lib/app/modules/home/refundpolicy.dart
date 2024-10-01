import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/blueButton.dart';

class refundPolicy extends StatefulWidget {
  const refundPolicy({super.key});

  @override
  State<refundPolicy> createState() => _refundPolicyState();
}

class _refundPolicyState extends State<refundPolicy> {
  final ScrollController _scrollController = ScrollController();
  bool _isAtBottom = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent) {
      setState(() {
        _isAtBottom = true;
      });
    } else if (_scrollController.offset <=
        _scrollController.position.minScrollExtent) {
      setState(() {
        _isAtBottom = false;
      });
    }
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0.0,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  _openEmail() async {
    const email = 'mailto:contact@wrenchmate.in';
    await launch(email);
  }

  _openDialer() async {
    const phoneNumber = 'tel:7386565050';
    await launch(phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Refund policy',
          style: TextStyle(
              fontFamily: 'Raleway', fontWeight: FontWeight.w500, fontSize: 20),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xffF6F6F5),
              borderRadius: BorderRadius.circular(30),
            ),
            child: IconButton(
              icon: Icon(
                CupertinoIcons.back,
                color: Color(0xff1E1E1E),
                size: 22,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'At Wrench Mate, we are committed to providing high-quality car care services. If you are not entirely satisfied with your service, we\'re here to help. Please review our refund policy below:',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Color(0xff494949),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '1. Service Cancellations',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff494949),
                      fontSize: 20,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: 8),
                Text(
                  '''
Cancellations before service commencement: If you wish to cancel a service before it has started, you may do so free of charge up to 24 hours before the scheduled appointment. Refunds will be processed within 5-7 business days.
Late cancellations: For cancellations made less than 24 hours prior to the service, a 15% service charge will be deducted from the refund.''',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Color(0xff494949),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '2. Service Dissatisfaction',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff494949),
                      fontSize: 20,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: 8),
                Text(
                  '''If you are not satisfied with the quality of service, please contact our customer support team within 24 hours of service completion. We will review your case and, if applicable, either:
Re-perform the service at no extra cost, or
Issue a partial or full refund depending on the nature of the issue.
Refunds for service dissatisfaction are granted at the discretion of our quality assurance team and may take 7-10 business days to process.''',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Color(0xff494949),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '3. Refund Process',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff494949),
                      fontSize: 20,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: 8),
                Text(
                  '''Refunds are made to the original payment method. If your payment was made via credit or debit card, refunds will be reflected in your bank account within 5-10 business days.
For payments made via UPI or wallet transactions, refunds will be credited within 3-5 business days.''',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Color(0xff494949),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '4. Non-Refundable Services',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff494949),
                      fontSize: 20,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: 8),
                Text(
                  '''No refund is provided for completed services unless there is a valid issue with service quality.
Services that fall under special offers or discounts are non-refundable.''',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Color(0xff494949),
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(height: 16),
                Text(
                  '5. Contact Us',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff494949),
                      fontSize: 20,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: 8),
                Text(
                  '''If you have any questions about our refund policy or wish to initiate a refund request, please contact us at:''',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Color(0xff494949),
                  ),
                ),
                SizedBox(height: 16),
                // SizedBox(height: 24),
                GestureDetector(
                  onTap: _openEmail,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Email: ',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            color: Color(0xff494949),
                          ),
                        ),
                        TextSpan(
                          text: 'contact@wrenchmate.in',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            color: Colors.blue, // Blue color for the email
                            decoration: TextDecoration
                                .underline, // Underline for the email
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _openDialer,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Phone: ',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            color: Color(0xff494949),
                          ),
                        ),
                        TextSpan(
                          text: '7386565050',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            color:
                                Colors.blue, // Blue color for the phone number
                            decoration: TextDecoration
                                .underline, // Underline for the phone number
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // SizedBox(height: 16),
                // //accept
                // Align(
                //     alignment: Alignment.center,
                //     child: blueButton(
                //       text: 'ACCEPT',
                //       fontSize: 16,
                //       onTap: () {},
                //     )),
                SizedBox(height: 90)
              ],
            ),
          ),
          //swiping buttons
          Positioned(
              bottom: 20,
              child: Container(
                width: MediaQuery.of(context).size.width - 40,
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 15,
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _isAtBottom ? _scrollToTop : _scrollToBottom,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 4),
                    child: Text(
                      _isAtBottom ? 'Scroll to Top' : 'Scroll to Bottom',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          fontFamily: 'Raleway'),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.blue, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          18.0), // Adjust the radius to make it more rectangular
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }
}
