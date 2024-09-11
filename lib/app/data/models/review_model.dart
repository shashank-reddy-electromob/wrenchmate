class Review {
  final String serviceId;
  final String productId;
  final String userId;
  final String message;
  final double rating;

  Review({
    required this.serviceId,
    required this.productId,
    required this.userId,
    required this.message,
    required this.rating,
  });
}