import 'package:wrenchmate_user_app/app/data/models/service_model.dart';

class PaymentSummary {
  final double amount;
  final double tax;
  final double discount;

  PaymentSummary({
    required this.amount,
    required this.tax,
    required this.discount,
  });

  double get totalAmount => amount + tax - discount;
}

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
