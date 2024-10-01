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
    const email = 'mailto:ptejeshreddy22@gmail.com';
    await launch(email);
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
                  'Please read these terms and conditions carefully before using Our Service.',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Color(0xff494949),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Interpretation and Definitions',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff494949),
                      fontSize: 20,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: 8),
                Text(
                  '''Interpretation
The words of which the initial letter is capitalized have meanings defined under the following conditions. The following definitions shall have the same meaning regardless of whether they appear in singular or in plural.

Definitions
For the purposes of these Terms and Conditions:

Affiliate: An entity that controls, is controlled by, or is under common control with a party, where "control" means ownership of 50% or more of the shares, equity interest, or other securities entitled to vote for election of directors or other managing authority.
Country: Refers to Telangana, India.
Company: (referred to as either "the Company", "We", "Us", or "Our" in this Agreement) refers to Wrenchmate, Plot no B5, Janaki Nagar, Langer House, Hyderabad-500008.
Device: Any device that can access the Service such as a computer, a cellphone, or a digital tablet.
Service: Refers to the Website.
Terms and Conditions: (also referred to as "Terms") mean these Terms and Conditions that form the entire agreement between You and the Company regarding the use of the Service.
Third-party Social Media Service: Any services or content provided by a third-party that may be displayed, included, or made available by the Service.
Website: Refers to Wrenchmate, accessible from wrenchmate.in.
You: The individual accessing or using the Service, or the company, or other legal entity on behalf of which such individual is accessing or using the Service, as applicable.''',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Color(0xff494949),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Acknowledgment',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff494949),
                      fontSize: 20,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: 8),
                Text(
                  '''These are the Terms and Conditions governing the use of this Service and the agreement that operates between You and the Company. These Terms and Conditions set out the rights and obligations of all users regarding the use of the Service.

Your access to and use of the Service is conditioned on Your acceptance of and compliance with these Terms and Conditions. These Terms and Conditions apply to all visitors, users, and others who access or use the Service.

By accessing or using the Service, You agree to be bound by these Terms and Conditions. If You disagree with any part of these Terms and Conditions, then You may not access the Service.

You represent that you are over the age of 18. The Company does not permit those under 18 to use the Service.

Your access to and use of the Service is also conditioned on Your acceptance of and compliance with the Privacy Policy of the Company. Our Privacy Policy describes Our policies and procedures on the collection, use, and disclosure of Your personal information when You use the Application or the Website and tells You about Your privacy rights and how the law protects You. Please read Our Privacy Policy carefully before using Our Service.''',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Color(0xff494949),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Links to Other Website',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff494949),
                      fontSize: 20,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: 8),
                Text(
                  '''Our Service may contain links to third-party websites or services that are not owned or controlled by the Company.

The Company has no control over, and assumes no responsibility for, the content, privacy policies, or practices of any third-party websites or services. You further acknowledge and agree that the Company shall not be responsible or liable, directly or indirectly, for any damage or loss caused or alleged to be caused by or in connection with the use of or reliance on any such content, goods, or services available on or through any such websites or services.

We strongly advise You to read the terms and conditions and privacy policies of any third-party websites or services that You visit.''',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Color(0xff494949),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Termination',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff494949),
                      fontSize: 20,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: 8),
                Text(
                  '''We may terminate or suspend Your access immediately, without prior notice or liability, for any reason whatsoever, including without limitation if You breach these Terms and Conditions.

Upon termination, Your right to use the Service will cease immediately.''',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Color(0xff494949),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Limitation of Liability',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff494949),
                      fontSize: 20,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: 8),
                Text(
                  '''Notwithstanding any damages that You might incur, the entire liability of the Company and any of its suppliers under any provision of these Terms and Your exclusive remedy for all of the foregoing shall be limited to the amount actually paid by You through the Service or 100 USD if You haven't purchased anything through the Service.

To the maximum extent permitted by applicable law, in no event shall the Company or its suppliers be liable for any special, incidental, indirect, or consequential damages whatsoever (including, but not limited to, damages for loss of profits, loss of data or other information, business interruption, personal injury, or loss of privacy arising out of or in any way related to the use of or inability to use the Service, third-party software and/or third-party hardware used with the Service, or otherwise in connection with any provision of these Terms), even if the Company or any supplier has been advised of the possibility of such damages and even if the remedy fails of its essential purpose.''',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Color(0xff494949),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '"AS IS" and "AS AVAILABLE" Disclaimer',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff494949),
                      fontSize: 20,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: 8),
                Text(
                  '''The Service is provided to You "AS IS" and "AS AVAILABLE" and with all faults and defects without warranty of any kind. To the maximum extent permitted under applicable law, the Company, on its own behalf and on behalf of its Affiliates and its and their respective licensors and service providers, expressly disclaims all warranties, whether express, implied, statutory, or otherwise, with respect to the Service, including all implied warranties of merchantability, fitness for a particular purpose, title and non-infringement, and warranties that may arise out of course of dealing, course of performance, usage, or trade practice. Without limitation to the foregoing, the Company provides no warranty or undertaking, and makes no representation of any kind that the Service will meet Your requirements, achieve any intended results, be compatible or work with any other software, applications, systems or services, operate without interruption, meet any performance or reliability standards or be error-free or that any errors or defects can or will be corrected.''',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Color(0xff494949),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Governing Law',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff494949),
                      fontSize: 20,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: 8),
                Text(
                  '''The laws of the Country, excluding its conflicts of law rules, shall govern these Terms and Your use of the Service. Your use of the Application may also be subject to other local, state, national, or international laws.''',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Color(0xff494949),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Disputes Resolution',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff494949),
                      fontSize: 20,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: 8),
                Text(
                  '''If You have any concern or dispute about the Service, You agree to first try to resolve the dispute informally by contacting the Company.''',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Color(0xff494949),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Severability and Waiver',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff494949),
                      fontSize: 20,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: 8),
                Text(
                  '''Severability
If any provision of these Terms is held to be unenforceable or invalid, such provision will be changed and interpreted to accomplish the objectives of such provision to the greatest extent possible under applicable law and the remaining provisions will continue in full force and effect.

Waiver
Except as provided herein, the failure to exercise a right or to require performance of an obligation under these Terms shall not affect a party's ability to exercise such right or require such performance at any time thereafter, nor shall the waiver of a breach constitute a waiver of any subsequent breach.''',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Color(0xff494949),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Changes to These Terms and Conditions',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff494949),
                      fontSize: 20,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: 8),
                Text(
                  '''We reserve the right, at Our sole discretion, to modify or replace these Terms at any time. If a revision is material, We will make reasonable efforts to provide at least 30 days' notice prior to any new terms taking effect. What constitutes a material change will be determined at Our sole discretion.

By continuing to access or use Our Service after those revisions become effective, You agree to be bound by the revised terms. If You do not agree to the new terms, in whole or in part, please stop using the website and the Service.''',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Color(0xff494949),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Contact Us',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff494949),
                      fontSize: 20,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: 8),
                Text(
                  '''If you have any questions about these Terms and Conditions, You can contact us:''',
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
                          text: 'By Email: ',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            color: Color(0xff494949),
                          ),
                        ),
                        TextSpan(
                          text: 'ptejeshreddy22@gmail.com',
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
                SizedBox(height: 24),
                //accept
                Align(
                    alignment: Alignment.center,
                    child: blueButton(
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
