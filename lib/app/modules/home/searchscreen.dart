import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wrenchmate_user_app/app/modules/home/widgits/services.dart';
import 'package:wrenchmate_user_app/app/modules/home/widgits/toprecommendedservices.dart';
import 'package:wrenchmate_user_app/app/routes/app_routes.dart';
import 'package:wrenchmate_user_app/app/widgets/custombackbutton.dart';
import 'package:wrenchmate_user_app/utils/textstyles.dart';
import '../../controllers/service_controller.dart';
import '../../data/models/Service_firebase.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ServiceController serviceController = Get.put(ServiceController());
  final TextEditingController _searchController = TextEditingController();
  
  List<Servicefirebase> services = <Servicefirebase>[];
  List<Servicefirebase> _resultList = [];
  List<Servicefirebase> topServices = [];
  List<String> topServiceIds = [];
  List<String> topCategories = [];
  List<String> searchHistory = [];
  bool _isSearching = false;
  bool _isLoading = true;

  final Map<String, String> categoryImageMap = {
    'Car Wash': 'assets/services/car wash.png',
    'Detailing': 'assets/services/detailing.png',
    'Denting & Painting': 'assets/services/painting.png',
    'Repair': 'assets/services/repair.png',
    'Accessories': 'assets/services/accessories.png',
    'Wheel Service': 'assets/services/wheelservice.png',
    'Body Parts': 'assets/services/body parts.png',
    'General Service': 'assets/services/general service.png',
  };

  @override
  void initState() {
    super.initState();
    _initialize();
    _searchController.addListener(_onSearchChange);
  }

  Future<void> _initialize() async {
    try {
      await Future.wait([
        getClientData(),
        getTopCategories(),
        getSearchHistory(),
        getTopServiceIds(),
      ]);
      
      final filterArgs = Get.arguments;
      if (filterArgs != null) {
        await _applyFilters(
          filterArgs['selectedServices'],
          filterArgs['selectedDiscount'],
          filterArgs['selectedRating'],
          filterArgs['minPrice'],
          filterArgs['maxPrice'],
        );
      } else {
        setState(() {
          _resultList = List.from(services);
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Initialization error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> getTopCategories() async {
    try {
      var data = await FirebaseFirestore.instance.collection("topCategory").get();
      topCategories = data.docs.map((doc) => doc['category'] as String).toList();
      setState(() {});
    } catch (e) {
      print('Error fetching top categories: $e');
    }
  }

  Future<void> getTopServiceIds() async {
    try {
      var data = await FirebaseFirestore.instance.collection("topServices").get();
      topServiceIds = data.docs.map((doc) => doc['serviceId'] as String).toList();
      setState(() {});
    } catch (e) {
      print('Error fetching top service IDs: $e');
    }
  }

  Future<void> getSearchHistory() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      searchHistory = prefs.getStringList('searchHistory') ?? [];
      setState(() {});
    } catch (e) {
      print('Error fetching search history: $e');
    }
  }

  Future<void> _applyFilters(
    List<String>? selectedServices,
    String? selectedDiscount,
    String? selectedRating,
    double? minPrice,
    double? maxPrice,
  ) async {
    if (services.isEmpty) {
      print('Services list is empty when applying filters');
      return;
    }

    print("Before filtering: ${services.length} services");
    services.forEach((service) {
      print("Service: ${service.name}, Category: ${service.category}, Discount: ${service.discount}, Rating: ${service.averageReview}, Price: ${service.price}");
    });

    // Parse discount value
    double? discountValue;
    if (selectedDiscount != null) {
      final cleanDiscount = selectedDiscount.replaceAll('%', '');
      final discountRange = cleanDiscount.split('-');
      discountValue = double.tryParse(
        discountRange.length == 2 ? discountRange[0] : cleanDiscount
      );
    }

    // Parse rating value
    double? ratingValue;
    if (selectedRating != null) {
      final cleanRating = selectedRating
          .replaceAll('>', '')
          .replaceAll('⭐', '')
          .trim();
      ratingValue = double.tryParse(cleanRating);
    }

    // Apply filters
    final filteredList = services.where((service) {
      print("\nEvaluating Service: ${service.name}");
      
      // Category filter
      final categoryMatch = selectedServices?.isEmpty ?? true
          ? true
          : selectedServices?.contains(service.category) ?? false;

      // Discount filter
      final discountMatch = discountValue == null
          ? true
          : service.discount >= discountValue;

      // Rating filter
      final ratingMatch = ratingValue == null
          ? true
          : service.averageReview > ratingValue;

      // Price range filter
      final priceMatch = (minPrice == null || service.price >= minPrice) &&
          (maxPrice == null || service.price <= maxPrice);

      print("Category Match: $categoryMatch");
      print("Discount Match: $discountMatch");
      print("Rating Match: $ratingMatch");
      print("Price Match: $priceMatch");

      return categoryMatch && discountMatch && ratingMatch && priceMatch;
    }).toList();

    setState(() {
      _isSearching = true;
      _resultList = filteredList;
      _isLoading = false;
    });

    print("\nAfter filtering: ${_resultList.length} results");
    _resultList.forEach((service) {
      print("Service: ${service.name}, Category: ${service.category}, Discount: ${service.discount}, Rating: ${service.averageReview}, Price: ${service.price}");
    });
  }

  Future<void> getClientData() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final userDoc = await FirebaseFirestore.instance
          .collection("User")
          .doc(userId)
          .get();

      if (!userDoc.exists) throw Exception('User document not found');

      final userCarDetails = List<String>.from(
          userDoc.data()?['User_carDetails'] ?? []);
      final userCarModels = userCarDetails
          .map((detail) => detail.split(';')[0])
          .toList();

      final querySnapshot = await FirebaseFirestore.instance
          .collection("Service")
          .where('carmodel', arrayContainsAny: userCarModels)
          .get();

      services = querySnapshot.docs.map((doc) {
        final data = doc.data();
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
      }).toList();

      topServices = services.where((service) => 
        topServiceIds.contains(service.id)
      ).toList();

      setState(() {
        _resultList = List.from(services);
      });
    } catch (e) {
      print('Error fetching client data: $e');
    }
  }

  void _onSearchChange() {
    setState(() {
      _isSearching = _searchController.text.isNotEmpty;
    });
    searchResultList();
  }

  void searchResultList() {
    String query = _searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      setState(() {
        _resultList = services.where((service) {
          return service.name.toLowerCase().contains(query);
        }).toList();
      });
    } else {
      setState(() {
        _resultList = services;
      });
    }
  }

  Future<void> saveSearchHistory(String searchTerm) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (!searchHistory.contains(searchTerm)) {
        searchHistory.add(searchTerm);
        await prefs.setStringList('searchHistory', searchHistory);
        setState(() {});
      }
    } catch (e) {
      print('Error saving search history: $e');
    }
  }

  void removeSearchItem(int index) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      searchHistory.removeAt(index);
      await prefs.setStringList('searchHistory', searchHistory);
      setState(() {});
    } catch (e) {
      print('Error removing search item: $e');
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChange);
    _searchController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (_searchController.text.isNotEmpty) {
            _searchController.clear();
            setState(() {
              _isSearching = false;
            });
            return false; // Prevent pop
          }
          return true; // Allow pop
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Custombackbutton(),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              hintText: 'Search services & Packages',
                              hintStyle: AppTextStyle.mediumRaleway12,
                              prefixIcon:
                                  Icon(Icons.search, color: Colors.grey),
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Color(0xffF5F5F5),
                              contentPadding: EdgeInsets.all(10),
                            ),
                            onSubmitted: (text) {
                              if (text.isNotEmpty) {
                                saveSearchHistory(
                                    text); // Save the search history when Enter is pressed
                                searchResultList();
                              }
                            },
                            onChanged: (text) {
                              searchResultList(); // Perform search dynamically as the user types
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    if (!_isSearching) ...[
                      searchHistory.isNotEmpty
                          ? Text('Your search history',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  fontFamily: 'Poppins'))
                          : SizedBox.shrink(),
                      searchHistory.isNotEmpty
                          ? SizedBox(height: 10)
                          : SizedBox.shrink(),
                      searchHistory.isNotEmpty
                          ? SizedBox(
                              height: 40,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: searchHistory.length,
                                itemBuilder: (context, index) {
                                  final reversedHistory =
                                      searchHistory.reversed.toList();
                                  return GestureDetector(
                                    onTap: () {
                                      _searchController.text =
                                          reversedHistory[index];
                                      searchResultList();
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: Color(0xffEEEEEE),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Center(
                                          child: Text(
                                            reversedHistory[index],
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Color(0xff04565A),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : SizedBox.shrink(),
                      SizedBox(height: 20),
                      Text('Popular Services',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              fontFamily: 'Poppins')),
                      SizedBox(height: 20),
                      toprecommendedservices(),
                      Text('Top Categories',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              fontFamily: 'Poppins')),
                      SizedBox(height: 10),
                      SizedBox(
                        height: 100, // Adjust height if needed
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: topCategories.length,
                          itemBuilder: (context, index) {
                            var category = topCategories[index];
                            return Container(
                                margin: EdgeInsets.only(right: 12),
                                child: ServicesType(
                                  text: category,
                                  imagePath: categoryImageMap[category] ??
                                      'assets/icon.png',
                                  borderSides: [
                                    BorderSideEnum.bottom,
                                    BorderSideEnum.right,
                                    BorderSideEnum.top,
                                    BorderSideEnum.left
                                  ],
                                  onTap: () {
                                    navigateToServicePage(category);
                                  },
                                ));
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      Text('Top Services',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              fontFamily: 'Poppins')),
                      SizedBox(height: 10),
                      // Display topServices only (filtered by topServiceIds)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: topServices.length,
                        itemBuilder: (context, index) {
                          var service = topServices[index];
                          return InkWell(
                            onTap: () {
                              Get.toNamed(AppRoutes.SERVICE_DETAIL,
                                  arguments: service);
                            },
                            splashColor: Colors.grey.withOpacity(0.3),
                            child: Container(
                              height: 90,
                              width: double.infinity,
                              margin: EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: ExtendedImage.network(
                                      service.image,
                                      fit: BoxFit.cover,
                                      cache: true,
                                      height: 80,
                                      width: 80,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      '${service.name} in ${service.category}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                    if (_isSearching) ...[
                      _resultList.isEmpty
                          ? Center(
                              child: Text(
                                  "No services match your requirements :("))
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: _resultList.length,
                              itemBuilder: (context, index) {
                                var service = _resultList[index];
                                return InkWell(
                                  onTap: () {
                                    Get.toNamed(AppRoutes.SERVICE_DETAIL,
                                        arguments: service);
                                  },
                                  splashColor: Colors.grey.withOpacity(0.3),
                                  child: Container(
                                    height: 90,
                                    width: double.infinity,
                                    margin: EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: ExtendedImage.network(
                                            service.image,
                                            fit: BoxFit.cover,
                                            cache: true,
                                            height: 80,
                                            width: 80,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            '${service.name} in ${service.category}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ]
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void navigateToServicePage(String service) {
    Get.toNamed(AppRoutes.SERVICE, arguments: service);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}
