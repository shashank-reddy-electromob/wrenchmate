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
      price: doc['price'] ?? 0,
      productName: doc['product_name'] ?? '',
      image: doc['image'] ?? 'https://via.placeholder.com/150',
      quantitiesAvailable: List<String>.from(doc['quantities_available'] ?? []),
      pricesAvailable: List<String>.from(doc['prices_available'] ?? []),
      quantity: doc['quantity'] ?? '',
      averageReview: (doc['averageReview'] is int
          ? (doc['averageReview'] as int).toDouble()
          : (doc['averageReview'] as double? ?? 0.0)),
      numberOfReviews: doc['numberofReviews'] ?? 0,
    );
  }
  double getPriceForQuantity(String selectedQuantity) {
    int index = quantitiesAvailable.indexOf(selectedQuantity);
    if (index != -1 && index < pricesAvailable.length) {
      return double.parse(pricesAvailable[index]);
    }
    return 0.0; 
  }
}
