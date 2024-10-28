import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../routes/app_routes.dart'; // Import GetX for reactive state management

class CarController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String userId = FirebaseAuth.instance.currentUser!.uid;
  var userCurrentCarId = ''.obs;

  final Map<String, String> carTypeToIdMap = {
    "Compact SUV": "WAW1MUSfq8nCJezAVWcc",
    "Hatchback": "IJZ4mxfAXlB50gJNfyrH",
    "SUV": "4S7tCwBsyNYSwf7Vb0sC",
    "Sedan": "rfAqSBOOUZLSaKotebLX",
  };

  var collectionNames = <String>[].obs;

  Future<void> addCar({
    required String fuelType,
    required String registrationNumber,
    DateTime? registrationYear, // Optional
    DateTime? pucExpiration, // Optional
    DateTime? insuranceExpiration,
    required String transmission,
    required String carType,
    required String carModel,
  }) async {
    try {
      String carTypeId = carTypeToIdMap[carType]!;

      Map<String, dynamic> carData = {
        'fuel_type': fuelType,
        'registration_number': registrationNumber,
        'insurance_expiration': insuranceExpiration,
        'transmission': transmission,
      };

      if (registrationYear != null) {
        carData['registration_year'] = registrationYear;
      }

      if (pucExpiration != null) {
        carData['puc_expiration'] = pucExpiration;
      }

      DocumentReference docRef = await _firestore
          .collection('car')
          .doc('PeVE6MdvLwzcePpmZfp0')
          .collection(carType)
          .doc(carTypeId)
          .collection(carModel)
          .add(carData);

      DocumentSnapshot userDoc =
          await _firestore.collection('User').doc(userId).get();

      List<dynamic> currentCarDetails = userDoc.get('User_carDetails') ?? [];

      String newCarDetail = "$carType;$carModel;${docRef.id}";

      currentCarDetails.add(newCarDetail);

      print(currentCarDetails);

      await _firestore.collection('User').doc(userId).update({
        'User_carDetails': currentCarDetails,
      });

      print("Car added successfully.");

      Get.toNamed(AppRoutes.BOTTOMNAV, arguments: {
        'tracking_button': false,
      });
    } catch (e) {
      print("Error adding car: $e");
    }
  }

  Future<void> deleteCar({
    required String carId,
    required String carType,
    required String carModel,
  }) async {
    try {
      String carTypeId = carTypeToIdMap[carType]!;

      await _firestore
          .collection('car')
          .doc('PeVE6MdvLwzcePpmZfp0')
          .collection(carType)
          .doc(carTypeId)
          .collection(carModel)
          .doc(carId)
          .delete();

      DocumentSnapshot userDoc =
          await _firestore.collection('User').doc(userId).get();

      List<dynamic> currentCarDetails = userDoc.get('User_carDetails') ?? [];

      String carDetailToRemove = "$carType;$carModel;$carId";
      currentCarDetails.remove(carDetailToRemove);

      await _firestore.collection('User').doc(userId).update({
        'User_carDetails': currentCarDetails,
        if (userCurrentCarId.value == carId) 'User_currentCar': 0,
      });

      print("Car deleted successfully.");

     
    } catch (e) {
      print("Error deleting car: $e");
      throw e;
    }
  }

  Future<List<Map<String, dynamic>>> fetchUserCarDetails() async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('User').doc(userId).get();
      List<dynamic> userCarDetails = userDoc.get('User_carDetails') ?? [];

      List<Map<String, dynamic>> carDetailsList = [];

      for (String carDetail in userCarDetails) {
        var details = carDetail.split(';');
        String carType = details[0];
        String carModel = details[1];
        String carId = details[2];

        DocumentSnapshot carDoc = await _firestore
            .collection('car')
            .doc('PeVE6MdvLwzcePpmZfp0')
            .collection(carType)
            .doc(carTypeToIdMap[carType])
            .collection(carModel)
            .doc(carId)
            .get();

        if (carDoc.exists) {
          var carData = carDoc.data() as Map<String, dynamic>;
          carData['car_type'] = carType;
          carData['car_model'] = carModel;
          carDetailsList.add(carData);
        }
      }
      print('controller ka maal: ${carDetailsList}');

      return carDetailsList;
    } catch (e) {
      print("Error fetching car details: $e");
      return [];
    }
  }

  Future<void> updateCar({
    required String carId,
    required String fuelType,
    required String registrationNumber,
    DateTime? registrationYear,
    DateTime? pucExpiration,
    DateTime? insuranceExpiration,
    required String transmission,
    required String carType,
    required String carModel,
  }) async {
    try {
      String carTypeId = carTypeToIdMap[carType]!;
      log(carId);
      Map<String, dynamic> carData = {
        'fuel_type': fuelType,
        'registration_number': registrationNumber,
        'insurance_expiration': insuranceExpiration,
        'transmission': transmission,
      };

      if (registrationYear != null) {
        carData['registration_year'] = registrationYear;
      }

      if (pucExpiration != null) {
        carData['puc_expiration'] = pucExpiration;
      }
      log(userCurrentCarId.value);
      await _firestore
          .collection('car')
          .doc('PeVE6MdvLwzcePpmZfp0')
          .collection(carType)
          .doc(carTypeId)
          .collection(carModel)
          .doc(carId)
          .update(carData);

      print("Car updated successfully.");

      Get.toNamed(AppRoutes.BOTTOMNAV, arguments: {
        'tracking_button': false,
      });
    } catch (e) {
      print("Error updating car: $e");
    }
  }

  final Map<String, List<String>> subCollectionNamesMap = {
    "Hatchback": [
      "1-series",
      "3-Door hatch",
      "5-Door hatch",
      "500",
      "A1",
      "Alto 800",
      "Alto K10",
      "Altroz",
      "B-class",
      "Baleno",
      "Beat",
      "C3",
      "Celerio",
      "Comet",
      "Eon",
      "Etios Liva",
      "Fabia",
      "Figo",
      "Glanza",
      "Golf GTI",
      "Grand I10 Nios",
      "I10",
      "I20",
      "Jazz",
      "Kuv 100",
      "Kwid",
      "Lancer Evolution",
      "Micra",
      "Panda",
      "Polo",
      "Punto",
      "S-Presso",
      "Santro",
      "Spark",
      "Swift",
      "Tiago",
      "Verito Vibe",
      "Wagon R",
    ],
    "Compact SUV": [
      "500x",
      "Astor",
      "Brezza",
      "C40",
      "C5 Aircross",
      "Compass",
      "Countryman",
      "DBX",
      "Discovery Sport",
      "EcoSport",
      "Ev6",
      "Evoque",
      "Exter",
      "Freelander",
      "Fronx",
      "GLA",
      "GLC",
      "Grand Vitara",
      "Hyryder",
      "Ignis",
      "Jimny",
      "Karoq",
      "Kiger",
      "Kushaq",
      "Magnite",
      "Nexon",
      "Outlander",
      "Punch",
      "Q2",
      "Q3",
      "Q4",
      "Renegade",
      "Seltos",
      "Sonet",
      "T-cross",
      "T-roc",
      "Taigun",
      "Taisor",
      "Thar",
      "Trax",
      "Urban Cruiser",
      "Velar",
      "Venue",
      "WR-V",
      "X1",
      "X2",
      "X3",
      "XC40",
      "XC60",
      "Xuv 300",
      "Xuv 400",
      "Zs EV"
    ],
    "SUV": [
      "500L",
      "Alcazar",
      "Aria",
      "Bolero",
      "Bolero Neo",
      "CR-V",
      "Captiva",
      "Carens",
      "Creta",
      "D-Max V-Cross",
      "Defender",
      "Discovery 4",
      "Duster",
      "E-Pace",
      "EQB",
      "Endeavour",
      "Ertiga",
      "F-Pace",
      "Fortuner",
      "Freemount",
      "G-Class",
      "GLB",
      "GLK",
      "GLS",
      "Gloster",
      "Grand Cherokee",
      "Gurkha",
      "HR-V",
      "Harrier",
      "Hector",
      "Hexa",
      "Hilux",
      "I-Pace",
      "IX",
      "IX1",
      "Innova",
      "Innova Crysta",
      "Innova Hycross",
      "Invicto",
      "Kicks",
      "Kodiaq",
      "Kona",
      "Land Cruiser",
      "MUX",
      "Marazzo",
      "Outlander",
      "Pajero",
      "Prado",
      "Q5",
      "Q6",
      "Q7",
      "Q8",
      "Range Rover",
      "Range Rover Sport",
      "Rubicon",
      "Safari",
      "Safari Storme",
      "Scorpio",
      "Scorpio N",
      "Sumo",
      "Thar Roxx",
      "Tiguan",
      "Touareg",
      "Trailblazer",
      "Traveller",
      "Trax",
      "Trooper",
      "Tucson",
      "Vellfire",
      "Vogue",
      "Wagoneer",
      "Wrangler",
      "X-Trail",
      "X4",
      "X5",
      "X6",
      "X7",
      "XC90",
      "XL6",
      "XM",
      "Xuv 500",
      "Xuv 700"
    ],
    "Sedan": [
      "124 Sedan",
      "2-series",
      "3-series",
      "5-series",
      "6-series",
      "7-series",
      "8-series",
      "A-class",
      "A3",
      "A4",
      "A5",
      "A6",
      "A7",
      "A8",
      "Accent",
      "Amaze",
      "Ameo",
      "Aspire",
      "Aura",
      "Aveo",
      "C-class",
      "C4",
      "Camry",
      "Ciaz",
      "City",
      "Clubman",
      "Corolla Altis",
      "E-class",
      "Elantra",
      "Etios",
      "F-type",
      "Fiesta",
      "I4",
      "I5",
      "I7",
      "Ikon",
      "Jetta",
      "Lagonda",
      "Lancer",
      "Linea",
      "M3",
      "M4 comp",
      "M5",
      "M8 comp",
      "Mondeo",
      "Mustang",
      "Octavia",
      "Passat",
      "Phaeton",
      "Rapid",
      "S-class",
      "S60",
      "S8",
      "S90",
      "Sail",
      "Slavia",
      "Sunny",
      "Superb",
      "Swift Dzire",
      "Tigor",
      "Tipo",
      "Vento",
      "Verito",
      "Verna",
      "XE",
      "XF",
      "XJ",
      "Xcent",
      "Yaris",
      "Z4"
    ],
  };

  List<String> getCarModels(String carType) {
    return subCollectionNamesMap[carType] ?? [];
  }
}
