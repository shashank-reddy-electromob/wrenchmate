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

  // Factory constructor to create a PaymentSummary from a Map
  factory PaymentSummary.fromMap(Map<String, dynamic> map) {
    return PaymentSummary(
      amount: map['amount']?.toDouble() ?? 0.0,
      tax: map['tax']?.toDouble() ?? 0.0,
      discount: map['discount']?.toDouble() ?? 0.0,
    );
  }
}