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
  List<Servicefirebase> topServices =
      [];
  List<String> topServiceIds =
      [];
  List<Servicefirebase> services = <Servicefirebase>[];
  List<Servicefirebase> _resultList = [];
  List<String> topCategories = [];
  List<String> searchHistory = [];
  bool _isSearching = false;

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

  Future<void> getTopCategories() async {
    var data = await FirebaseFirestore.instance.collection("topCategory").get();
    topCategories = data.docs.map((doc) => doc['category'] as String).toList();
    setState(() {});
  }

  Future<void> getTopServiceIds() async {
    var data = await FirebaseFirestore.instance.collection("topServices").get();
    topServiceIds = data.docs.map((doc) => doc['serviceId'] as String).toList();
    setState(() {});
  }

  Future<void> getSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    searchHistory = prefs.getStringList('searchHistory') ?? [];
    setState(() {});
  }


  @override
  void initState() {
    super.initState();

    // Fetch all the services initially
    getClientData().then((_) {
      // Check if there are any filtering arguments
      final filterArgs = Get.arguments;
      if (filterArgs != null) {
        _applyFilters(
          filterArgs['selectedServices'],
          filterArgs['selectedDiscount'],
          filterArgs['selectedRating'],
          filterArgs['minPrice'],
          filterArgs['maxPrice'],
        );
      } else {
        // If no arguments are passed, display all services
        setState(() {
          _resultList = services;
        });
      }
    });

    getTopCategories();
    getSearchHistory();
    getTopServiceIds();
    _searchController.addListener(_onSearchChange);
  }

  void _applyFilters(
      List<String>? selectedServices,
      String? selectedDiscount,
      String? selectedRating,
      double? minPrice,
      double? maxPrice) {

    print("Before filtering:");
    services.forEach((service) {
      print(
          "Service: ${service.name}, Category: ${service.category}, Discount: ${service.discount}, Rating: ${service.averageReview}, Price: ${service.price}");
    });

    _resultList = services.where((service) {
      // Printing each service's attributes before filtering
      print("\nEvaluating Service: ${service.name}");
      print(
          "Category: ${service.category}, Discount: ${service.discount}, Rating: ${service.averageReview}, Price: ${service.price}");

      // Applying filters
      bool matchesCategory = selectedServices == null || selectedServices.isEmpty
          ? true
          : selectedServices.contains(service.category);

      double discountValue = 0;
      if (selectedDiscount != null) {
        // Remove the '%' sign and parse the discount range
        selectedDiscount = selectedDiscount?.replaceAll('%', '');
        List<String>? discountRange = selectedDiscount?.split('-');
        // If the range is defined, take the lower end as the minimum discount
        if (discountRange?.length == 2) {
          discountValue = double.tryParse(discountRange![0]) ?? 0;
        } else {
          discountValue = double.tryParse(selectedDiscount!) ?? 0;
        }
      }

      double ratingValue = 0;
      if (selectedRating != null) {
        // Remove '>' and the emoji from the rating
        selectedRating = selectedRating?.replaceAll('>', '').replaceAll('⭐', '').trim();
        ratingValue = double.tryParse(selectedRating!) ?? 0;
      }

      bool matchesDiscount = selectedDiscount == null || service.discount >= discountValue;
      bool matchesRating = selectedRating == null || service.averageReview > ratingValue;
      bool matchesPriceRange = (minPrice == null || service.price >= minPrice) && (maxPrice == null || service.price <= maxPrice);

      // Printing evaluation result for each condition
      print("Matches Category: $matchesCategory");
      print("Matches Discount: $matchesDiscount");
      print("Matches Rating: $matchesRating");
      print("Matches Price Range: $matchesPriceRange");

      return matchesCategory && matchesDiscount && matchesRating && matchesPriceRange;
    }).toList();

    _isSearching=true;

    print("\nAfter filtering:");
    _resultList.forEach((service) {
      print(
          "Service: ${service.name}, Category: ${service.category}, Discount: ${service.discount}, Rating: ${service.averageReview}, Price: ${service.price}");
    });
  }


  Future<void> saveSearchHistory(String searchTerm) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!searchHistory.contains(searchTerm)) {
      searchHistory.add(searchTerm);
      await prefs.setStringList('searchHistory', searchHistory);
      setState(() {}); // Update the UI to show the new search term
    }
  }

  // Listener for search field changes
  _onSearchChange() {
    setState(() {
      _isSearching = _searchController.text.isNotEmpty;
    });
    searchResultList();
  }
  getClientData() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    var userDoc = await FirebaseFirestore.instance.collection("User").doc(userId).get();

    if (userDoc.exists) {
      List<String> userCarDetails = List<String>.from(userDoc.data()?['User_carDetails'] ?? []);

      List<String> userCarModels = userCarDetails.map((detail) => detail.split(';')[0]).toList();

      var data = await FirebaseFirestore.instance
          .collection("Service")
          .where('carmodel', arrayContainsAny: userCarModels)
          .get();

      services = data.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
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

      topServices = services.where((service) {
              return topServiceIds.contains(service.id);
            }).toList();
            setState(() {
              _resultList = services;
            });
    }

  }

  // Dynamic searching as you type
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

  @override
  void didChangeDependencies() {
    getClientData();
    super.didChangeDependencies();
  }

  // Function to remove a search history item
  void removeSearchItem(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    searchHistory.removeAt(index); // Remove from local list
    await prefs.setStringList(
        'searchHistory', searchHistory); // Update SharedPreferences
    setState(() {}); // Update UI
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
                          ? Center(child: Text("No services match your requirements :("))
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
