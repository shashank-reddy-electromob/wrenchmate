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