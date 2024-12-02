import 'package:wrenchmate_user_app/app/data/models/payment_summary_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import this for Timestamp

class Booking {
  final String? userId;
  final List<String>? serviceList; 
  final String? status;
  final DateTime? completedDate; 
  final String? completedNote; 
  final DateTime? confirmationDate;
  final String? confirmationNote;
  final String? car_details;
  final DateTime? outForServiceDate; 
  final String? outForServiceNote; 
  final PaymentSummary? paymentSummary;
  final DateTime? date; 
  final String? order_id;
  final String? assignedDriverPhone;
  final String? assignedDriverName;

  Booking({
    this.userId,
    this.serviceList,
    this.status,
    this.car_details,
    this.completedDate,
    this.completedNote,
    this.confirmationDate,
    this.confirmationNote,
    this.outForServiceDate,
    this.outForServiceNote,
    this.paymentSummary,
    this.date,
    this.order_id,
    this.assignedDriverPhone,
    this.assignedDriverName
  });

  // Factory constructor to create a Booking from a Map
  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      userId: map['user_id'],
      serviceList: List<String>.from(map['service_list'] ?? []),
      status: map['status'],
        car_details: map['car_details'],
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
      order_id: map['order_id'],
      assignedDriverPhone: map['assignedDriverPhone'],
      assignedDriverName: map['assignedDriverName']
    );
  }
}