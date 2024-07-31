class ServiceFirebase {
  String id;
  String category;
  String description;
  int discount;
  String name;
  String image;
  double price;
  String serviceProviderId;
  String time;
  String warranty;
  double averageReview;
  int numberOfReviews;

  ServiceFirebase({
    required this.id,
    required this.category,
    required this.description,
    required this.discount,
    required this.name,
    required this.image,
    required this.price,
    required this.serviceProviderId,
    required this.time,
    required this.warranty,
    required this.averageReview,
    required this.numberOfReviews,
  });

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'description': description,
      'discount': discount,
      'name': name,
      'image':image,
      'price': price,
      'serviceProviderId': serviceProviderId,
      'time': time,
      'warranty': warranty,
      'averageReview': averageReview,
      'numberOfReviews': numberOfReviews,
    };
  }
}