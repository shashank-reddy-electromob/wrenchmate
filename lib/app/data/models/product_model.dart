class Product {
  final String description;
  final int price;
  final String productName;
  final List<String> quantitiesAvailable; // Updated to List<String>
  final String quantity; // New field
  final int averageReview; // New field
  final int numberOfReviews; // New field

  Product({
    required this.description,
    required this.price,
    required this.productName,
    required this.quantitiesAvailable,
    required this.quantity,
    required this.averageReview,
    required this.numberOfReviews,
  });

  factory Product.fromDocument(Map<String, dynamic> doc) {
    return Product(
      description: doc['description'] ??
          '', // Providing default value in case the key is missing
      price: doc['price'] ??
          0, // Providing default value in case the key is missing
      productName: doc['product_name'] ??
          '', // Providing default value in case the key is missing
      quantitiesAvailable: List<String>.from(doc['quantities_available'] ??
          []), // Providing default value and ensuring it is a List<String>
      quantity: doc['quantity'] ??
          '', // Providing default value in case the key is missing
      averageReview: doc['averageReview'] ??
          0, // Providing default value in case the key is missing
      numberOfReviews: doc['numberofReviews'] ??
          0, // Providing default value in case the key is missing
    );
  }
}
