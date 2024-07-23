import 'package:wrenchmate_user_app/app/data/models/payment_summary_model.dart';
import 'package:wrenchmate_user_app/app/data/models/service_model.dart';

enum BookingStatus {
  confirmed,
  ongoing,
  completed,
}

class Booking {
  final Service service;
  final BookingStatus status;
  final PaymentSummary paymentSummary;
  final DateTime date;

  Booking({
    required this.service,
    required this.status,
    required this.paymentSummary,
    required this.date,
  });
}
