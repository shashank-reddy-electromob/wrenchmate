class Review {
  final String serviceId;
  final String userId;
  final String message;
  final double rating;

  Review({
    required this.serviceId,
    required this.userId,
    required this.message,
    required this.rating,
  });
}