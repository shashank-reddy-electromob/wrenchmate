import 'package:wrenchmate_user_app/app/data/models/payment_summary_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import this for Timestamp

class Booking {
  final String? userId; // Optional user_id
  final List<String>? serviceList; // Optional service_list
  final String? status; // Optional status
  final DateTime? completedDate; // Optional completed_date
  final String? completedNote; // Optional completed_note
  final DateTime? confirmationDate; // Optional confirmation_date
  final String? confirmationNote; // Optional confirmation_note
  final DateTime? outForServiceDate; // Optional outForService_date
  final String? outForServiceNote; // Optional outForService_note
  final PaymentSummary? paymentSummary; // Optional paymentSummary
  final DateTime? date; // Optional date

  Booking({
    this.userId,
    this.serviceList,
    this.status,
    this.completedDate,
    this.completedNote,
    this.confirmationDate,
    this.confirmationNote,
    this.outForServiceDate,
    this.outForServiceNote,
    this.paymentSummary,
    this.date,
  });

  // Factory constructor to create a Booking from a Map
  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      userId: map['user_id'],
      serviceList: List<String>.from(map['service_list'] ?? []),
      status: map['status'],
      completedDate: map['completed_date'] is Timestamp
          ? (map['completed_date'] as Timestamp).toDate()
          : map['completed_date'] != null
              ? DateTime.parse(map['completed_date'])
              : null,
      completedNote: map['completed_note'],
      confirmationDate: map['confirmation_date'] is Timestamp
          ? (map['confirmation_date'] as Timestamp).toDate()
          : map['confirmation_date'] != null
              ? DateTime.parse(map['confirmation_date'])
              : null,
      confirmationNote: map['confirmation_note'],
      outForServiceDate: map['outForService_date'] is Timestamp
          ? (map['outForService_date'] as Timestamp).toDate()
          : map['outForService_date'] != null
              ? DateTime.parse(map['outForService_date'])
              : null,
      outForServiceNote: map['outForService_note'],
      paymentSummary: map['payment_summary'] != null
          ? PaymentSummary.fromMap(map['payment_summary'])
          : null,
      date: map['date'] is Timestamp
          ? (map['date'] as Timestamp).toDate()
          : map['date'] != null
              ? DateTime.parse(map['date'])
              : null,
    );
  }
}