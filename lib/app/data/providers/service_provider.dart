import '../models/service_model.dart';

final List<Service> services = [
  Service(
    imagePath: 'assets/images/weekend.png',
    name: 'Car Wash',
    price: '25',
    description:
        'A comprehensive car wash service including exterior and interior cleaning.',
    reviews: [
      Review(
        name: 'John Doe',
        profileImage: 'assets/images/weekend.png',
        reviewText: 'Great service! My car looks brand new.',
        rating: 4.5,
      ),
      Review(
        name: 'Jane Smith',
        profileImage: 'assets/images/weekend.png',
        reviewText: 'Good value for the price. Friendly staff.',
        rating: 4.0,
      ),
    ],
    numberOfReviews: 2,
    time: '1',
    warrantyDuration: '1 month',
    faqs: [
      FAQ(
        question: 'How long does the service take?',
        answer: 'The service usually takes around 1 hour.',
      ),
      FAQ(
        question: 'Do you use eco-friendly products?',
        answer:
            'Yes, we use eco-friendly cleaning products for all our services.',
      ),
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
      Review(
        name: 'Alice Brown',
        profileImage: 'assets/images/weekend.png',
        reviewText: 'Quick and efficient service. Highly recommended.',
        rating: 5.0,
      ),
      Review(
        name: 'Bob Johnson',
        profileImage: 'assets/images/weekend.png',
        reviewText: 'Satisfied with the service. Will come back again.',
        rating: 4.2,
      ),
    ],
    numberOfReviews: 2,
    time: '0.5',
    warrantyDuration: '3 months',
    faqs: [
      FAQ(
        question: 'Do you offer synthetic oil?',
        answer: 'Yes, we offer both conventional and synthetic oil options.',
      ),
      FAQ(
        question: 'Is an appointment necessary?',
        answer:
            'While not necessary, appointments are recommended for faster service.',
      ),
    ],
    category: 'Breaks',
  ),
];
