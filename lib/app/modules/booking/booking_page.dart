import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wrenchmate_user_app/app/modules/booking/widgets/tabButton.dart';
import '../../controllers/booking_controller.dart';
import '../../data/providers/booking_provider.dart';
import '../../data/models/booking_model.dart';
import '../../routes/app_routes.dart';

String formatDateTime(DateTime dateTime) {
  final DateFormat formatter = DateFormat('HH:mm dd MMM');
  return formatter.format(dateTime);
}

class BookingPage extends StatefulWidget {
  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String selectedTab = 'currBooking';

  @override
  Widget build(BuildContext context) {
    final BookingController controller = Get.find();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'My Booking',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date
                  Text(
                    formatDateTime(DateTime.now()),
                    style: TextStyle(color: Color(0xff919294)),
                  ),
                  SizedBox(height: 32),
                  // Tabs
                  Row(
                    children: [
                      // Current booking
                      TabButton(
                        text: 'Current Booking',
                        isSelected: selectedTab == 'currBooking',
                        onTap: () {
                          setState(() {
                            selectedTab = 'currBooking';
                          });
                        },
                      ),
                      SizedBox(width: 8),
                      // History
                      TabButton(
                        text: 'History',
                        isSelected: selectedTab == 'history',
                        onTap: () {
                          setState(() {
                            selectedTab = 'history';
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            // Booking list
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                if ((selectedTab == 'currBooking' &&
                        booking.status != BookingStatus.completed) ||
                    (selectedTab == 'history' &&
                        booking.status == BookingStatus.completed)) {
                  return BookingTile(isHistory: selectedTab == 'history',booking: booking);
                }
                return SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class BookingTile extends StatelessWidget {
  final Booking booking;
  final bool isHistory;

  const BookingTile({Key? key, required this.booking, required this.isHistory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, top: 8.0),
      child: GestureDetector(
        onTap: (){
          Get.toNamed(AppRoutes.BOOKING_DETAIL, arguments: booking);
        },
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 15,
              ),
            ],
          ),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: isHistory ? Color(0xff3778F2) :Color(0xff4CD964),
                ),
              ),
              Positioned(
                left: 8,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(booking.service.name),
                      Text(formatDateTime(booking.date)),
                      Text('\$${booking.paymentSummary.amount}'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
