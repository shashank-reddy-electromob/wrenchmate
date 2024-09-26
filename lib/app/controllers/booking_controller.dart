import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart'; // Import Firestore

class BookingController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<void> addBooking(
    List<String> serviceIds,
    String status,
    DateTime confirmationDate,
    DateTime? outForServiceDate,
    DateTime? completedDate,
    String confirmationNote,
    String outForServiceNote,
    String completedNote,
    String currentCar,
    DateTime? selectedDate, // New parameter
    SfRangeValues? selectedTimeRange, // New parameter
  ) async {
    try {
      await _firestore.collection('Booking').add({
        'user_id':userId,
        'service_list': serviceIds,
        'status': status,
        'confirmation_date': confirmationDate,
        'outForService_date': outForServiceDate,
        'completed_date': completedDate,
        'confirmation_note': confirmationNote,
        'outForService_note': outForServiceNote,
        'completed_note': completedNote,
        'car_details': currentCar,
        'selected_date': selectedDate != null ? selectedDate.toIso8601String() : null, // Add selected date
        'selected_time_range': selectedTimeRange != null ? {
          'start': selectedTimeRange.start,
          'end': selectedTimeRange.end,
        } : null, 
      });
    } catch (e) {
      throw Exception("Failed to add booking: $e");
    }
  }

  Future<List<Map<String, dynamic>>> fetchUserBookings() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('Booking')
          .where('user_id', isEqualTo: userId)
          .get();

      List<Map<String, dynamic>> bookings = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      print(bookings);
      return bookings;
    } catch (e) {
      throw Exception("Failed to fetch bookings: $e");
    }
  }
}