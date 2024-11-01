import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:wrenchmate_user_app/app/data/models/car_detail_model.dart';
import 'package:wrenchmate_user_app/app/modules/car/widget/imagePopup.dart';
import 'package:wrenchmate_user_app/app/modules/home/widgits/toprecommendedservices.dart';
import 'package:wrenchmate_user_app/globalVariables.dart';
import '../../routes/app_routes.dart';
import '../../controllers/car_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Add this import

class CarPage extends StatefulWidget {
  @override
  _CarPageState createState() => _CarPageState();
}

class _CarPageState extends State<CarPage> {
  int userCurrentCarIndex = 0;
  String userCurrentCarId = '';
  List<Map<String, dynamic>> userCars = [];
  String carModel = '';
  String petrolOrDiesel = '';
  String carType = '';

  late TextEditingController regYearController;
  late TextEditingController regNoController;
  late TextEditingController insuranceExpController;
  late TextEditingController pucExpController;

  String? _regCardImageUrl;
  String? _drivingLicImageUrl;

  final CarController carController = Get.put(CarController());

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    regYearController = TextEditingController();
    regNoController = TextEditingController();
    insuranceExpController = TextEditingController();
    pucExpController = TextEditingController();
    _pageController = PageController(initialPage: userCurrentCarIndex);
    fetchUserCurrentCarIndex();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void fetchUserCurrentCarIndex() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('User').doc(userId).get();
    if (userDoc.exists) {
      setState(() {
        userCurrentCarIndex = userDoc['User_currentCar'] ?? 0;
        String carDetails = userDoc['User_carDetails'][userCurrentCarIndex];
        List<String> carDetailsParts = carDetails.split(';');
        userCurrentCarId = carDetailsParts.last;
        log('user curr car index is: ${userCurrentCarIndex.toString()}');
      });
      fetchCarDetails();
    }
  }

  void fetchCarDetails() async {
    userCars = await carController.fetchUserCarDetails();
    print("Car details in CarPage: $userCars");
    if (userCars.isNotEmpty) {
      setState(() {
        updateCarDetails(userCurrentCarIndex);
        _pageController.jumpToPage(userCurrentCarIndex);
      });
    }
    log('car is: ${userCars}');
  }

  void updateCarDetails(int index) {
    if (index >= 0 && index < userCars.length) {
      var car = userCars[index];
      carModel = car['car_model'] ?? '--';
      petrolOrDiesel = car['fuel_type'] ?? '--';
      carType = car['car_type'] ?? '--';
      regYearController.text = car['registration_year'] != null
          ? _formatDateTimeRegi((car['registration_year']).toDate())
          : '--';
      regNoController.text = car['registration_number'] ?? '--';
      insuranceExpController.text = car['insurance_expiration'] != null
          ? _formatDateTime((car['insurance_expiration']).toDate())
          : '--';
      pucExpController.text = car['puc_expiration'] != null
          ? _formatDateTime((car['puc_expiration']).toDate())
          : '--';
      _regCardImageUrl = car['regCard'];
      _drivingLicImageUrl = car['drivLic'];
      print("Displaying car at index $index: $car");
    }
  }

  File? _regCardImage;
  File? _drivingLicImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickAndUploadImage(String type) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    File file = File(image.path);
    setState(() {
      if (type == 'regCard') {
        _regCardImage = file;
      } else {
        _drivingLicImage = file;
      }
    });
    String? regCardImagePath;
    String? drivLicImagePath;

    if (type == 'drivingLic') {
      drivLicImagePath =
          await uploadImageToStorage(_drivingLicImage!, 'drivingLic');
    } else {
      regCardImagePath = await uploadImageToStorage(_regCardImage!, 'regCard');
    }

    carController.addImageUrlsToCar(
        carId: userCurrentCarId,
        carType: carType,
        carModel: carModel,
        drivLicUrl: drivLicImagePath,
        regCardUrl: regCardImagePath);

    log(regCardImagePath ?? '');
    log(drivLicImagePath ?? '');
  }

  Future<String?> uploadImageToStorage(File image, String type) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User not logged in');
      }
      String userId = currentUser.uid;
      final storageReference = FirebaseStorage.instance.ref('/Users');
      final fileName = image.path.split('/').last;
      final dateStamp = DateTime.now().microsecondsSinceEpoch;
      final uploadReference = type == 'drivingLic'
          ? storageReference
              .child('$userId/drivingLicence/$dateStamp-$fileName')
          : storageReference
              .child('$userId/registrationCard/$dateStamp-$fileName');
      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
      );
      TaskSnapshot taskSnapshot =
          await uploadReference.putFile(image, metadata);
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      print("Failed to upload image: $e");
      return null;
    }
  }

  /*
  Sedan
  Hatchback
  Compact SUV
  SUV
   */

  void navigateCarDetails(int direction) {
    int newIndex = userCurrentCarIndex + direction;
    if (newIndex >= 0 && newIndex < userCars.length) {
      _pageController.animateToPage(
        newIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        userCurrentCarIndex = newIndex;
        updateCarDetails(newIndex);
        updateUserCurrentCarIndexInFirebase(newIndex);
      });
    }
  }

  void updateUserCurrentCarIndexInFirebase(int index) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('User')
        .doc(userId)
        .update({'User_currentCar': index});
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(dateTime);
  }

  String _formatDateTimeRegi(DateTime? dateTime) {
    if (dateTime == null) return '';
    final DateFormat formatter = DateFormat('yyyy');
    return formatter.format(dateTime);
  }

  Future<void> _loadImage() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        carModel,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        petrolOrDiesel,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.chevron_left,
                            color: userCurrentCarIndex == 0
                                ? Colors.grey
                                : Colors.black),
                        onPressed: userCurrentCarIndex == 0
                            ? null
                            : () => navigateCarDetails(-1),
                      ),
                      IconButton(
                        icon: Icon(Icons.chevron_right,
                            color: userCurrentCarIndex == userCars.length - 1
                                ? Colors.grey
                                : Colors.black),
                        onPressed: userCurrentCarIndex == userCars.length - 1
                            ? null
                            : () => navigateCarDetails(1),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: SizedBox(
                  height: 150,
                  child: PageView.builder(
                    itemCount: userCars.length,
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        userCurrentCarIndex = index;
                        updateCarDetails(index);
                        updateUserCurrentCarIndexInFirebase(index);
                      });
                    },
                    itemBuilder: (context, index) {
                      var car = userCars[index];
                      return Image.asset(
                        car['car_type'] == 'Sedan'
                            ? 'assets/car/sedan.png'
                            : car['car_type'] == 'SUV'
                                ? 'assets/car/suv.png'
                                : car['car_type'] == 'Compact SUV'
                                    ? 'assets/car/compact_suv.png'
                                    : car['car_type'] == 'Hatchback'
                                        ? 'assets/car/hatchback.png'
                                        : "",
                        height: 150,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return CircularProgressIndicator();
                        },
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Car Detail',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(
                              AppRoutes.CAR_EDIT,
                              arguments: {
                                'carDetails': userCars[userCurrentCarIndex],
                                'carId':
                                    userCurrentCarId, // The ID we extracted earlier
                              },
                            );
                          },
                          child: SvgPicture.asset('assets/icons/edit_icon.svg'),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            carController.deleteCar(
                                carId: userCurrentCarId,
                                carType: carType,
                                carModel: carModel);
                            setState(() {
                              userCars.removeAt(userCurrentCarIndex);

                              if (userCurrentCarIndex >= userCars.length) {
                                userCurrentCarIndex =
                                    userCars.isEmpty ? 0 : userCars.length - 1;
                              }

                              if (userCars.isNotEmpty) {
                                updateCarDetails(userCurrentCarIndex);
                              } else {
                                carModel = '';
                                petrolOrDiesel = '';
                                carType = '';
                                regYearController.clear();
                                regNoController.clear();
                                insuranceExpController.clear();
                                pucExpController.clear();
                              }
                            });
                            Get.toNamed('/bottomnav');
                          },
                          child:
                              SvgPicture.asset('assets/icons/delete_icon.svg'),
                        ),
                      ],
                    ),
                    Divider(),
                    SizedBox(height: 10),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //regi year and insurance
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //reg year
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Reg Year :',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(regYearController.text),
                              ],
                            ),
                            SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Insurance Exp. :',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(insuranceExpController.text),
                              ],
                            ),
                          ],
                        ),
                        //reg and puc
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //reg
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Reg No:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(regNoController.text),
                              ],
                            ),
                            SizedBox(height: 10),
                            //puc
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'PUC Exp Date :',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(pucExpController.text),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Reg Card :',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    GestureDetector(
                      onTap: () => _pickAndUploadImage('regCard'),
                      child: Container(
                        height: 40,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                          // image: _regCardImage != null
                          //     ? DecorationImage(
                          //         image: FileImage(_regCardImage!),
                          //         fit: BoxFit.cover,
                          //       )
                          //     : null,
                        ),
                        child: (_regCardImage == null &&
                                _regCardImageUrl == null)
                            ? Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20),
                                        child: Text(
                                          'Upload',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Icon(Icons.add_a_photo,
                                          color: Colors.grey[700]),
                                    ],
                                  ),
                                ))
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _regCardImageUrl != null
                                            ? carController.getFileNameFromUrl(
                                                _regCardImageUrl!)
                                            : _regCardImage?.path
                                                    .split('/')
                                                    .last ??
                                                '',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if (_regCardImageUrl != null) {
                                            // Show image from Firebase URL
                                            showImagePopup(
                                                _regCardImageUrl!, context);
                                          } else if (_regCardImage != null) {
                                            // Show local image
                                            showImagePopup(
                                                _regCardImage!, context);
                                          }
                                        },
                                        child: Text(
                                          'View',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'Driving Licen. :',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () => _pickAndUploadImage('drivingLic'),
                      child: Container(
                        height: 40,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                          // image: _drivingLicImage != null
                          //     ? DecorationImage(
                          //         image: FileImage(_drivingLicImage!),
                          //         fit: BoxFit.cover,
                          //       )
                          //     : null,
                        ),
                        child: (_drivingLicImage == null &&
                                _drivingLicImageUrl == null)
                            ? Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20),
                                        child: Text(
                                          'Upload',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Icon(Icons.add_a_photo,
                                          color: Colors.grey[700]),
                                    ],
                                  ),
                                ))
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _drivingLicImageUrl != null
                                            ? carController.getFileNameFromUrl(
                                                _drivingLicImageUrl!)
                                            : _drivingLicImage?.path
                                                    .split('/')
                                                    .last ??
                                                '',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if (_drivingLicImageUrl != null) {
                                            showImagePopup(
                                                _drivingLicImageUrl!, context);
                                          } else if (_drivingLicImage != null) {
                                            showImagePopup(
                                                _drivingLicImage!, context);
                                          }
                                        },
                                        child: const Text(
                                          'View',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              // Spacer(),
              //add new car service history
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.CAR_REGISTER);
                      },
                      child: GradientContainer(
                        height: 120,
                        colors: [Color(0xff9DB3E5), Color(0xff3E31BF)],
                        width: MediaQuery.of(context).size.width / 2 - 36,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18.0, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/car/sedan.png',
                                width: 100,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Add New Car',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.BOOKING);
                      },
                      child: GradientContainer(
                        height: 120,
                        colors: [Color(0xffFEA563), Color(0xffFF5F81)],
                        width: MediaQuery.of(context).size.width / 2 - 36,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18.0, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/images/servicehistory.png',
                                height: 70,
                              ),
                              Text(
                                'Service History',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
