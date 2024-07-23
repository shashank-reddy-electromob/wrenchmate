import 'package:wrenchmate_user_app/app/data/models/review_model.dart';

import 'faq_model.dart';
class Service {
  final String? imagePath;//
  final String name;
  final String price;
  final String description;
  final List<Review> reviews;//
  final int numberOfReviews;
  final String time;
  final String warrantyDuration;
  final List<FAQ> faqs;//
  final String category;

  Service({
     this.imagePath,
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
