import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/blueButton.dart';

class privacyPolicy extends StatefulWidget {
  const privacyPolicy({super.key});

  @override
  State<privacyPolicy> createState() => _privacyPolicyState();
}

class _privacyPolicyState extends State<privacyPolicy> {
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
          'Privacy policy',
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
                  'Wrench Mate - Privacy Policy\n',
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
                  '''Wrench Mate ("we", "us", or "our") is committed to protecting your personal information and respecting your privacy. This Privacy Policy explains how we collect, use, share, and protect your personal data when you access and use our mobile application (the "App") and related services. By using Wrench Mate, you agree to the collection and use of your information in accordance with this policy.

We comply with Indian laws, including the Information Technology Act, 2000, and the applicable regulations, including the Personal Data Protection Bill, 2019.''',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Color(0xff494949),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '1. Information We Collect',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff494949),
                      fontSize: 20,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: 8),
                Text(
                  '''When you use the Wrench Mate app, we may collect the following types of information:

1.1 Personal Information
We collect personal information that you voluntarily provide when registering or using the App, including:

Name
Email Address
Phone Number
Vehicle Information (Make, Model, Registration Number)
Payment Details (UPI, Credit/Debit Card Information)
1.2 Location Data
We may collect and process your location data for providing location-based services, such as determining your pickup location and assigning service providers near you.

1.3 Usage Information
We collect information about how you use the App, such as the services you book, your interactions within the App, and other diagnostic data.

1.4 Device Information
We may collect information about your device, including:

Device model
Operating system version
Unique device identifiers
Mobile network information
1.5 Cookies and Tracking Technologies
We use cookies, web beacons, and similar technologies to track your use of the App, improve user experience, and analyze performance.''',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Color(0xff494949),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '2. How We Use Your Information',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff494949),
                      fontSize: 20,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: 8),
                Text(
                  '''Wrench Mate uses the information we collect for the following purposes:

2.1 To Provide Services
Facilitate bookings and process payments for automotive services.
Provide accurate pickup and delivery locations based on your GPS data.
Send service-related notifications (confirmation, reminders, updates).
2.2 To Improve Our Services
Analyze user behavior to improve the App’s functionality and user experience.
Resolve technical issues and respond to customer service requests.
2.3 For Marketing and Promotions
Send you promotional offers, discounts, or updates about new services, subject to your consent.
Customize promotional content based on your preferences and past interactions.
2.4 To Comply with Legal Obligations
Comply with applicable laws, regulations, and legal processes.
Enforce our terms of service and prevent fraud or misuse of the App.''',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Color(0xff494949),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '3. Sharing of Information',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff494949),
                      fontSize: 20,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: 8),
                Text(
                  ''' We do not sell or rent your personal data. However, we may share your information in the following scenarios:

3.1 With Third-Party Service Providers
We share your data with third-party automotive service providers who fulfill your booking requests. These providers need your contact details and vehicle information to perform the requested services.

3.2 With Payment Processors
We share your payment information with secure third-party payment processors to complete transactions.

3.3 With Business Partners
We may share aggregated and anonymized data with business partners to improve our services and offer new features, ensuring that no personal data is disclosed.

3.4 For Legal Reasons
We may disclose your data to comply with legal obligations or respond to government authorities’ requests in cases such as:

Fraud investigations
Regulatory audits
Legal disputes''',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Color(0xff494949),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '4. Data Security',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff494949),
                      fontSize: 20,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: 8),
                Text(
                  '''We are committed to protecting your personal information. We implement appropriate technical and organizational measures, including encryption and secure servers, to protect your data from unauthorized access, alteration, or disclosure.

However, while we take strong precautions, no internet-based service is 100% secure. Therefore, we cannot guarantee the absolute security of your data.''',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Color(0xff494949),
                  ),
                ),
                // SizedBox(height: 16),
                SizedBox(height: 16),
                Text(
                  '5. Data Retention',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff494949),
                      fontSize: 20,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: 8),
                Text(
                  '''We retain your personal data for as long as it is necessary to fulfill the purposes outlined in this Privacy Policy, including:

While you maintain an account with Wrench Mate.
To comply with legal requirements and resolve disputes.
Once data is no longer necessary, we will securely delete or anonymize it.''',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Color(0xff494949),
                  ),
                ),
                // SizedBox(height: 16),
                SizedBox(height: 16),
                Text(
                  '6. Your Rights',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff494949),
                      fontSize: 20,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: 8),
                Text(
                  '''Under Indian data protection laws, you have the following rights:

6.1 Access and Correction
You can access and update your personal information via the App or by contacting us at any time.

6.2 Data Deletion
You can request the deletion of your account and personal information by contacting our support team. Please note that certain information may be retained for legal or operational reasons.

6.3 Withdraw Consent
If you have provided consent for certain data processing activities (e.g., marketing communications), you can withdraw this consent at any time by adjusting your preferences within the App or contacting us.

6.4 Opt-Out of Marketing
You can opt out of receiving marketing communications from us by following the instructions in each promotional message or updating your settings in the App.
''',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Color(0xff494949),
                  ),
                ),
                SizedBox(height: 16),
                // SizedBox(height: 16),
                Text(
                  '7. Third-Party Links',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff494949),
                      fontSize: 20,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: 8),
                Text(
                  '''Our App may contain links to external websites or services operated by third parties. We are not responsible for the privacy practices of these third-party websites or services. We recommend reviewing their privacy policies before sharing any personal information.''',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Color(0xff494949),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '8. Children’s Privacy',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff494949),
                      fontSize: 20,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: 8),
                Text(
                  '''Our services are not directed to individuals under 18 years of age. If we discover that we have inadvertently collected personal data from a minor, we will take steps to delete that information promptly.''',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Color(0xff494949),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '9. Changes to This Privacy Policy',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff494949),
                      fontSize: 20,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: 8),
                Text(
                  '''We may update this Privacy Policy from time to time to reflect changes in our practices or legal obligations. We will notify you of any significant changes through the App or via email. The "Effective Date" at the top of this page indicates when the latest changes were made.''',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Color(0xff494949),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '10. Contact Us',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff494949),
                      fontSize: 20,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: 8),
                Text(
                  '''If you have any questions, concerns, or requests related to this Privacy Policy, please contact us at:

Wrench Mate Pvt. Ltd.
''',
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
                SizedBox(height: 16), // SizedBox(height: 24),
//                 Text(
//                   '''Email: contact@wrenchmate.in
// Phone: 7386565050''',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontFamily: 'Poppins',
//                     color: Color(0xff494949),
//                   ),
//                 ),
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
