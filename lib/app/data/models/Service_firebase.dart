class ServiceFirebase {
  String id;
  String category;
  String description;
  int discount;
  String name;
  double price;
  String serviceProviderId;
  String time;
  String warranty;
  double averageRating; // New field
  int totalReviews;     // New field

  ServiceFirebase({
    required this.id,
    required this.category,
    required this.description,
    required this.discount,
    required this.name,
    required this.price,
    required this.serviceProviderId,
    required this.time,
    required this.warranty,
    this.averageRating = 0.0, // Initialize with default value
    this.totalReviews = 0,    // Initialize with default value
  });

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'description': description,
      'discount': discount,
      'name': name,
      'price': price,
      'serviceProviderId': serviceProviderId,
      'time': time,
      'warranty': warranty,
      'averageRating': averageRating,
      'totalReviews': totalReviews,
    };
  }
}