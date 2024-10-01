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
                  '''This Privacy Policy describes Our policies and procedures on the collection, use and disclosure of Your information when You use the Service and tells You about Your privacy rights and how the law protects You. We use Your Personal data to provide and improve the Service. By using the Service, You agree to the collection and use of information in accordance with this Privacy Policy.''',
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
For the purposes of this Privacy Policy:

Account means a unique account created for You to access our Service or parts of our Service.
Affiliate means an entity that controls, is controlled by or is under common control with a party, where "control" means ownership of 50% or more of the shares, equity interest or other securities entitled to vote for election of directors or other managing authority.
Company (referred to as either "the Company", "We", "Us" or "Our" in this Agreement) refers to Wrench Mate, Plot no B5, Janaki Nagar, Langer House, Hyderabad-500008.
Cookies are small files that are placed on Your computer, mobile device or any other device by a website, containing the details of Your browsing history on that website among its many uses.
Country refers to: Telangana, India
Device means any device that can access the Service such as a computer, a cellphone or a digital tablet.
Personal Data is any information that relates to an identified or identifiable individual.
Service refers to the Website.
Service Provider means any natural or legal person who processes the data on behalf of the Company. It refers to third-party companies or individuals employed by the Company to facilitate the Service, to provide the Service on behalf of the Company, to perform services related to the Service or to assist the Company in analyzing how the Service is used.
Usage Data refers to data collected automatically, either generated by the use of the Service or from the Service infrastructure itself (for example, the duration of a page visit).
Website refers to Wrench Mate, accessible from wrenchmate.in
You means the individual accessing or using the Service, or the company, or other legal entity on behalf of which such individual is accessing or using the Service, as applicable.''',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Color(0xff494949),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Collecting and Using Your Personal Data',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff494949),
                      fontSize: 20,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: 8),
                Text(
                  '''Types of Data Collected
Personal Data
While using Our Service, We may ask You to provide Us with certain personally identifiable information that can be used to contact or identify You. Personally identifiable information may include, but is not limited to:

Email address
First name and last name
Phone number
Address, State, Province, ZIP/Postal code, City
Usage Data
Usage Data
Usage Data is collected automatically when using the Service.

Usage Data may include information such as Your Device's Internet Protocol address (e.g. IP address), browser type, browser version, the pages of our Service that You visit, the time and date of Your visit, the time spent on those pages, unique device identifiers and other diagnostic data.

When You access the Service by or through a mobile device, We may collect certain information automatically, including, but not limited to, the type of mobile device You use, Your mobile device unique ID, the IP address of Your mobile device, Your mobile operating system, the type of mobile Internet browser You use, unique device identifiers and other diagnostic data.

We may also collect information that Your browser sends whenever You visit our Service or when You access the Service by or through a mobile device.

Tracking Technologies and Cookies
We use Cookies and similar tracking technologies to track the activity on Our Service and store certain information. Tracking technologies used are beacons, tags, and scripts to collect and track information and to improve and analyze Our Service. The technologies We use may include:

Cookies or Browser Cookies. A cookie is a small file placed on Your Device. You can instruct Your browser to refuse all Cookies or to indicate when a Cookie is being sent. However, if You do not accept Cookies, You may not be able to use some parts of our Service. Unless you have adjusted Your browser setting so that it will refuse Cookies, our Service may use Cookies.
Web Beacons. Certain sections of our Service and our emails may contain small electronic files known as web beacons (also referred to as clear gifs, pixel tags, and single-pixel gifs) that permit the Company, for example, to count users who have visited those pages or opened an email and for other related website statistics (for example, recording the popularity of a certain section and verifying system and server integrity).
Cookies can be "Persistent" or "Session" Cookies. Persistent Cookies remain on Your personal computer or mobile device when You go offline, while Session Cookies are deleted as soon as You close Your web browser. We use both Session and Persistent Cookies for the purposes set out below:

