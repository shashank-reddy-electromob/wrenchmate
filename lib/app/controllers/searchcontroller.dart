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
  var popularServices = <ServiceFirebase>[].obs;
  var topCategories = <ServiceFirebase>[].obs;
  var topServices = <ServiceFirebase>[].obs;

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

      print(
          "Top Services Document: ${doc.data()}"); // Print document data for debugging

      List<dynamic> serviceIdsTopServices = doc['top services'] ?? [];
      List<Future<void>> fetchServiceFutures =
          serviceIdsTopServices.map((serviceId) async {
        DocumentSnapshot serviceDoc = await FirebaseFirestore.instance
            .collection('Service')
            .doc(serviceId)
            .get();

        if (serviceDoc.exists) {
          ServiceFirebase service = ServiceFirebase.fromMap(
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
          ServiceFirebase service = ServiceFirebase.fromMap(
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
          ServiceFirebase service = ServiceFirebase.fromMap(
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
}
