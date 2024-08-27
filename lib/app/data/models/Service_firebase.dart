class ServiceFirebase {
  String id;
  String category;
  String description;
  int discount;
  String name;
  String image;
  double price;
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
      'image': image,
      'price': price,
      'time': time,
      'warranty': warranty,
      'averageReview': averageReview,
      'numberOfReviews': numberOfReviews,
    };
  }

  factory ServiceFirebase.fromMap(Map<String, dynamic> map, String id) {
    return ServiceFirebase(
      id: id,
      category: map['category'] ?? '',
      description: map['description'] ?? '',
      discount: map['discount'] ?? 0,
      name: map['name'] ?? '',
      image: map['image'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      time: map['time'] ?? '',
      warranty: map['warranty'] ?? '',
      averageReview: map['averageReview']?.toDouble() ?? 0.0,
      numberOfReviews: map['numberOfReviews'] ?? 0,
    );
  }
}
