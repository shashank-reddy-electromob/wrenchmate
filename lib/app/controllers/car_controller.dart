import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CarController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String userId = FirebaseAuth.instance.currentUser!.uid;

  final Map<String, String> carTypeToIdMap = {
    "Compact SUV": "WAW1MUSfq8nCJezAVWcc",
    "Hatchback": "IJZ4mxfAXlB50gJNfyrH",
    "SUV": "4S7tCwBsyNYSwf7Vb0sC",
    "Sedan": "rfAqSBOOUZLSaKotebLX",
  };

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

    DocumentSnapshot userDoc = await _firestore.collection('User').doc(userId).get();
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
}
