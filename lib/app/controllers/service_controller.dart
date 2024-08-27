import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../data/models/Service_Firebase.dart';
import '../data/models/faq_model.dart';
import '../data/models/review_model.dart';
import '../data/models/user_module.dart';

class ServiceController extends GetxController {
  var services = <ServiceFirebase>[].obs;
  var reviews = <Review>[].obs; // Use Review model
  var users = <User>[].obs;     // Use User model
  var faqs = <FAQ>[].obs;       // Use FAQ model
  var loading = true.obs; // Loading state
  var selectedService = Rxn<ServiceFirebase>(); // To store the selected service


  void fetchServices(String category) async {
    try {
      loading.value = true; // Start loading
      print("Fetching services for category: $category");
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Service')
          .where('category', isEqualTo: category)
          .get();
      print("Number of services fetched: ${querySnapshot.size}");

      // Fetch services
      services.value = querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        print("Service Data: $data");
        return ServiceFirebase(
          id: doc.id,
          category: data['category'] ?? '',
          description: data['description'] ?? '',
          discount: data['discount'] ?? 0,
          name: data['name'] ?? '',
          image: data['image'] ?? '',
          price: (data['price'] is int) ? (data['price'] as int).toDouble() : data['price']?.toDouble() ?? 0.0,
          time: data['time'] ?? '',
          warranty: data['warranty'] ?? '',
          averageReview: data['averageReview']?.toDouble() ?? 0.0,
          numberOfReviews: data['numberOfReviews'] ?? 0,
        );
      }).toList(); // Ensure the list type is correct

    } catch (e) {
      print("Error fetching services: $e");
    } finally {
      loading.value = false;
    }
  }

  // Function to fetch reviews for a specific service
  Future<void> fetchReviewsForService(ServiceFirebase service) async {
    try {
      QuerySnapshot reviewSnapshot = await FirebaseFirestore.instance
          .collection('Review')
          .where('serviceId', isEqualTo: service.id)
          .get();
      print("Number of reviews fetched for service ${service.id}: ${reviewSnapshot.size}");

      List<String> userIds = []; // Collect user IDs

      for (var doc in reviewSnapshot.docs) {
        var reviewData = doc.data() as Map<String, dynamic>;
        print("Review Data for service ${service.id}: $reviewData");
        reviews.add(Review(
          serviceId: reviewData['serviceId'],
          userId: reviewData['userId'],
          message: reviewData['message'],
          rating: (reviewData['rating'] is int) ? (reviewData['rating'] as int).toDouble() : reviewData['rating'] as double,
        ));
        userIds.add(reviewData['userId']); // Add user ID to the list
      }

      // Fetch user data for all user IDs
      await fetchUsers(userIds);

    } catch (e) {
      print("Error fetching reviews: $e");
    }
  }

  // Function to fetch FAQs for a specific service
  Future<void> fetchFAQsForService(String serviceId) async {
    try {
      QuerySnapshot faqSnapshot = await FirebaseFirestore.instance
          .collection('Faq')
          .where('serviceId', isEqualTo: serviceId)
          .get();
      print("Number of FAQs fetched for service $serviceId: ${faqSnapshot.size}");

      faqs.value = faqSnapshot.docs.map((doc) {
        var faqData = doc.data() as Map<String, dynamic>;
        print("FAQ Data for service $serviceId: $faqData");
        return FAQ(
          serviceId: faqData['serviceId'],
          question: faqData['question'],
          answer: faqData['answer'],
        );
      }).toList();
    } catch (e) {
      print("Error fetching FAQs: $e");
    }
  }

  // Function to fetch user data for multiple user IDs
  Future<void> fetchUsers(List<String> userIds) async {
    for (String userId in userIds) {
      await fetchUser(userId);
    }
  }

  // Function to fetch user data
  Future<void> fetchUser(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('User')
          .doc(userId)
          .get();
      
      if (userSnapshot.exists) {
        var userData = userSnapshot.data() as Map<String, dynamic>;
        print("User Data for user $userId: $userData");

        if (!users.any((user) => user.userEmail == userData['User_email'])) {
          users.add(User(
            userAddress: userData['User_address'] ?? '',
            userEmail: userData['User_email'] ?? '',
            userName: userData['User_name'] ?? '',
            userNumber: List<int>.from(userData['User_number'].map((num) {
              // Ensure each number is parsed correctly
              if (num is int) return num;
              return int.tryParse(num.toString()) ?? 0; // Handle parsing errors
            })), // Convert to List<int>
            userProfileImage: userData['User_profile_image'] ?? '',
          ));
        }
      } else {
        print("User with ID $userId does not exist.");
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  // Function to fetch service by ID
  Future<void> fetchServiceById(String serviceId) async {
    try {
      print("fetching the service by id $serviceId");
      loading.value = true; // Start loading
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Service')
          .doc(serviceId)
          .get();
      var data = doc.data() as Map<String, dynamic>;
      print("returned $data ");
      selectedService.value = ServiceFirebase(
        averageReview: data['averageReview']?.toDouble() ?? 0.0, // Ensure this is a double
        numberOfReviews: data['numberOfReviews'] ?? 0, // Ensure this is an int
        id: doc.id,
        category: data['category'] ?? '',
        description: data['description'] ?? '',
        discount: data['discount'] ?? 0,
        name: data['name'] ?? '',
        image: data['image'] ?? '',
        price: (data['price'] is int) ? (data['price'] as int).toDouble() : data['price']?.toDouble() ?? 0.0,
        time: data['time'] ?? '',
        warranty: data['warranty'] ?? '',
      );
      print("calling fetchReviews");
      await fetchReviewsForService(selectedService.value!);
      print("Fetched reviews for service: ${selectedService.value!.id}");
      await fetchFAQsForService(serviceId);
      print("Fetched FAQs for service: $serviceId");

      // Fetch user data for each review
      for (var review in reviews) {
        await fetchUser(review.userId);
      }
    } catch (e) {
      print("Error fetching service by ID: $e");
    } finally {
      loading.value = false; // Stop loading
    }
  }

  Future<void> fetchServiceDataById(String serviceId) async {
    try {
      print("Fetching service data by ID: $serviceId");
      loading.value = true; 
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Service')
          .doc(serviceId)
          .get();
      var data = doc.data() as Map<String, dynamic>;
      print("Returned service data: $data");

      services.add(ServiceFirebase(
        averageReview: data['averageReview']?.toDouble() ?? 0.0,
        numberOfReviews: data['numberOfReviews'] ?? 0,
        id: doc.id,
        category: data['category'] ?? '',
        description: data['description'] ?? '',
        discount: data['discount'] ?? 0,
        name: data['name'] ?? '',
        image: data['image'] ?? '',
        price: (data['price'] is int) ? (data['price'] as int).toDouble() : data['price']?.toDouble() ?? 0.0,
        time: data['time'] ?? '',
        warranty: data['warranty'] ?? '',
      ));
    } catch (e) {
      print("Error fetching service data by ID: $e");
    } finally {
      loading.value = false; // Stop loading
    }
  }

  // Function to add a new review
  Future<void> addReview(String serviceId, String userId, String message, double rating) async {
    try {
      // Create a new review document
      await FirebaseFirestore.instance.collection('Review').add({
        'serviceId': serviceId,
        'userId': userId,
        'message': message,
        'rating': rating,
      });
      print("Review added successfully.");
    } catch (e) {
      print("Error adding review: $e");
      // Handle error appropriately (e.g., show a message to the user)
    }
  }
}