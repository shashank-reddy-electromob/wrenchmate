import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart'; // Import GetX for reactive state management

class CarController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String userId = FirebaseAuth.instance.currentUser!.uid;

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
    required int registrationYear,
    required DateTime pucExpiration,
    required DateTime insuranceExpiration,
    required String transmission,
    required String carType,
    required String carModel,
  }) async {
    try {
      print("in controller");
      String carTypeId = carTypeToIdMap[carType]!;

      CollectionReference cars500x = _firestore
          .collection('car')
          .doc('PeVE6MdvLwzcePpmZfp0')
          .collection(carType)
          .doc(carTypeId)
          .collection(carModel);

      await cars500x.doc().set({
        'fuel_type': fuelType,
        'registration_number': registrationNumber,
        'registration_year': registrationYear,
        'puc_expiration': pucExpiration,
        'insurance_expiration': insuranceExpiration,
        'transmission': transmission,
      });

      DocumentSnapshot userDoc =
          await _firestore.collection('User').doc(userId).get();
      List<dynamic> currentCarTypes = userDoc.get('User_carType') ?? [];
      List<dynamic> currentCarModels = userDoc.get('User_carModel') ?? [];

      currentCarTypes.add(carType);
      currentCarModels.add(carModel);

      await _firestore.collection('User').doc(userId).update({
        'User_carType': currentCarTypes,
        'User_carModel': currentCarModels,
      });

      print("Car added successfully.");
    } catch (e) {
      print("Error adding car to 500x collection: $e");
    }
  }

  final Map<String, List<String>> subCollectionNamesMap = {
    "Hatchback": [
      "Select",
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
      "Select",
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
      "X3"
    ],
    "SUV": [
      "Select",
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
      "Prado"
    ],
    "Sedan": [
      "Select",
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
      "Octavia"
    ],
  };
  List<String> getCarModels(String carType) {
    return subCollectionNamesMap[carType] ?? [];
  }
}
