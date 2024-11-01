import 'dart:developer';
import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class BookingController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  RxString bookingStatus = 'pending'.obs;

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
    String address,
    DateTime? selectedDate,
    SfRangeValues? selectedTimeRange,
  ) async {
    try {
      log('message');
      await _firestore.collection('Booking').add({
        'user_id': userId,
        'service_list': serviceIds,
        'status': status,
        'confirmation_date': confirmationDate,
        'outForService_date': outForServiceDate,
        'completed_date': completedDate,
        'confirmation_note': confirmationNote,
        'outForService_note': outForServiceNote,
        'completed_note': completedNote,
        'car_details': currentCar,
        'address': address,
        'selected_date': selectedDate?.toIso8601String(),
        'selected_time_range': selectedTimeRange != null
            ? {
                'start': selectedTimeRange.start,
                'end': selectedTimeRange.end,
              }
            : null,
      });
    } catch (e) {
      throw Exception("Failed to add booking: $e");
    }
  }

  Future<void> addSubscription(
    String packName,
    double price,
    Timestamp? startDate,
    Timestamp? endDate,
    DateTime confirmationDate,
    DateTime? outForServiceDate,
    String status,
    DateTime? completedDate,
    String currentCar,
    String address,
    DateTime? selectedDate,
    SfRangeValues? selectedTimeRange,
    String subscriptionId,
    String subscriptionName,
  ) async {
    try {
      log('testing adding to subscription');

      await _firestore.collection('UserSubscriptions').add({
        'user_id': userId,
        'packDesc': packName,
        'price': price,
        'startDate': startDate,
        'endDate': endDate,
        'confirmation_date': confirmationDate,
        'outForService_date': outForServiceDate,
        'status': status,
        'completed_date': completedDate,
        'current_cart': currentCar,
        'address': address,
        'selected_date': selectedDate,
        'selected_time_range': selectedTimeRange != null
            ? {
                'start': selectedTimeRange.start,
                'end': selectedTimeRange.end,
              }
            : null,
        'subscriptionId': subscriptionId,
        'subscriptionName': subscriptionName,
        'unitQuantity': 1
      });
    } catch (e) {
      throw Exception("Failed to add subscription: $e");
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

      // Convert selected_time_range back to SfRangeValues
      for (var booking in bookings) {
        if (booking['selected_time_range'] != null) {
          booking['selected_time_range'] = SfRangeValues(
            booking['selected_time_range']['start'],
            booking['selected_time_range']['end'],
          );
        }
      }

      print(' booking is: ${bookings}');
      return bookings;
    } catch (e) {
      throw Exception("Failed to fetch bookings: $e");
    }
  }

  Future<void> createTrackingRecord(
      String userId, Map<String, dynamic> bookingDetails) async {
    try {
      await _firestore
          .collection('User')
          .doc(userId)
          .collection('Tracking')
          .add(bookingDetails);
      print("Tracking record created successfully.");
    } catch (e) {
      print("Error creating tracking record: $e");
    }
  }
}
