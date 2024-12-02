import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wrenchmate_user_app/app/data/models/Service_firebase.dart';
import 'package:wrenchmate_user_app/app/modules/booking/widgets/tabButton.dart';
import '../../controllers/booking_controller.dart';
import '../../controllers/service_controller.dart';
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
  List<Map<String, dynamic>> bookings = []; // Store fetched bookings
  List<Servicefirebase> currentServices =
      []; // Store services for current bookings
  List<Servicefirebase> historyServices =
      []; // Store services for history bookings

  @override
  void initState() {
    super.initState();
    _loadUserBookings(); // Call the function in initState
  }

  Future<void> _loadUserBookings() async {
    final BookingController bookingController = Get.put(BookingController());
    bookings = await bookingController.fetchUserBookings(); // Fetch bookings

    final ServiceController serviceController = Get.put(ServiceController());
    for (var booking in bookings) {
      for (var serviceId in booking['service_list']) {
        log('service id is: $serviceId}');
        Servicefirebase service =
            await _fetchServiceDetails(serviceController, serviceId);
        if (booking['status'] == 'confirmed' ||
            booking['status'] == 'ongoing') {
          currentServices.add(service); // Add to current bookings
        } else if (booking['status'] == 'completed') {
          historyServices.add(service); // Add to history bookings
        }
      }
    }

    print('History Services Count: ${historyServices.length}');
    print('Current Services Count: ${currentServices.length}');
    setState(() {});
  }

  Future<Servicefirebase> _fetchServiceDetails(
      ServiceController serviceController, String serviceId) async {
    await serviceController.fetchServiceDataById(serviceId);
    return serviceController.services
        .firstWhere((service) => service.id == serviceId); // Return the service
  }

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
              itemCount: selectedTab == 'currBooking'
                  ? currentServices.length
                  : historyServices.length,
              itemBuilder: (context, index) {
                final service = selectedTab == 'currBooking'
                    ? currentServices[index]
                    : historyServices[index];

                // Ensure bookingIndex is calculated correctly
                final bookingIndex = selectedTab == 'currBooking'
                    ? index
                    : index; // Adjusted for history

                // Check if bookingIndex is valid
                if (bookingIndex < bookings.length) {
                  final bookingMap =
                      bookings[bookingIndex]; // Access the booking
                  final booking =
                      Booking.fromMap(bookingMap); // Convert to Booking object
                  log('status is: ${booking.status}');
                  return BookingTile(
                    service: service,
                    booking: booking,
                    selectedTab: selectedTab,
                  ); // Pass the Booking object
                } else {
                  return SizedBox.shrink(); // Handle out of bounds
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class BookingTile extends StatelessWidget {
  final Servicefirebase service; // Change to accept ServiceFirebase
  final Booking booking; // Change to accept Booking
  final String selectedTab; // Change to accept Booking

  const BookingTile(
      {Key? key,
      required this.service,
      required this.booking,
      required this.selectedTab})
      : super(key: key);

  String _getCarImage(String carType) {
    switch (carType) {
      case 'Compact SUV':
        return 'assets/car/compact_suv.png';
      case 'Hatchback':
        return 'assets/car/hatchback.png';
      case 'SUV':
        return 'assets/car/suv.png';
      case 'Sedan':
        return 'assets/car/sedan.png';
      default:
        return 'assets/car/default_car.png';
    }
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    final DateFormat formatter = DateFormat('hh:mm, dd, MMM');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final carType = booking.car_details?.split(';')[0] ?? '';
    final carImage = _getCarImage(carType);
    final formattedDate = _formatDateTime(booking.confirmationDate);

    return Padding(
      padding: const EdgeInsets.only(left: 18.0, top: 8.0),
      child: GestureDetector(
        onTap: () {
          Get.toNamed(AppRoutes.BOOKING_DETAIL,
              arguments: {'service': service, 'booking': booking});
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
                  color: selectedTab == 'currBooking'
                      ? Color(0xff4CD964)
                      : Color(0xff3778F2), // Conditional color
                ),
              ),
              Positioned(
                left: 8,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  padding:
                      EdgeInsets.only(left: 16, top: 24, bottom: 16, right: 48),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(carImage,
                                  height: MediaQuery.of(context).size.width *
                                      0.155),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                'Service name: \n${service.name}',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.037),
                              ),
                            ],
                          ),
                          Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width * 0.28,
                            decoration: BoxDecoration(
                              color: Color(0xffE9FFED),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: Text(
                                // "something",
                                booking.order_id ?? 'Order_id',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.032),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            alignment: Alignment.center,
                          )
                        ],
                      ), // Display service name
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(formattedDate),
                          Text('₹ ${service.price}'),
                        ],
                      ),
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
