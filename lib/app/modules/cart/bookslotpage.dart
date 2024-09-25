import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:wrenchmate_user_app/app/controllers/auth_controller.dart';
import 'package:wrenchmate_user_app/app/widgets/blueButton.dart';

import '../../controllers/cart_controller.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custombackbutton.dart';

class BookSlot extends StatefulWidget {
  @override
  _BookSlotState createState() => _BookSlotState();
}

class _BookSlotState extends State<BookSlot> {
  int selectedAddressIndex = 0;
  int selectedDateIndex = 0;
  SfRangeValues _values = SfRangeValues(40.0, 80.0);
  DateTime selectedDate = DateTime.now();

  final CartController cartController = Get.put(CartController());
  final AuthController authcontroller = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    cartController.fetchUserAddresses();
    cartController.fetchUserCurrentAddressIndex();
  }
  void _updateCurrentAddress(int selectedAddressIndex) {
    authcontroller.updateCurrentAddress(selectedAddressIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Booking Details",
          style: TextStyle(fontWeight: FontWeight.w500, fontFamily: 'Raleway'),
        ),
        leading: Padding(
            padding: const EdgeInsets.all(6.0), child: Custombackbutton()),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Address',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Obx(() {
                        if (cartController.addresses.isEmpty) {
                          return Text('No addresses found.');
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: cartController.addresses.length,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Color(0xFFF6F6F5), // Border color
                                  width: 2.0, // Border width
                                ),
                              ),
                              margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                              padding: EdgeInsets.only(left: 12, top: 4, bottom: 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,  // Align icon and text properly
                                      children: [
                                        Icon(
                                          Icons.location_on_outlined,
                                          color: Color(0XFFFF5402),
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            '${cartController.addresses[index].split(',')[0]}, ${cartController.addresses[index].split(',')[4]}',
                                            softWrap: true,  // Allows the text to wrap
                                            overflow: TextOverflow.visible,  // Prevents clipping
                                            style: TextStyle(fontSize: 16),  // Optional: Adjust font size
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Obx(() => Radio<int>(
                                    value: index,
                                    groupValue: cartController.currentAddressIndex.value,
                                    onChanged: (int? value) {
                                      cartController.currentAddressIndex.value = value!;
                                    },
                                    activeColor: Color(0XFF1671D8), // Active color when selected
                                    fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                                      if (states.contains(MaterialState.selected)) {
                                        return Color(0XFF1671D8); // Active color
                                      }
                                      return Color(0XFF1671D8); // Inactive color
                                    }),
                                  )),
                                ],
                              ),
                            );
                          },
                        );

                      }),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0,top: 4),
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(
                              AppRoutes.MAPSCREEN,
                              arguments: {
                                'isnew': true,
                                'address': cartController
                                    .addresses[selectedAddressIndex]
                              },
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFE3F2FD), // Light blue background color
                                  borderRadius: BorderRadius.circular(12), // Rounded corners
                                ),
                                padding: EdgeInsets.all(8), // Padding inside the container
                                child: Icon(
                                  Icons.add,  // Add icon
                                  color: Color(0xFF1671D8),  // Blue color for the plus icon
                                  size: 24,  // Icon size
                                ),
                              ),
                              SizedBox(width: 12), // Space between the icon and the text
                              // Text widget
                              Text(
                                "Add New Address",
                                style: TextStyle(
                                  fontSize: 18, // Font size
                                  color: Color(0xff606060), // Text color (gray)
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Date',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 12),
                    Container(
                      height: 120,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: DatePicker(
                        DateTime.now(),
                        initialSelectedDate: DateTime.now(),
                        daysCount: 7,
                        onDateChange: (newDate) {
                          setState(() {
                            selectedDate = newDate;
                          });
                        },
                        selectionColor: Colors.blue,
                        dateTextStyle:
                            TextStyle(fontSize: 20, color: Color(0xffA8A8A8)),
                        monthTextStyle:
                            TextStyle(fontSize: 12, color: Color(0xffA8A8A8)),
                        dayTextStyle: TextStyle(
                          fontSize: 0,
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                  ],
                ),
                Text(
                  'Select Time',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 12),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SfRangeSlider(
                          activeColor: Color(0xff3371FF),
                          min: 0.0,
                          max: 100.0,
                          values: _values,
                          interval: 20,
                          showTicks: true,
                          showLabels: true,
                          enableTooltip: true,
                          minorTicksPerInterval: 1,
                          onChanged: (SfRangeValues values) {
                            setState(() {
                              _values = values;
                            });
                          },
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('00:00 PM'),
                            Text('01:00 AM'),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.settings, color: Colors.grey),
                            SizedBox(width: 8),
                            Text(
                              'Available',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),
                blueButton(
                  text: 'Reservation',
                  onTap: () {
                    selectedAddressIndex = cartController.currentAddressIndex.value;
                    _updateCurrentAddress(selectedAddressIndex);
                    print('Selected Address Index: $selectedAddressIndex');
                    
                    // Pass the selected date and time back to CartPage
                    Get.back(result: {
                      'selectedDate': selectedDate,
                      'selectedTimeRange': _values,
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}
