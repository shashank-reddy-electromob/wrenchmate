class Product {
  final String description;
  final int price;
  final String productName;
  final String image;
  final List<String> quantitiesAvailable; // Updated to List<String>
  final String quantity; // New field
  final double averageReview; // New field
  final int numberOfReviews; // New field

  Product({
    required this.description,
    required this.price,
    required this.productName,
    required this.image,
    required this.quantitiesAvailable,
    required this.quantity,
    required this.averageReview,
    required this.numberOfReviews,
  });

  factory Product.fromDocument(Map<String, dynamic> doc) {
    return Product(
      description: doc['description'] ?? '',
      price: doc['price'] ?? 0,
      productName: doc['product_name'] ?? '',
      image: doc['image'] ?? 'https://via.placeholder.com/150',
      quantitiesAvailable: List<String>.from(doc['quantities_available'] ?? []),
      quantity: doc['quantity'] ?? '',
      averageReview: (doc['averageReview'] is int
          ? (doc['averageReview'] as int).toDouble()
          : (doc['averageReview'] as double? ??
              0.0)), // Handle both int and double
      numberOfReviews: doc['numberofReviews'] ?? 0,
    );
  }
}
