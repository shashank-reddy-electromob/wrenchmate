import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:wrenchmate_user_app/app/controllers/booking_controller.dart';
import 'package:wrenchmate_user_app/app/modules/booking/widgets/subscriptionCard.dart';
import 'package:wrenchmate_user_app/app/widgets/blueButton.dart';

class BottomSheetContent extends StatefulWidget {
  final String title;
  final DateTime startDate;
  final double startTime;
  final double endTime;
  final int slots;

  BottomSheetContent(
      {required this.title,
      required this.startDate,
      required this.startTime,
      required this.endTime,
      required this.slots});

  @override
  _BottomSheetContentState createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  late SfRangeValues _rangeValues;
  BookingController bookingController = Get.find<BookingController>();
  late DateTime selectedDate = widget.startDate;
  String _formatTime(dynamic actualValue) {
    int hour = actualValue.toInt();
    return '$hour:00';
  }

  @override
  void initState() {
    // TODO: implement initState
    _rangeValues = SfRangeValues(widget.startTime, widget.endTime);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SubscriptionCard(
                title: widget.title,
                startDate: widget.startDate,
                totalSlots: widget.slots,
                selectedSlotIndex: 0),
            SizedBox(
              height: 10,
            ),
            Text(
              'Select Date',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 120,
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
              child: DatePicker(
                widget.startDate,
                initialSelectedDate: widget.startDate,
                daysCount: 30,
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
            SizedBox(
              height: 12,
            ),
            Text(
              'Select Time',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: SfRangeSliderTheme(
                    data: SfRangeSliderThemeData(
                      tooltipBackgroundColor: Colors.blue,
                    ),
                    child: SfRangeSlider(
                      min: 9.0,
                      max: 21.0,
                      values: _rangeValues,
                      interval: 1.0,
                      showTicks: true,
                      showLabels: true,
                      minorTicksPerInterval: 1,
                      activeColor: Colors.blue,
                      enableTooltip: true,
                      tooltipShape: SfPaddleTooltipShape(),
                      startThumbIcon: Icon(
                        Icons.settings,
                        color: Colors.white,
                        size: 17,
                      ),
                      endThumbIcon: Icon(
                        Icons.settings,
                        color: Colors.white,
                        size: 17,
                      ),
                      inactiveColor: Colors.grey,
                      onChanged: (SfRangeValues newValues) {
                        setState(() {
                          if (newValues.end > newValues.start) {
                            _rangeValues = newValues;
                          } else {
                            _rangeValues = SfRangeValues(
                                newValues.start, newValues.start + 1);
                          }
                        });
                      },
                      tooltipTextFormatterCallback:
                          (dynamic actualValue, String formattedText) {
                        return _formatTime(actualValue);
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            BlueButton(
              text: 'Confirm',
              onTap: () async {
                await bookingController.updateBookingDetails(
                    selectedDate, _rangeValues.start, _rangeValues.end);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
