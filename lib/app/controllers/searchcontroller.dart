import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wrenchmate_user_app/app/controllers/service_controller.dart';
import 'package:wrenchmate_user_app/app/data/models/Service_firebase.dart';

class SearchControllerClass extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final RxList<QueryDocumentSnapshot> searchResults =
      <QueryDocumentSnapshot>[].obs;
  final RxList<String> searchHistory = <String>[].obs;
  final ServiceController serviceController = Get.find();
  var popularServices = <Servicefirebase>[].obs;
  var topCategories = <Servicefirebase>[].obs;
  var topServices = <Servicefirebase>[].obs;

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(_onSearchChanged);
    _loadSearchHistory();
    fetchTopServices();
    fetchTopCategories();
    fetchPopularServices();
    testFetchTopServices();
  }

  void testFetchTopServices() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('Top Services')
        .doc('6zik3gDPzVILHjoDaxNO')
        .get();

    print("Document data: ${doc.data()}");
  }

// disp
  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void _onSearchChanged() {
    String query = searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      FirebaseFirestore.instance.collection('Service').get().then((snapshot) {
        List<QueryDocumentSnapshot> filteredDocs = snapshot.docs.where((doc) {
          String serviceName = (doc['name'] as String).toLowerCase();
          return serviceName.contains(query);
        }).toList();

        searchResults.value = filteredDocs;
      }).catchError((error) {
        print('Error occurred: $error');
      });
    } else {
      searchResults.clear();
    }
  }

  Future<void> _fetchServiceDetails(String serviceId) async {
    await serviceController.fetchServiceDataById(serviceId);
  }

  Future<void> fetchTopServices() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Top Services')
          .doc('6zik3gDPzVILHjoDaxNO')
          .get();

      print("Top Services Document: ${doc.data()}");

      List<dynamic> serviceIdsTopServices = doc['top services'] ?? [];
      List<Future<void>> fetchServiceFutures =
          serviceIdsTopServices.map((serviceId) async {
        DocumentSnapshot serviceDoc = await FirebaseFirestore.instance
            .collection('Service')
            .doc(serviceId)
            .get();

        if (serviceDoc.exists) {
          Servicefirebase service = Servicefirebase.fromMap(
              serviceDoc.data() as Map<String, dynamic>, serviceId);
          topServices.add(service);
        }
      }).toList();

      await Future.wait(fetchServiceFutures);
      print("Top services fetched successfully.");
    } catch (e) {
      print("Error fetching top services: $e");
    }
  }

  Future<void> fetchTopCategories() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Top Services')
          .doc('6zik3gDPzVILHjoDaxNO')
          .get();

      List<dynamic> serviceIdsTopCategories = doc['top category'] ?? [];
      List<Future<void>> fetchServiceFutures =
          serviceIdsTopCategories.map((serviceId) async {
        DocumentSnapshot serviceDoc = await FirebaseFirestore.instance
            .collection('Service')
            .doc(serviceId)
            .get();

        print("Service Document: ${serviceDoc.data()}");

        if (serviceDoc.exists) {
          Servicefirebase service = Servicefirebase.fromMap(
              serviceDoc.data() as Map<String, dynamic>, serviceId);
          topCategories.add(service);
        }
      }).toList();

      await Future.wait(fetchServiceFutures);
      print("Top categories fetched successfully.");
    } catch (e) {
      print("Error fetching top categories: $e");
    }
  }

  Future<void> fetchPopularServices() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Top Services')
          .doc('6zik3gDPzVILHjoDaxNO')
          .get();

      List<dynamic> serviceIdsPopularServices = doc['popular services'] ?? [];
      List<Future<void>> fetchServiceFutures =
          serviceIdsPopularServices.map((serviceId) async {
        DocumentSnapshot serviceDoc = await FirebaseFirestore.instance
            .collection('Service')
            .doc(serviceId)
            .get();

        print("Service Document: ${serviceDoc.data()}");

        if (serviceDoc.exists) {
          Servicefirebase service = Servicefirebase.fromMap(
              serviceDoc.data() as Map<String, dynamic>, serviceId);
          popularServices.add(service);
        }
      }).toList();

      await Future.wait(fetchServiceFutures);
      print("Popular services fetched successfully.");
    } catch (e) {
      print("Error fetching popular services: $e");
    }
  }

  Future<void> _loadSearchHistory() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      QuerySnapshot searchHistorySnapshot = await FirebaseFirestore.instance
          .collection('User')
          .doc(userId)
          .collection('SearchHistory')
          .get();

      List<String> services = [];
      List<Future<void>> fetchServiceFutures = [];

      for (QueryDocumentSnapshot doc in searchHistorySnapshot.docs) {
        List<dynamic> serviceIds = doc['user search'] ?? [];

        for (String serviceId in serviceIds) {
          fetchServiceFutures.add(_fetchServiceDetails(serviceId));
        }
      }

      await Future.wait(fetchServiceFutures);

      services =
          serviceController.services.map((service) => service.name).toList();
      searchHistory.assignAll(services);
      print('Search History: $searchHistory');
    } catch (e) {
      print('Error loading search history: $e');
    }
  }

  // var searchFilterResults = <QueryDocumentSnapshot>[];
  // List<String> selectedServices = [];
  // String selectedDiscount = '';
  // String selectedRating = '';
  // double minPrice = 0;
  // double maxPrice = double.infinity;

  RxList<QueryDocumentSnapshot> searchFilterResults =
      <QueryDocumentSnapshot>[].obs;

  Future<void> fetchFilteredSearchResults({
    List<String> selectedServices = const [],
    String selectedDiscount = '',
    String selectedRating = '',
    double minPrice = 0,
    double maxPrice = double.infinity,
  }) async {
    try {
      print("inside fetchFilteredSearchResults");
      print("selectedServices :: $selectedServices");
      print("selectedDiscount :: $selectedDiscount");
      print("selectedRating :: $selectedRating");
      print("minPrice :: $minPrice");
      print("maxPrice :: $maxPrice");

      Query query = FirebaseFirestore.instance.collection('Service');

      if (selectedServices.isNotEmpty) {
        query = query.where('category', whereIn: selectedServices);
        print("Filter Applied: category whereIn $selectedServices");
      }

      if (selectedDiscount.isNotEmpty) {
        query = query.where('discount', isEqualTo: selectedDiscount);
        print("Filter Applied: discount isEqualTo $selectedDiscount");
      }

      if (selectedRating.isNotEmpty) {
        query = query.where('averageReview',
            isGreaterThanOrEqualTo: double.parse(selectedRating));
        print(
            "Filter Applied: averageReview isGreaterThanOrEqualTo $selectedRating");
      }

      if (minPrice != 0 || maxPrice != double.infinity) {
        query = query
            .where('price', isGreaterThanOrEqualTo: minPrice)
            .where('price', isLessThanOrEqualTo: maxPrice);
        print("Filter Applied: price range from $minPrice to $maxPrice");
      }

      // Print the final query setup for debugging purposes
      print("Executing Query: ${query.toString()}");

      QuerySnapshot snapshot = await query.get();

      print('Number of documents retrieved: ${snapshot.docs.length}');

      for (var result in snapshot.docs) {
        print('Document ID: ${result.id}');
        print('Document Data: ${result.data()}');
      }

      searchFilterResults.value = snapshot.docs;

      update();
    } catch (e) {
      print('Error fetching search results: $e');
    }
  }

  // Future<void> search(String queryString) async {
  //   if (queryString.isEmpty) {
  //     searchFilterResults = [];
  //     update();
  //     return;
  //   }

  //   Query query = FirebaseFirestore.instance
  //       .collection('Service')
  //       .where('name', isGreaterThanOrEqualTo: queryString)
  //       .where('name', isLessThanOrEqualTo: queryString + '\uf8ff');

  //   QuerySnapshot snapshot = await query.get();

  //   searchFilterResults = snapshot.docs;
  //   update();
  // }
}
