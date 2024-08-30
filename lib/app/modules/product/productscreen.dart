import 'package:flutter/material.dart';
import 'package:wrenchmate_user_app/app/modules/home/widgits/searchbar_filter.dart';
import 'package:wrenchmate_user_app/app/modules/service/widgits/elevatedbutton.dart';
import 'package:wrenchmate_user_app/app/widgets/appbar.dart';
import 'package:wrenchmate_user_app/utils/color.dart';
import 'package:wrenchmate_user_app/utils/textstyles.dart';

class ProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Product',
        onBackButtonPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: Column(
        children: [
          searchbar(),
          SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              itemCount: 2,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 60.0),
                      child: Card(
                        color: Color(0xffF7F7F7),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            side: BorderSide(width: 1, color: lightGreyColor)),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 56.0, top: 16.0, right: 16.0, bottom: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Product name',
                                style: AppTextStyle.semibold15,
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                'QUANTITY=250 ml',
                                style: AppTextStyle.mediumdmsans11,
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                '₹ 1,299',
                                style: AppTextStyle.mediumdmsans13,
                              ),
                              SizedBox(height: 4.0),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Lorem ipsum dolor sit amet consectetur. A aliquet feugiat et',
                                      style: AppTextStyle.medium10,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Expanded(
                                    child: CustomElevatedButton(
                                      onPressed: () {
                                        // showModalBottomSheet(
                                        //   context: context,
                                        //   isScrollControlled: true,
                                        //   builder: (context) {
                                        //     // return BottomSheet();
                                        //   },
                                        // );
                                      },
                                      text: 'Add+',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 4.0,
                      top: 35.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          'https://via.placeholder.com/150',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
