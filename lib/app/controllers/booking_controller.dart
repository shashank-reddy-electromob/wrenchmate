import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class BookingController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<void> addBooking(
    List<String> serviceList,
    String status,
    DateTime confirmationDate,
    DateTime? outForServiceDate,
    DateTime? completedDate,
    String confirmationNote,
    String outForServiceNote,
    String completedNote,
    String cardetails,
  ) async {
    try {
      await _firestore.collection('Booking').add({
        'user_id':userId,
        'service_list': serviceList,
        'status': status,
        'confirmation_date': confirmationDate,
        'outForService_date': outForServiceDate,
        'completed_date': completedDate,
        'confirmation_note': confirmationNote,
        'outForService_note': outForServiceNote,
        'completed_note': completedNote,
        'car_details': cardetails
      });
    } catch (e) {
      // Handle Firestore errors
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