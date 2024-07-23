import '../models/faq_model.dart';
import '../models/review_model.dart';
import '../models/service_model.dart';

final List<Service> services = [
  Service(
    imagePath: 'assets/images/weekend.png',
    name: 'Car Wash',
    price: '25',
    description:
        'A comprehensive car wash service including exterior and interior cleaning.',
    reviews: [
    ],
    numberOfReviews: 2,
    time: '1',
    warrantyDuration: '1 month',
    faqs: [
    ],
    category: 'AC',
  ),
  Service(
    imagePath: 'assets/images/weekend.png',
    name: 'Oil Change',
    price: '40',
    description:
        'Complete oil change service including oil filter replacement.',
    reviews: [
    ],
    numberOfReviews: 2,
    time: '0.5',
    warrantyDuration: '3 months',
    faqs: [
    ],
    category: 'Breaks',
  ),
];
