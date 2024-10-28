import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/blueButton.dart';

class termsAndConditions extends StatefulWidget {
  const termsAndConditions({super.key});

  @override
  State<termsAndConditions> createState() => _termsAndConditionsState();
}

class _termsAndConditionsState extends State<termsAndConditions> {
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
    const phoneNumber = 'tel:+91-7386565050';
    await launch(phoneNumber);
  }

  String address = "Janaki nagar, langer house, Hyderabad, Telangana, India";

  Future<void> _openMap() async {
    final Uri googleMapsUrl =
        Uri.parse("https://www.google.com/maps/search/?api=1&query=$address");

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl);
    } else {
      throw 'Could not open the map for the address: $address';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Terms & Condition',
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
                  'Wrench Mate - Terms and Conditions\n',
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      color: Color(0xff494949),
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  'Effective Date: 01-10-24\n',
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      color: Color(0xff494949),
                      fontWeight: FontWeight.w500),
                ),

                Text(
                  'Welcome to Wrench Mate! These terms and conditions ("Terms") govern your use of the Wrench Mate mobile application (the “App”) and services provided through it. By downloading, accessing, or using the App, you agree to these Terms. Please read them carefully before using the App.',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Color(0xff494949),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '1. Eligibility',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff494949),
                      fontSize: 20,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: 8),
                Text(
                  '''You must be at least 18 years old and legally capable of entering into a binding contract as per Indian laws to use the Wrench Mate app. If you are under 18, you may use the App only under the supervision of a parent or legal guardian.''',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Color(0xff494949),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '2. Services Provided',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff494949),
                      fontSize: 20,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: 8),
                Text(
                  '''Wrench Mate provides a platform where users can book automotive services, including car washing, detailing, repairs, and accessory purchases through third-party service providers. We act as a facilitator and do not directly provide these services.''',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Color(0xff494949),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '3. Account Registration',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff494949),
                      fontSize: 20,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: 8),
                Text(
                  '''To use our services, you must register and maintain an account with accurate, complete, and up-to-date information. You are responsible for safeguarding your account credentials and for all activity conducted under your account.''',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Color(0xff494949),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '4. Booking and Payments',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff494949),
                      fontSize: 20,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: 8),
                Text(
                  '''Users can book services via the App and must make payments electronically, including credit/debit cards, UPI, or other authorized methods. All payments are in Indian Rupees (INR).
You agree to pay for all services booked through the App, including applicable taxes.
Cancellations and refunds are subject to our Cancellation Policy.''',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Color(0xff494949),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '5. Cancellation and Refunds',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff494949),
                      fontSize: 20,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: 8),
                Text(
                  '''You can cancel a service booking up to 24 hours before the scheduled time for a full refund.
Cancellations made within 24 hours of the service time may incur charges.
Refunds will be processed within [X] business days.''',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Color(0xff494949),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '6. User Responsibilities',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff494949),
                      fontSize: 20,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: 8),
                Text(
                  '''By using the App, you agree:

Not to engage in fraudulent activities.
To provide accurate information and refrain from using the App for unlawful purposes.
To respect intellectual property rights and not misuse Wrench Mate content or services.''',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Color(0xff494949),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '7. Pricing and Promotions',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff494949),
                      fontSize: 20,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: 8),
                Text(
                  '''Service pricing is listed within the App, and prices are subject to change. Promotional offers may be available from time to time, and their terms are subject to specific conditions.''',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Color(0xff494949),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '8. Third-Party Services',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff494949),
                      fontSize: 20,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: 8),
                Text(
                  '''Wrench Mate partners with independent third-party service providers. We are not responsible for their actions, service quality, or damages arising during the service process. Users are encouraged to directly address any issues related to service quality with the respective provider.''',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Color(0xff494949),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '9. Limitation of Liability',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff494949),
                      fontSize: 20,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: 8),
                Text(
                  '''Wrench Mate is not liable for any indirect, incidental, or consequential damages related to the use of the App, including but not limited to delays in service, errors, or issues with third-party service providers. Our liability is limited to the value of the services booked.''',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Color(0xff494949),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '10. Termination of Account',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff494949),
                      fontSize: 20,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: 8),
                Text(
                  '''We may suspend or terminate your account if you breach these Terms, misuse the App, or engage in unlawful activities. You may close your account at any time by contacting us.''',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Color(0xff494949),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '11. Privacy',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff494949),
                      fontSize: 20,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: 8),
                Text(
                  '''Wrench Mate is committed to protecting your privacy. We collect and use your personal data in accordance with our Privacy Policy, which complies with Indian data protection laws.''',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Color(0xff494949),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '12. Modifications',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff494949),
                      fontSize: 20,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: 8),
                Text(
                  '''Wrench Mate reserves the right to modify these Terms at any time. Users will be notified of any significant changes, and continued use of the App after changes are made constitutes acceptance of the revised Terms.''',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Color(0xff494949),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '13. Dispute Resolution',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff494949),
                      fontSize: 20,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: 8),
                Text(
                  '''Any disputes arising from these Terms or the services provided will be governed by Indian law. All disputes will be subject to the exclusive jurisdiction of the courts in Hyderabad, Telangana.''',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Color(0xff494949),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '14. Governing Law',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff494949),
                      fontSize: 20,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: 8),
                Text(
                  '''These Terms are governed by and construed in accordance with the laws of India.''',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Color(0xff494949),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '15. Contact Information',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff494949),
                      fontSize: 20,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: 8),
                Text(
                  '''For support or questions related to these Terms, you may contact us at:

Wrench Mate Pvt. Ltd.''',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Color(0xff494949),
                  ),
                ),
                GestureDetector(
                  onTap: _openEmail,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'By email: ',
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
                          text: '+91-7386565050',
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
                GestureDetector(
                  onTap: _openMap,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Address: ',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            color: Color(0xff494949),
                          ),
                        ),
                        TextSpan(
                          text: '$address',
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
                SizedBox(
                  height: 10,
                ),
                Text(
                  '''By using Wrench Mate, you confirm that you have read and agree to these Terms and Conditions. If you do not agree, please refrain from using our services.''',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Color(0xff494949),
                  ),
                ),
                SizedBox(height: 24),
                //accept
                Align(
                    alignment: Alignment.center,
                    child: BlueButton(
                      text: 'ACCEPT',
                      fontSize: 16,
                      onTap: () {},
                    )),
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
                        horizontal: 18.0, vertical: 4),
                    child: Text(
                      _isAtBottom ? 'Scroll to Top' : 'Scroll to Bottom',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          fontFamily: 'Raleway'),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
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
