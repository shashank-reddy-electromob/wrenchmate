import 'package:wrenchmate_user_app/app/data/providers/service_provider.dart';
import 'package:wrenchmate_user_app/app/data/models/booking_model.dart';

final paymentSummary1 = PaymentSummary(
  amount: 25.0,
  tax: 2.5,
  discount: 5.0,
);

final paymentSummary2 = PaymentSummary(
  amount: 40.0,
  tax: 4.0,
  discount: 8.0,
);

// Sample data for Bookings
final List<Booking> bookings = [
  Booking(
    service: services[0],
    status: BookingStatus.completed,
    paymentSummary: paymentSummary1,
    date: DateTime(2023, 6, 10),
  ),
  Booking(
    service: services[1],
    status: BookingStatus.ongoing,
    paymentSummary: paymentSummary2,
    date: DateTime(2023, 7, 5),
  ),Booking(
    service: services[1],
    status: BookingStatus.ongoing,
    paymentSummary: paymentSummary2,
    date: DateTime(2023, 7, 5),
  ),Booking(
    service: services[1],
    status: BookingStatus.ongoing,
    paymentSummary: paymentSummary2,
    date: DateTime(2023, 7, 5),
  ),
];
