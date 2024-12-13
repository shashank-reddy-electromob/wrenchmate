import 'dart:math';

class Product {
  String id;
  final String description;
  final int price;
  final String productName;
  final String image;
  final List<String> quantitiesAvailable;
  final List<String> pricesAvailable;
  final String quantity;
  final double averageReview;
  final int numberOfReviews;

  Product({
    required this.id,
    required this.description,
    required this.price,
    required this.productName,
    required this.image,
    required this.quantitiesAvailable,
    required this.pricesAvailable,
    required this.quantity,
    required this.averageReview,
    required this.numberOfReviews,
  });

  factory Product.fromDocument(Map<String, dynamic> doc, String id) {
    return Product(
      id: id,
      description: doc['description'] ?? '',
      price: (doc['price'] is int)
          ? doc['price']
          : int.tryParse(doc['price']?.toString() ?? '0') ?? 0,
      productName: doc['product_name'] ?? '',
      image: doc['image'] ?? 'https://via.placeholder.com/150',
      quantitiesAvailable: doc['quantities_available'] is List
          ? List<String>.from(doc['quantities_available'])
          : [],
      pricesAvailable: doc['prices_available'] is List
          ? List<String>.from(doc['prices_available'])
          : [],
      quantity: doc['quantity'] ?? '',
      averageReview: (doc['averageReview'] is int)
          ? (doc['averageReview'] as int).toDouble()
          : (doc['averageReview'] as double? ?? 0.0),
      numberOfReviews: doc['numberOfReviews'] ?? 0,
    );
  }

  double getPriceForQuantity(String selectedQuantity) {
    int index = quantitiesAvailable.indexOf(selectedQuantity);
    if (index != -1 && index < pricesAvailable.length) {
      return double.tryParse(pricesAvailable[index]) ?? 0.0;
    }
    return double.tryParse(pricesAvailable[0]) ?? 0.0;
  }
}
