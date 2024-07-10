import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wrenchmate_user_app/app/modules/service/widgits/desc_faq_review.dart';
import 'package:wrenchmate_user_app/app/modules/service/widgits/subservice.dart';
import '../../controllers/service_controller.dart';
import '../../data/models/service_model.dart';
import '../../data/providers/service_provider.dart';

class ServiceDetailPage extends StatefulWidget {
  @override
  State<ServiceDetailPage> createState() => _ServiceDetailPageState();
}

class _ServiceDetailPageState extends State<ServiceDetailPage> {
  String selectedTab = 'description';

  List<Service>? get filteredServices {
    if (selectedTab == 'description') {
      return services;
    } else {
      return [];
    }
  }

  Widget build(BuildContext context) {
    final Service service = Get.arguments;
    final ServiceController controller = Get.find();

    return Scaffold(
      appBar: AppBar(title: Text('Service Details')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            // Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 70,
                decoration: BoxDecoration(
                  color: Color(0xffF6F6F5),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    descFaqReview(
                      text: 'Description',
                      isSelected: selectedTab == 'description',
                      onTap: () {
                        setState(() {
                          selectedTab = 'description';
                        });
                      },
                    ),
                    descFaqReview(
                      text: 'FAQs',
                      isSelected: selectedTab == 'faq',
                      onTap: () {
                        setState(() {
                          selectedTab = 'faq';
                        });
                      },
                    ),
                    descFaqReview(
                      text: 'Review',
                      isSelected: selectedTab == 'review',
                      onTap: () {
                        setState(() {
                          selectedTab = 'review';
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            // Content
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: selectedTab == 'faq'
                    ? ExpansionPanelList(
                        elevation: 1,
                        expandedHeaderPadding:
                            EdgeInsets.symmetric(vertical: 8.0),
                        expansionCallback: (int index, bool isExpanded) {
                          setState(() {
                            service.faqs[index].isExpanded = !isExpanded;
                          });
                        },
                        children: service.faqs.map<ExpansionPanel>((FAQ faq) {
                          return ExpansionPanel(
                            headerBuilder:
                                (BuildContext context, bool isExpanded) {
                              return ListTile(
                                title: Text(faq.question),
                              );
                            },
                            body: ListTile(
                              title: Text(faq.answer),
                            ),
                            isExpanded: faq.isExpanded,
                          );
                        }).toList(),
                      )
                    : ExpansionPanelRadio(value: service.faqs[0].question, headerBuilder: (context,isExpanded)=>ListTile(
                  title: Text(faqs.queston),
                ), body: body)
              ),
            ),
          ],
        ),
      ),
    );
  }
}