Necessary / Essential Cookies
Type: Session Cookies
Administered by: Us
Purpose: These Cookies are essential to provide You with services available through the Website and to enable You to use some of its features. They help to authenticate users and prevent fraudulent use of user accounts. Without these Cookies, the services that You have asked for cannot be provided, and We only use these Cookies to provide You with those services.
Cookies Policy / Notice Acceptance Cookies
Type: Persistent Cookies
Administered by: Us
Purpose: These Cookies identify if users have accepted the use of cookies on the Website.
Functionality Cookies
Type: Persistent Cookies
Administered by: Us
Purpose: These Cookies allow us to remember choices You make when You use the Website, such as remembering your login details or language preference. The purpose of these Cookies is to provide You with a more personal experience and to avoid You having to re-enter your preferences every time You use the Website.''',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Color(0xff494949),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Use of Your Personal Data',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff494949),
                      fontSize: 20,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: 8),
                Text(
                  ''' The Company may use Personal Data for the following purposes:

To provide and maintain our Service, including to monitor the usage of our Service.
To manage Your Account: to manage Your registration as a user of the Service. The Personal Data You provide can give You access to different functionalities of the Service that are available to You as a registered user.
For the performance of a contract: the development, compliance and undertaking of the purchase contract for the products, items or services You have purchased or of any other contract with Us through the Service.
To contact You: To contact You by email, telephone calls, SMS, or other equivalent forms of electronic communication, such as a mobile application's push notifications regarding updates or informative communications related to the functionalities, products or contracted services, including the security updates, when necessary or reasonable for their implementation.
To provide You with news, special offers and general information about other goods, services and events which we offer that are similar to those that you have already purchased or enquired about unless You have opted not to receive such information.
To manage Your requests: To attend and manage Your requests to Us.
For business transfers: We may use Your information to evaluate or conduct a merger, divestiture, restructuring, reorganization, dissolution, or other sale or transfer of some or all of Our assets, whether as a going concern or as part of bankruptcy, liquidation, or similar proceeding, in which Personal Data held by Us about our Service users is among the assets transferred.
For other purposes: We may use Your information for other purposes, such as data analysis, identifying usage trends, determining the effectiveness of our promotional campaigns and to evaluate and improve our Service, products, services, marketing and your experience.''',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Color(0xff494949),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Disclosure of Your Personal Data',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff494949),
                      fontSize: 20,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: 8),
                Text(
                  '''We may share Your personal information in the following situations:

With Service Providers: We may share Your personal information with Service Providers to monitor and analyze the use of our Service, to contact You.
For business transfers: We may share or transfer Your personal information in connection with, or during negotiations of, any merger, sale of Company assets, financing, or acquisition of all or a portion of Our business to another company.
With Affiliates: We may share Your information with Our affiliates, in which case we will require those affiliates to honor this Privacy Policy. Affiliates include Our parent company and any other subsidiaries, joint venture partners or other companies that We control or that are under common control with Us.
With business partners: We may share Your information with Our business partners to offer You certain products, services or promotions.
With other users: When You share personal information or otherwise interact in the public areas with other users, such information may be viewed by all users and may be publicly distributed outside.
With Your consent: We may disclose Your personal information for any other purpose with Your consent.''',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Color(0xff494949),
                  ),
                ),
                // SizedBox(height: 16),
                SizedBox(height: 16),
                Text(
                  'Retention of Your Personal Data',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff494949),
                      fontSize: 20,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: 8),
                Text(
                  '''The Company will retain Your Personal Data only for as long as is necessary for the purposes set out in this Privacy Policy. We will retain and use Your Personal Data to the extent necessary to comply with our legal obligations (for example, if we are required to retain your data to comply with applicable laws), resolve disputes, and enforce our legal agreements and policies.

