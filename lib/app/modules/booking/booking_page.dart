import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wrenchmate_user_app/app/modules/booking/widgets/tabButton.dart';
import '../../controllers/booking_controller.dart';
import '../../controllers/service_controller.dart';
import '../../data/models/Service_Firebase.dart';
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
  List<ServiceFirebase> currentServices = []; // Store services for current bookings
  List<ServiceFirebase> historyServices = []; // Store services for history bookings

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
        // Fetch service details and add to the appropriate list
        ServiceFirebase service = await _fetchServiceDetails(serviceController, serviceId);
        if (booking['status'] == 'confirmed' || booking['status'] == 'ongoing') {
          currentServices.add(service); // Add to current bookings
        } else if (booking['status'] == 'completed') {
          historyServices.add(service); // Add to history bookings
        }
      }
    }

    setState(() {}); // Update the UI
  }

  Future<ServiceFirebase> _fetchServiceDetails(ServiceController serviceController, String serviceId) async {
    await serviceController.fetchServiceDataById(serviceId); // Call the existing method
    // Assuming the serviceController has a way to access the fetched service
    return serviceController.services.firstWhere((service) => service.id == serviceId); // Return the service
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
              itemCount: selectedTab == 'currBooking' ? currentServices.length : historyServices.length,
              itemBuilder: (context, index) {
                final service = selectedTab == 'currBooking' ? currentServices[index] : historyServices[index];
                return BookingTile(service: service); // Pass the service to BookingTile
              },
            ),
          ],
        ),
      ),
    );
  }
}

class BookingTile extends StatelessWidget {
  final ServiceFirebase service; // Change to accept ServiceFirebase

  const BookingTile({Key? key, required this.service}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, top: 8.0),
      child: GestureDetector(
        onTap: () {
          Get.toNamed(AppRoutes.BOOKING_DETAIL, arguments: service);
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
                  color: Color(0xff4CD964), // Use a default color
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
                      Text(service.name), // Display service name
                      Text('\$${service.price}'), // Display service price
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