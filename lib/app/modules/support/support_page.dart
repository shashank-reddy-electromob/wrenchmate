import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wrenchmate_user_app/app/modules/support/widgets/socialmediatabs.dart';
import 'package:wrenchmate_user_app/app/routes/app_routes.dart';
import '../../controllers/support_controller.dart';
import '../booking/widgets/tabButton.dart';

class SupportPage extends StatefulWidget {
  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  String selectedTab = 'FAQ';
  final Uri _facebookurl = Uri.parse(
      'https://www.facebook.com/share/ukeBPBwWBrstR7vo/?mibextid=qi2Omg');
  final Uri _instagramurl = Uri.parse(
      'https://www.instagram.com/wrench_mate?igsh=bXZxcGFnNDhreW1u&utm_source=qr');
  final Uri _xurl =
      Uri.parse('https://x.com/Wrench_Mate?t=HghACtlqQa3syL4W3wzv3A&s=08');

  @override
  void initState() {
    // TODO: implement initState
    print(faqs.length);
    super.initState();
  }

  final List<Map<String, String>> faqs = [
    {
      'question': 'How do I book a service?',
      'answer':
          'Open the Wrench Mate app, select the service you need (car wash, detailing, repairs, etc.), choose your preferred date and time, and confirm the booking.'
    },
    {
      'question': 'Can I modify or cancel a booking?',
      'answer':
          'Yes, you can modify or cancel your booking through "My Bookings" in the app. If your car has already been picked up, please contact support for assistance.'
    },
    {
      'question': 'What services are available through Wrench Mate?',
      'answer':
          'We offer car washing, detailing, repairs, interior cleaning, and other auto care services. Check the app for a full list.'
    },
    {
      'question': 'How do I check my service status?',
      'answer':
          'You can track your car’s progress in real-time through the app once it is picked up for service.'
    },
    {
      'question': 'How does the car pickup and drop-off process work?',
      'answer':
          'A professional Wrench Mate driver will come to your location to pick up your car at the scheduled time. After the service is completed, your car will be dropped off at the same location.'
    },
    {
      'question': 'Can I track the driver?',
      'answer':
          'Yes, you can track the driver’s location for both pickup and drop-off through the app.'
    },
    {
      'question':
          'What happens if I’m not available at the time of pickup or drop-off?',
      'answer':
          'If you miss the pickup, you can reschedule it from the app or contact customer support. For drop-off, our driver will contact you to coordinate a convenient time.'
    },
    {
      'question': 'What payment methods are accepted?',
      'answer':
          'We accept payments via credit cards, debit cards, UPI, and net banking.'
    },
    {
      'question': 'How do I apply a discount or promo code?',
      'answer':
          'Enter the promo code at checkout before confirming your booking to avail discounts.'
    },
    {
      'question': 'When will I be charged for the service?',
      'answer':
          'Payment is processed after the service is completed and your car is returned.'
    },
    {
      'question': 'Are there any hidden fees?',
      'answer':
          'No, all charges are transparent and visible before you confirm your booking.'
    },
    {
      'question': 'What subscription plans are available?',
      'answer':
          'We offer monthly and yearly subscription packages for regular car maintenance, which include car washes, interior detailing, and discounted repairs.'
    },
    {
      'question': 'How do I subscribe to a plan?',
      'answer':
          'You can choose a subscription plan directly from the app under the "Subscriptions" tab.'
    },
    {
      'question': 'Can I cancel or upgrade my subscription?',
      'answer':
          'Yes, you can cancel or upgrade your subscription at any time through the app.'
    },
    {
      'question': 'How do I purchase car accessories or products?',
      'answer':
          'Browse the available car accessories and care products in the app’s store section, add them to your cart, and complete the purchase with a few clicks.'
    },
    {
      'question': 'How long will delivery take?',
      'answer':
          'Delivery times vary by location, but you can track your order through the app once it’s confirmed.'
    },
    {
      'question': 'Can I return or exchange products?',
      'answer':
          'Yes, if you are not satisfied with a product, you can return or exchange it within the return policy timeframe.'
    },
    {
      'question': 'How do I know which service center is handling my car?',
      'answer':
          'You will be notified about the assigned service center and technician handling your car through the app.'
    },
    {
      'question': 'Can I select my preferred service center?',
      'answer':
          'While Wrench Mate automatically assigns the best center, you can request a specific service center during booking if you have a preference.'
    },
    {
      'question': 'What if I’m not satisfied with the service provided?',
      'answer':
          'You can reach out to customer support to raise a complaint, and we will address the issue, including options for re-servicing.'
    },
    {
      'question': 'How do I update my personal details?',
      'answer':
          'You can update your profile information, including contact details and addresses, in the "Account Settings" section of the app.'
    },
    {
      'question': 'Can I add multiple vehicles to my account?',
      'answer':
          'Yes, you can add and manage multiple vehicles under a single account in the app.'
    },
    {
      'question': 'The app is not working; what should I do?',
      'answer':
          'Try restarting the app or your device. If the issue persists, check for app updates or contact customer support for help.'
    },
    {
      'question': 'How do I report a bug or technical issue?',
      'answer':
          'You can report bugs or app issues by navigating to the "Support" section in the app and submitting a ticket.'
    },
    {
      'question': 'How can I provide feedback on my service?',
      'answer':
          'After your service is complete, you will be prompted to rate the service and leave feedback within the app.'
    },
    {
      'question': 'What should I do if I’m unhappy with the service?',
      'answer':
          'You can file a complaint through the "Support" section in the app, and our customer service team will work to resolve the issue.'
    },
    {
      'question':
          'Can I request the same driver or technician for future services?',
      'answer':
          'Yes, you can request a preferred driver or technician when booking your service.'
    },
    {
      'question': 'How is my personal data used by Wrench Mate?',
      'answer':
          'We value your privacy. Your data is used only for processing bookings, improving services, and sending you relevant notifications. For more details, review our Privacy Policy in the app.'
    },
    {
      'question': 'How do I reach customer support?',
      'answer':
          'You can contact us via email at Contact@wrenchmate.in or call us at 7386565050. For immediate assistance, use the in-app chat feature. We are available Monday to Saturday from 9 AM to 7 PM.'
    }
  ];

