import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wrenchmate_user_app/app/controllers/service_controller.dart';
import 'package:wrenchmate_user_app/app/data/models/Service_firebase.dart';

class SearchControllerClass extends GetxController {
  // final ServiceController serviceController = Get.find();
  final TextEditingController searchController = TextEditingController();
  final RxList<QueryDocumentSnapshot> searchResults =
      <QueryDocumentSnapshot>[].obs;
  final RxList<String> searchHistory = <String>[].obs;
  final ServiceController serviceController = Get.find();
  var popularServices = <ServiceFirebase>[].obs;
  var topCategories = <ServiceFirebase>[].obs;
  var topServices = <ServiceFirebase>[].obs;

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(_onSearchChanged);
    _loadSearchHistory();
    // fetchTopCategories();
    // fetchTopServices();
    // fetchPopularServices();
  }

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
  // final ServiceController serviceController = Get.find();

  Future<void> _fetchServiceDetails(String serviceId) async {
    await serviceController.fetchServiceDataById(serviceId);
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
          print('Service ID: $serviceId');
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

  Future<void> fetchTopCategories() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Top Services')
          .doc('6zik3gDPzVILHjoDaxNO')
          .get();
      List<String> categoryIds = List<String>.from(doc['top category'] ?? []);
      print("top category :: $categoryIds");

      List<Future<void>> fetchCategoryFutures =
          categoryIds.map((id) => _fetchServiceDetails(id)).toList();
      await Future.wait(fetchCategoryFutures);
      print("fetchCategoryFutures :: $fetchCategoryFutures");
      topCategories
          .assignAll(serviceController.services as Iterable<ServiceFirebase>);
          
    } catch (e) {
      print('Error fetching top categories: $e');
    }
  }

  Future<void> fetchTopServices() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Top Services')
          .doc('6zik3gDPzVILHjoDaxNO')
          .get();
      List<String> serviceIds = List<String>.from(doc['top services'] ?? []);
      print("top services :: $serviceIds");

      List<Future<void>> fetchServiceFutures =
          serviceIds.map((id) => _fetchServiceDetails(id)).toList();
      await Future.wait(fetchServiceFutures);

      topServices
          .assignAll(serviceController.services as Iterable<ServiceFirebase>);
    } catch (e) {
      print('Error fetching top services: $e');
    }
  }

  Future<void> fetchPopularServices() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Top Services')
          .doc('6zik3gDPzVILHjoDaxNO')
          .get();
      List<String> serviceIds =
          List<String>.from(doc['popular services'] ?? []);
      print("popular services :: $serviceIds");
      List<Future<void>> fetchServiceFutures =
          serviceIds.map((id) => _fetchServiceDetails(id)).toList();
      await Future.wait(fetchServiceFutures);

      popularServices
          .assignAll(serviceController.services as Iterable<ServiceFirebase>);
    } catch (e) {
      print('Error fetching popular services: $e');
    }
  }
}
