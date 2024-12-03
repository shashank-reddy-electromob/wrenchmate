import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../data/models/Service_firebase.dart';
import '../data/models/faq_model.dart';
import '../data/models/review_model.dart';
import '../data/models/user_module.dart';

class ServiceController extends GetxController {
  var services = <Servicefirebase>[].obs;
  var filteredServices = <Servicefirebase>[].obs;
  var reviews = <Review>[].obs; // Use Review model
  var users = <User>[].obs; // Use User model
  var faqs = <FAQ>[].obs; // Use FAQ model
  var loading = false.obs; // Loading state
  var selectedService = Rxn<Servicefirebase>(); // To store the selected service
  var isFiltering = false.obs;

  Future<void> fetchServices(String category) async {
    try {
      // loading.value = true; // Start loading
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
        return Servicefirebase(
          id: doc.id,
          category: data['category'] ?? '',
          description: data['description'] ?? '',
          discount: data['discount'] ?? 0,
          name: data['name'] ?? '',
          image: data['image'] ?? '',
          price: (data['price'] is int)
              ? (data['price'] as int).toDouble()
              : data['price']?.toDouble() ?? 0.0,
          time: data['time'] ?? '',
          warranty: data['warranty'] ?? '',
          averageReview: data['averageReview']?.toDouble() ?? 0.0,
          numberOfReviews: data['numberOfReviews'] ?? 0,
          carmodel: List<String>.from(data['carmodel'] ?? []),
        );
      }).toList(); // Ensure the list type is correct
    } catch (e) {
      print("Error fetching services: $e");
    } finally {
      // loading.value = false;
    }
  }

  Future<void> fetchReviewsForService(Servicefirebase service) async {
    try {
      QuerySnapshot reviewSnapshot = await FirebaseFirestore.instance
          .collection('Review')
          .where('serviceId', isEqualTo: service.id)
          .get();
      print(
          "Number of reviews fetched for service ${service.id}: ${reviewSnapshot.size}");

      List<String> userIds = [];

      for (var doc in reviewSnapshot.docs) {
        var reviewData = doc.data() as Map<String, dynamic>;
        print("Review Data for service ${service.id}: $reviewData");
        reviews.add(Review(
          productId: "NA",
          serviceId: reviewData['serviceId'],
          userId: reviewData['userId'],
          message: reviewData['message'],
          rating: (reviewData['rating'] is int)
              ? (reviewData['rating'] as int).toDouble()
              : reviewData['rating'] as double,
        ));
        userIds.add(reviewData['userId']); // Add user ID to the list
      }

      // Fetch user data for all user IDs
      await fetchUsers(userIds);
    } catch (e) {
      print("Error fetching reviews: $e");
    }
  }

  Future<void> fetchFAQsForService(String serviceId) async {
    try {
      QuerySnapshot faqSnapshot = await FirebaseFirestore.instance
          .collection('Faq')
          .where('serviceId', isEqualTo: serviceId)
          .get();
      print(
          "Number of FAQs fetched for service $serviceId: ${faqSnapshot.size}");

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
      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('User').doc(userId).get();

      if (userSnapshot.exists) {
        var userData = userSnapshot.data() as Map<String, dynamic>;
        print("User Data for user $userId: $userData");

        if (!users.any((user) => user.userEmail == userData['User_email'])) {
          users.add(User(
            userAddress: userData['User_address'][0] ?? '',
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
      print("Fetching service by ID: $serviceId");
      // loading.value = true;
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Service')
          .doc(serviceId)
          .get();

      var data = doc.data();
      if (data != null) {
        var serviceData = data as Map<String, dynamic>;
        print("Returned service data: $serviceData");

        selectedService.value = Servicefirebase(
          id: doc.id,
          category: serviceData['category'] ?? '',
          description: serviceData['description'] ?? '',
          discount: serviceData['discount'] ?? 0,
          name: serviceData['name'] ?? '',
          image: serviceData['image'] ?? '',
          price: (serviceData['price'] is int)
              ? (serviceData['price'] as int).toDouble()
              : serviceData['price']?.toDouble() ?? 0.0,
          time: serviceData['time'] ?? '',
          warranty: serviceData['warranty'] ?? '',
          averageReview: serviceData['averageReview']?.toDouble() ?? 0.0,
          numberOfReviews: serviceData['numberOfReviews'] ?? 0,
          carmodel: List<String>.from(serviceData['carmodel'] ?? []),
        );

        await fetchReviewsForService(selectedService.value!);
        await fetchFAQsForService(serviceId);
      } else {
        print("Service with ID $serviceId does not exist.");
      }
    } catch (e) {
      print("Error fetching service by ID: $e");
    } finally {
      // loading.value = false;
    }
  }

  Future<void> fetchServiceDataById(String serviceId) async {
    try {
      print("Fetching service data by ID: $serviceId");
      // loading.value = true;
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Service')
          .doc(serviceId)
          .get();
      var data = doc.data() as Map<String, dynamic>;
      print("Returned service data: $data");

      services.add(Servicefirebase(
        averageReview: data['averageReview']?.toDouble() ?? 0.0,
        numberOfReviews: data['numberOfReviews'] ?? 0,
        id: doc.id,
        category: data['category'] ?? '',
        description: data['description'] ?? '',
        discount: data['discount'] ?? 0,
        name: data['name'] ?? '',
        image: data['image'] ?? '',
        price: (data['price'] is int)
            ? (data['price'] as int).toDouble()
            : data['price']?.toDouble() ?? 0.0,
        time: data['time'] ?? '',
        warranty: data['warranty'] ?? '',
        carmodel: List<String>.from(data['carmodel'] ?? []),
      ));
    } catch (e) {
      print("Error fetching service data by ID: $e");
    } finally {
      // loading.value = false; // Stop loading
    }
  }

  // Function to add a new review
  Future<void> addReview(
      String serviceId, String userId, String message, double rating) async {
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

  Future<void> addDriverReview(String userId, String message, String phone,
      String name, double rating) async {
    try {
      // Create a new review document
      await FirebaseFirestore.instance.collection('DriverReview').add({
        'userId': userId,
        'phone': phone,
        'name': name,
        'message': message,
        'rating': rating,
      });
      print("Review added successfully.");
    } catch (e) {
      print("Error adding review: $e");
      // Handle error appropriately (e.g., show a message to the user)
    }
  }

  Future<void> fetchServicesForUser(
      String category, List<String> userCarDetails) async {
    try {
      loading.value = true;
      print("Fetching services for category: $category");
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Service')
          .where('category', isEqualTo: category)
          .get();
      print("Number of services fetched: ${querySnapshot.size}");
      filteredServices.clear();
      services.clear();
      // Fetch services
      // services.value = querySnapshot.docs.map((doc) {
      //   var data = doc.data() as Map<String, dynamic>;
      //   // final temp = Servicefirebase.fromMap(data, doc.id);
      //   // print(temp);
      //   // print(data.toString());
      //   return Servicefirebase(
      //     id: doc.id,
      //     category: data['category'] ?? '',
      //     description: data['description'] ?? '',
      //     discount: data['discount'] ?? 0,
      //     name: data['name'] ?? '',
      //     image: data['image'] ?? '',
      //     price: (data['price'] is int)
      //         ? (data['price'] as int).toDouble()
      //         : data['price']?.toDouble() ?? 0.0,
      //     time: data['time'].toString() ?? '',
      //     warranty: data['warranty'] ?? '',
      //     averageReview: data['averageReview']?.toDouble() ?? 0.0,
      //     numberOfReviews: data['numberOfReviews'] ?? 0,
      //     carmodel: List<String>.from(data['carmodel'] ?? []),
      //   );
      // }).where((service) {
      //   // Filter services based on user's car models
      //   return service.carmodel.any((model) {
      //     return userCarDetails.any((carDetail) {
      //       return carDetail.split(';')[0] == model;
      //     });
      //   });
      // }).toList();

      List<Servicefirebase> allServices = querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;

        print("Raw Data for ${doc.id}: ${data}");

        return Servicefirebase(
          id: doc.id,
          category: data['category'] ?? '',
          description: data['description'] ?? '',
          discount: data['discount'] ?? 0,
          name: data['name'] ?? '',
          image: data['image'] ?? '',
          price: (data['price'] is int)
              ? (data['price'] as int).toDouble()
              : data['price']?.toDouble() ?? 0.0,
          time: data['time'].toString() ?? '',
          warranty: data['warranty'] ?? '',
          averageReview: data['averageReview']?.toDouble() ?? 0.0,
          numberOfReviews: data['numberOfReviews'] ?? 0,
          carmodel: List<String>.from(data['carmodel'] ?? []),
        );
      }).toList();

      List<Servicefirebase> filteredServicesList = allServices.where((service) {
        // print("Checking service: ${service.name}");
        // print(
        //     "Service car models: ${service.carmodel}"); // Debug: What are the car models for this service?

        // Extract only the car models from userCarDetails for comparison
        List<String> userCarModels = userCarDetails.map((carDetail) {
          String carModel =
              carDetail.split(';')[0]; // Extract the car model part
          // print(
          //     "Extracted user car model: $carModel"); // Debug: Ensure car models are correctly extracted
          return carModel;
        }).toList();

        // print("User Car Models for comparison: $userCarModels");

        // Check if service matches any user car model
        bool matches = service.carmodel.any((serviceModel) {
          // print(
          //     "Comparing service model: $serviceModel with user models: $userCarModels"); // Debug
          if (userCarModels.contains(serviceModel)) {
            // print("Match found: $serviceModel matches with $userCarModels");
            return true;
          }
          return false;
        });

        // if (!matches) {
        //   print("Service '${service.name}' does not match any user car model.");
        // }
        return matches;
      }).toList();

      services.value = filteredServicesList;

      print("Filtered services count: ${filteredServicesList.length}");

      filteredServices.value = List.from(services);
    } catch (e) {
      print("Error fetching services: $e");
    } finally {
      loading.value = false;
    }
  }

  void filterServices(String query) {
    if (query.isEmpty) {
      filteredServices.assignAll(services);
    } else {
      filteredServices.assignAll(
        services.where((service) =>
            service.name.toLowerCase().contains(query.toLowerCase())),
      );
    }
  }
}
