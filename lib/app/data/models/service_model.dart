class Review {
  final String name;
  final String profileImage;
  final String reviewText;
  final double rating;

  Review({
    required this.name,
    required this.profileImage,
    required this.reviewText,
    required this.rating,
  });
}

class FAQ {
  final String question;
  final String answer;
  bool isExpanded;

  FAQ({
    required this.question,
    required this.answer,
    this.isExpanded = false,
  });
}

class Service {
  final String imagePath;
  final String name;
  final String price;
  final String description;
  final List<Review> reviews;
  final int numberOfReviews;
  final String time;
  final String warrantyDuration;
  final List<FAQ> faqs;
  final String category;

  Service({
    required this.imagePath,
    required this.name,
    required this.price,
    required this.description,
    required this.reviews,
    required this.numberOfReviews,
    required this.time,
    required this.warrantyDuration,
    required this.faqs,
    required this.category,
  });
  double get averageRating {
    double totalRating = reviews.fold(0, (sum, review) => sum + review.rating);
    return totalRating / reviews.length;
  }
}