  List<bool> _isVisibleList = List.generate(29, (index) => false);
  final SupportController controller = Get.put(SupportController());

  @override
  Widget build(BuildContext context) {
    // final SupportController controller = Get.find();
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            'Help and Support',
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 24,
                fontFamily: 'Raleway'),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              //tabs
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    // Current booking
                    TabButton(
                      text: 'FAQ',
                      isSelected: selectedTab == 'FAQ',
                      onTap: () {
                        setState(() {
                          selectedTab = 'FAQ';
                        });
                      },
                    ),
                    SizedBox(width: 8),
                    // History
                    TabButton(
                      text: 'Contact Us',
                      isSelected: selectedTab == 'ContactUs',
                      onTap: () {
                        setState(() {
                          selectedTab = 'ContactUs';
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              // Display content based on selected tab
              if (selectedTab == 'FAQ')
                Expanded(child: ExpandingListFAQs())
              else
                Column(
                  children: [
                    CustomContainer(
                        imagePath: 'assets/socials/chatus.png',
                        text: "Chat with Us",
                        onTap: () async {
                          // final String phoneNumber = "7386565050";
                          // final Uri whatsappUri =
                          //     Uri.parse("https://wa.me/$phoneNumber");

                          // if (await canLaunchUrl(whatsappUri)) {
                          //   await launchUrl(whatsappUri);
                          // } else {
                          //   print("Could not open WhatsApp.");
                          // }
                          Get.toNamed(AppRoutes.CHATSCREEN);
                        }),
                    CustomContainer(
                        imagePath: 'assets/socials/facebook.png',
                        text: "Facebook",
                        onTap: () async {
                          await launchUrl(_facebookurl);
                        }),
                    CustomContainer(
                        imagePath: 'assets/socials/instagram.png',
                        text: "Instagram",
                        onTap: () async {
                          await launchUrl(_instagramurl);
                        }),
                    CustomContainer(
                        imagePath: 'assets/socials/twt.png',
                        text: "Twitter",
                        onTap: () async {
                          await launchUrl(_xurl);
                        }), // Provide a valid function
                  ],
                ),
            ],
          ),
        ));
  }

  Widget ExpandingListFAQs() {
    return ListView.builder(
      itemCount: faqs.length,
      itemBuilder: (context, serviceIndex) {
        var faq = faqs[serviceIndex];
        return Container(
          margin: const EdgeInsets.symmetric(
              vertical: 0.0), // Add margin for spacing
          decoration: BoxDecoration(
            color: Colors.white, // Background color
            border: Border(
              bottom: BorderSide(
                width: 1, // Border width
                color: Colors.grey.shade300, // Border color
              ),
            ), // Rounded corners
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.black.withOpacity(0.2),
            //     spreadRadius: 0,
            //     blurRadius: 2,
            //     offset: Offset(0, 1), // changes position of shadow
            //   ),
            // ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(
                    faq['question']!, // Use FAQ model
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        color: _isVisibleList[serviceIndex]
                            ? Color(0xff3778F2)
                            : Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                  ),
                  trailing: _isVisibleList[serviceIndex]
                      ? Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Color(0xff3778F2),
                          size: 16,
                        )
                      : Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Color(0xff7B7B7B),
                          size: 16,
                        ),
                  onTap: () {
                    setState(() {
                      _isVisibleList[serviceIndex] =
                          !_isVisibleList[serviceIndex];
                    });
                  },
                  tileColor:
                      Colors.transparent, // Set tile color to transparent
                ),
                Visibility(
                  visible: _isVisibleList[serviceIndex],
                  child: Container(
                    color: Colors.white,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: Text(
                        faq['answer']!,
                        style: TextStyle(
                            color: Color(0xff6D6D6D),
                            fontSize: 12,
                            fontFamily: 'Poppins'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
