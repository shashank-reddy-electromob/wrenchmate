import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wrenchmate_user_app/app/controllers/cart_controller.dart';
import 'package:wrenchmate_user_app/app/modules/auth/widgets/CustomErrorFields.dart';
import 'package:wrenchmate_user_app/app/modules/cart/bookslotpage.dart';
import '../../controllers/auth_controller.dart';
import '../../routes/app_routes.dart';
import '../../widgets/blueButton.dart';
import '../../widgets/custombackbutton.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  loc.LocationData? currentLocation;
  LatLng? initialCameraPosition;
  String? address;
  bool? isExist = false;
  bool? isnew = false;
  Placemark? place;

  TextEditingController flatnubercontroller = TextEditingController();
  TextEditingController localitycontroller = TextEditingController();
  TextEditingController landmarkcontroller = TextEditingController();

  late final AuthController controller;
  late final CartController cartController=Get.find();

  bool isFlatNumberEmpty = false;
  bool isLocalityEmpty = false;
  bool isLandmarkEmpty = false;

  @override
  void initState() {
    super.initState();
    controller = Get.find();
    _fetchCurrentLocation();
    _loadAddressFromArguments();
    _loadIsNewFromArguments();
  }

  void _loadAddressFromArguments() {
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args.containsKey('address')) {
      final address = args['address'] as String?;
      if (address != null) {
        List<String> addressParts = address.split(',');
        addressParts = addressParts.map((part) => part.trim()).toList();
        setState(() {
          isExist = true;
          flatnubercontroller.text = addressParts[0];
          localitycontroller.text = addressParts[3];
          landmarkcontroller.text = addressParts[2];
        });
      }
    }
  }

  void _loadIsNewFromArguments() {
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args.containsKey('isnew')) {
      setState(() {
        isnew = args['isnew'];
      });
    }
  }

  void _fetchCurrentLocation() async {
    var location = loc.Location();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      double? savedLatitude = prefs.getDouble('latitude');
      double? savedLongitude = prefs.getDouble('longitude');
      log('longitude is : ${savedLongitude.toString()}');
      if (savedLatitude != null && savedLongitude != null) {
        final LatLng savedPosition = LatLng(savedLatitude, savedLongitude);
        log('saved position is: ${savedPosition.toString()}');
        setState(() {
          log('in setstate');
          initialCameraPosition = savedPosition;
        });
        print(
            "Using saved location from SharedPreferences: $savedLatitude, $savedLongitude");
        await _getAddressFromLatLng(savedPosition);
        showBottomDrawer(context);
      } else {
        currentLocation = await location.getLocation();
        if (currentLocation != null) {
          final LatLng newPosition = LatLng(
            currentLocation!.latitude!,
            currentLocation!.longitude!,
          );
          setState(() {
            initialCameraPosition = newPosition;
          });
          await _getAddressFromLatLng(initialCameraPosition!);
          showBottomDrawer(context);
        }
      }
    } catch (e) {
      print('Could not get the location: $e');
      currentLocation = null;
    }
  }

  // void _fetchCurrentLocation() async {
  //   var location = loc.Location();
  //   try {
  //     currentLocation = await location.getLocation();
  //   } catch (e) {
  //     print('Could not get the location: $e');
  //     currentLocation = null;
  //   }

  //   if (currentLocation != null) {
  //     final LatLng newPosition = LatLng(
  //       currentLocation!.latitude!,
  //       currentLocation!.longitude!,
  //     );
  //     // Update the camera positio
  //     mapController.animateCamera(CameraUpdate.newLatLng(newPosition));

  //     setState(() {
  //       initialCameraPosition = newPosition;
  //     });
  //     await _getAddressFromLatLng(initialCameraPosition!);
  //     showBottomDrawer(context);
  //   }
  // }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      place = placemarks[0];
      setState(() {
        address =
            "${place?.street}, ${place?.locality}, ${place?.postalCode}, ${place?.country}";
        flatnubercontroller.text = place?.name ?? '';
        localitycontroller.text = place?.locality ?? '';
        landmarkcontroller.text = place?.subLocality ?? '';
      });
    } catch (e) {
      print('Error getting address: $e');
      setState(() {
        address = "Error fetching address";
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _saveAddress() async {
    if (isnew == false) {
      controller.updateUserAddress(address!).then((success) {
        if (success && isExist == true) {
          Get.toNamed(AppRoutes.BOTTOMNAV);
        } else if (success && isExist == false) {
          Get.toNamed(AppRoutes.CAR_REGISTER);
        } else {
          print('Failed to update address');
        }
      });
    } else {
      controller.addAddressToList(address!).then((success) {
        if (success && isExist == true) {
          // Get.toNamed(AppRoutes.BOOK_SLOT);
          Navigator.of(context)
            ..pop()
            ..pop()
            ..pushReplacement(
                MaterialPageRoute(builder: (context) => BookSlot()));
        } else {
          print('Failed to add address');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Custombackbutton(),
        title: Text("Add Address",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins')),
      ),
      body: initialCameraPosition == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                GestureDetector(
                  onTap: () {
                    showBottomDrawer(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Color(0xffF7F7F7)),
                      child: AbsorbPointer(
                        absorbing: true,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'No address selected',
                            hintStyle: TextStyle(
                                color: Color(0xff858585),
                                fontSize: 24,
                                fontFamily: 'Poppins'),
                            prefixIcon:
                                Icon(Icons.search, color: Color(0xff838383)),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          controller:
                              TextEditingController(text: "Search Location"),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: initialCameraPosition!,
                      zoom: 16.0,
                    ),
                    onTap: (LatLng latLng) {
                      setState(() {
                        initialCameraPosition = latLng;
                      });
                      _getAddressFromLatLng(latLng);
                    },
                    markers: {
                      Marker(
                        markerId: MarkerId('selected-location'),
                        position: initialCameraPosition!,
                        draggable: true,
                        onDragEnd: (LatLng newPosition) {
                          setState(() {
                            initialCameraPosition = newPosition;
                          });
                          _getAddressFromLatLng(newPosition);
                        },
                      ),
                    },
                  ),
                ),
              ],
            ),
    );
  }

  void showBottomDrawer(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 16),
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Custombackbutton(),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            "Add Address",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 48),
                    ],
                  ),
                  ClipOval(
                    child: Container(
                      height: 100,
                      width: 100,
                      child: GoogleMap(
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: CameraPosition(
                          target: initialCameraPosition!,
                          zoom: 16.0,
                        ),
                        onTap: (LatLng latLng) {
                          setState(() {
                            initialCameraPosition = latLng;
                          });
                          _getAddressFromLatLng(latLng);
                        },
                        zoomControlsEnabled: false,
                        markers: {
                          Marker(
                            markerId: MarkerId('selected-location'),
                            position: initialCameraPosition!,
                            draggable: false,
                            onDragEnd: (LatLng newPosition) {
                              setState(() {
                                initialCameraPosition = newPosition;
                              });
                              _getAddressFromLatLng(newPosition);
                            },
                          ),
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.black,
                        size: 16,
                      ),
                      Text(
                        place?.locality ?? "",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  CustomErrorField(
                    controller: flatnubercontroller,
                    hintText: "Flat Number",
                    errorText:
                        isFlatNumberEmpty ? "Flat Number is required" : null,
                  ),
                  CustomErrorField(
                    controller: localitycontroller,
                    hintText: "Locality",
                    errorText: isLocalityEmpty ? "Locality is required" : null,
                  ),
                  CustomErrorField(
                    controller: landmarkcontroller,
                    hintText: "Landmark",
                    errorText: isLandmarkEmpty ? "Landmark is required" : null,
                  ),

                  Spacer(), // This pushes the button to the bottom
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: BlueButton(
                      text: "SAVE",
                      onTap: () {
                        setState(() {
                          isFlatNumberEmpty = flatnubercontroller.text.isEmpty;
                          isLocalityEmpty = localitycontroller.text.isEmpty;
                          isLandmarkEmpty = landmarkcontroller.text.isEmpty;
                        });

                        if (!isFlatNumberEmpty &&
                            !isLocalityEmpty &&
                            !isLandmarkEmpty) {
                          address = "${flatnubercontroller.text}, "
                              "${place?.name}, "
                              "${landmarkcontroller.text}, "
                              "${localitycontroller.text}, "
                              "${place?.subLocality}, "
                              "${place?.locality}, "
                              "${place?.administrativeArea}, "
                              "${place?.postalCode}, "
                              "${place?.country}";
                          _saveAddress();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
