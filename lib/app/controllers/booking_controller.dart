import 'dart:developer';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class BookingController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  RxString bookingStatus = 'pending'.obs;
  var subId = ''.obs;
  var subsBookingList = <Map<String, dynamic>>[].obs;
  var BookingList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> subscriptionDetailsList =
      <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> benefitsList = <Map<String, dynamic>>[].obs;
  var driverRating = 0.0.obs;

  String? _lastTransactionId;

  String generateUniqueTransactionId() {
    final now = DateTime.now();
    final dateStr =
        "${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}";
    final timeStr =
        "${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}";
    final random = Random().nextInt(9999).toString().padLeft(4, '0');

    _lastTransactionId = "TX_${dateStr}_${timeStr}_$random";
    return _lastTransactionId!;
  }

  String? get currentTransactionId => _lastTransactionId;

  Future<void> updateBookingDetails(DateTime confirmationDate,
      Map<String, dynamic> benefit, double start, double end) async {
    QuerySnapshot bookingSnapshot = await FirebaseFirestore.instance
        .collection('Booking')
        .where('user_id', isEqualTo: userId)
        .where('subscription_id', isEqualTo: subId.value)
        .get();

    try {
      for (DocumentSnapshot bookingDoc in bookingSnapshot.docs) {
        List<dynamic> benefits = bookingDoc['benefits'];
        int benefitIndex =
            benefits.indexWhere((b) => b['name'] == benefit['name']);
        if (benefitIndex == -1) {
          print('Benefit not found');
          continue;
        }

        List<dynamic> dates = benefits[benefitIndex]['dates'];
        if (benefit['index'] < dates.length) {
          dates[benefit['index']] = confirmationDate.toIso8601String();
        } else {
          print('Invalid index for dates array');
          continue;
        }

        benefits[benefitIndex]['dates'] = dates;
        await bookingDoc.reference.update({
          'benefits': benefits,
          'selected_time_range': {
            'start': start,
            'end': end,
          },
        });
      }
      fetchBookingsWithSubscriptionDetails();
      print('Booking details updated successfully for all matched documents');
    } catch (e) {
      print('Failed to update booking details: $e');
    }
  }

  Future<void> fetchBookingsWithSubscriptionDetails() async {
    try {
      QuerySnapshot bookingSnapshot = await FirebaseFirestore.instance
          .collection('Booking')
          .where('user_id', isEqualTo: userId)
          .where('subscription_id', isNotEqualTo: '')
          .get();

      subsBookingList.clear();

      for (var bookingDoc in bookingSnapshot.docs) {
        var bookingData = bookingDoc.data() as Map<String, dynamic>;

        String subscriptionId = bookingData['subscription_id'];
        subId.value = subscriptionId;
        if (subscriptionId != null && subscriptionId.isNotEmpty) {
          QuerySnapshot subscriptionSnapshot = await FirebaseFirestore.instance
              .collection('UserSubscriptions')
              .where('subscriptionId', isEqualTo: subscriptionId)
              .get();

          if (subscriptionSnapshot.docs.isNotEmpty) {
            var subscriptionData =
                subscriptionSnapshot.docs.first.data() as Map<String, dynamic>;
            var combinedData = {
              ...bookingData,
              'subscriptionDetails': subscriptionData,
            };
            subsBookingList.add(combinedData);
          } else {
            subsBookingList.add(bookingData);
          }
        }
      }

      // await fetchSubscriptionDetails(
      //     subsBookingList[0]['subscriptionDetails']['subscriptionName']);
      await fetchSubscriptionDetails(subId.value);

      if (subsBookingList.isEmpty) {
        print('No bookings with non-empty subscription_id found.');
      }
    } catch (e) {
      print('Error fetching booking and subscription details: $e');
    }
  }

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    // return DateFormat('MMMM d, yyyy h:mm a').format(dateTime);
    return DateFormat('d MMMM, yyyy').format(dateTime);
  }

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
      String? order_id) async {
    try {
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
        'order_id': order_id,
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

  Future<void> addSubscriptionBooking(
    String packName,
    double price,
    Timestamp? startDate,
    Timestamp? endDate,
    String status,
    DateTime confirmationDate,
    DateTime? outForServiceDate,
    DateTime? completedDate,
    String currentCar,
    String address,
    DateTime? selectedDate,
    SfRangeValues? selectedTimeRange,
    String subscriptionId,
    String subscriptionName,
    BuildContext context,
  ) async {
    try {
      // Step 1: Check if the subscription already exists and is active
      QuerySnapshot subscriptionSnapshot = await _firestore
          .collection('UserSubscriptions')
          .where('user_id', isEqualTo: userId)
          .get();
      if (subscriptionSnapshot.docs.isNotEmpty) {
        var subscriptionDoc = subscriptionSnapshot.docs[0];
        DateTime existingStartDate =
            (subscriptionDoc['startDate'] as Timestamp).toDate();
        DateTime existingEndDate =
            (subscriptionDoc['endDate'] as Timestamp).toDate();
        DateTime currentDate = DateTime.now();
        if (currentDate.isAfter(existingStartDate) &&
            currentDate.isBefore(existingEndDate)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  "Active subscription already exists. Cannot add another subscription booking."),
            ),
          );
          return;
        }
      }

      // Step 2: Search for the subscription by subscriptionName
      QuerySnapshot subscriptionQuery = await _firestore
          .collection('Subscriptions')
          .where('plan', isEqualTo: subscriptionName)
          .get();

      // if (subscriptionQuery.docs.isEmpty) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text("Subscription not found.")),
      //   );
      //   return;
      // }

      // Get the first document's data and cast it to a Map
      var subscriptionData =
          subscriptionQuery.docs.first.data() as Map<String, dynamic>?;

      Map<String, dynamic> benefitsMap = subscriptionData?['benefits'] ?? {};

      List<Map<String, dynamic>> transformedBenefits =
          benefitsMap.entries.map((entry) {
        int numSlots = int.tryParse(entry.value['num'] ?? '0') ?? 0;

        return {
          'name': entry.value['name'] ?? 'Unknown',
          'status': 'confirmed',
          'num': numSlots,
          'index': 0,
          'dates': [
            selectedDate?.toIso8601String() ??
                '', // First position filled with selectedDate
            ...List<String>.generate(
                numSlots - 1, (index) => ''), // Remaining empty slots
          ],
        };
      }).toList();
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
        'selected_date': selectedDate?.toIso8601String(),
        'selected_time_range': selectedTimeRange != null
            ? {
                'start': selectedTimeRange.start,
                'end': selectedTimeRange.end,
              }
            : null,
        'subscriptionId': subscriptionId,
        'subscriptionName': subscriptionName,
        'unitQuantity': 1,
      });

      await _firestore.collection('Booking').add({
        'user_id': userId,
        'status': status,
        'confirmation_date': confirmationDate,
        'outForService_date': outForServiceDate,
        'completed_date': completedDate,
        'car_details': currentCar,
        'address': address,
        'selected_date': selectedDate?.toIso8601String(),
        'selected_time_range': selectedTimeRange != null
            ? {
                'start': selectedTimeRange.start,
                'end': selectedTimeRange.end,
              }
            : null,
        'subscription_id': subscriptionId,
        'benefits': transformedBenefits,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("booking added successfully.")),
      );

      // Get.snackbar('Success', "Booking added Successfully");
    } catch (e) {
      Get.snackbar('Success', "Failed to add subscription and booking: $e");

      throw Exception("Failed to add booking: $e");
    }
  }

  Future<void> fetchSubscriptionDetails(String subId) async {
    try {
      QuerySnapshot subSnapshot = await FirebaseFirestore.instance
          .collection('Booking')
          .where('subscription_id', isEqualTo: subId)
          .get();

      if (subSnapshot.docs.isNotEmpty) {
        Map<String, dynamic> subscriptionBookingData =
            subSnapshot.docs.first.data() as Map<String, dynamic>;

        subscriptionDetailsList.add(subscriptionBookingData);

        List benefits = subscriptionBookingData['benefits'];
        benefitsList.clear();
        for (var benefit in benefits) {
          benefitsList.add(benefit);
        }
        print("Benefit details fetched and stored: $benefitsList");
      } else {
        print("No subscription found for the specified plan.");
      }
    } catch (e) {
      print('Error fetching subscription details: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchUserBookings() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('Booking')
          .where('user_id', isEqualTo: userId)
          .get();
      BookingList.clear();
      List<Map<String, dynamic>> bookings = snapshot.docs
          .where((doc) {
            var data = doc.data() as Map<String, dynamic>?;
            return data != null && !data.containsKey('subscription_id');
          })
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

      BookingList.assignAll(bookings);
      await fetchDriverReview(BookingList[0]['assignedDriverPhone'] ?? '');
      return bookings;
    } catch (e) {
      throw Exception("Failed to fetch bookings: $e");
    }
  }

  Future<void> fetchDriverReview(String driverPhone) async {
    try {
      driverRating.value = 0;
      QuerySnapshot snapshot = await _firestore
          .collection('DriverReview')
          .where('phone', isEqualTo: driverPhone)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Assuming the field storing the rating is called 'rating'
        print(snapshot.docs);
        driverRating.value = snapshot.docs.first['rating'] ?? 0.0;
        print('Driver Rating: $driverRating');
      } else {
        print('No reviews found for the driver with phone: $driverPhone');
      }
    } catch (e) {
      print('Error fetching driver review: $e');
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