The Company will also retain Usage Data for internal analysis purposes. Usage Data is generally retained for a shorter period of time, except when this data is used to strengthen the security or to improve the functionality of Our Service, or We are legally obligated to retain this data for longer time periods.''',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Color(0xff494949),
                  ),
                ),
                // SizedBox(height: 16),
                SizedBox(height: 16),
                Text(
                  'Transfer of Your Personal Data',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff494949),
                      fontSize: 20,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: 8),
                Text(
                  '''Your information, including Personal Data, is processed at the Company's operating offices and in any other places where the parties involved in the processing are located. It means that this information may be transferred to — and maintained on — computers located outside of Your state, province, country or other governmental jurisdiction where the data protection laws may differ than those from Your jurisdiction.

Your consent to this Privacy Policy followed by Your submission of such information represents Your agreement to that transfer.

The Company will take all steps reasonably necessary to ensure that Your data is treated securely and in accordance with this Privacy Policy and no transfer of Your Personal Data will take place to an organization or a country unless there are adequate controls in place including the security of Your data and other personal information.''',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Color(0xff494949),
                  ),
                ),
                SizedBox(height: 16),
                // SizedBox(height: 16),
                Text(
                  'Delete Your Personal Data',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff494949),
                      fontSize: 20,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: 8),
                Text(
                  '''You have the right to delete or request that We assist in deleting the Personal Data that We have collected about You.

Our Service may give You the ability to delete certain information about You from within the Service.

You may update, amend, or delete Your information at any time by signing in to Your Account, if you have one, and visiting the account settings section that allows you to manage Your personal information. You may also contact Us to request access to, correct, or delete any personal information that You have provided to Us.

Please note, however, that We may need to retain certain information when we have a legal obligation or lawful basis to do so.''',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Color(0xff494949),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Disclosure of Your Personal Data',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff494949),
                      fontSize: 20,
                      fontFamily: 'Poppins'),
                ),
                SizedBox(height: 8),
                Text(
                  '''Business Transactions
If the Company is involved in a merger, acquisition or asset sale, Your Personal Data may be transferred. We will provide notice before Your Personal Data is transferred and becomes subject to a different Privacy Policy.

Law enforcement
Under certain circumstances, the Company may be required to disclose Your Personal Data if required to do so by law or in response to valid requests by public authorities (e.g. a court or a government agency).

Other legal requirements
The Company may disclose Your Personal Data in the good faith belief that such action is necessary to:

Comply with a legal obligation
Protect and defend the rights or property of the Company
Prevent or investigate possible wrongdoing in connection with the Service
Protect the personal safety of Users of the Service or the public
Protect against legal liability
Security of Your Personal Data
The security of Your Personal Data is important to Us, but remember that no method of transmission over the Internet, or method of electronic storage is 100% secure. While We strive to use commercially acceptable means to protect Your Personal Data, We cannot guarantee its absolute security.

Children's Privacy
Our Service does not address anyone under the age of 13. We do not knowingly collect personally identifiable information from anyone under the age of 13. If You are a parent or guardian and You are aware that Your child has provided Us with Personal Data, please contact Us. If We become aware that We have collected Personal Data from anyone under the age of 13 without verification of parental consent, We take steps to remove that information from Our servers.

If We need to rely on consent as a legal basis for processing Your information and Your country requires consent from a parent, We may require Your parent's consent before We collect and use that information.

Links to Other Websites
Our Service may contain links to other websites that are not operated by Us. If You click on a third party link, You will be directed to that third party's site. We strongly advise You to review the Privacy Policy of every site You visit.

We have no control over and assume no responsibility for the content, privacy policies or practices of any third party sites or services.

Changes to this Privacy Policy
We may update Our Privacy Policy from time to time. We will notify You of any changes by posting the new Privacy Policy on this page.

We will let You know via email and/or a prominent notice on Our Service, prior to the change becoming effective and update the "Last updated" date at the top of this Privacy Policy.

You are advised to review this Privacy Policy periodically for any changes. Changes to this Privacy Policy are effective when they are posted on this page.

Contact Us
If you have any questions about this Privacy Policy, You can contact us:

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
