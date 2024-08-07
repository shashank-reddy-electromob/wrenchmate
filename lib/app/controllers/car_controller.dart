import 'package:cloud_firestore/cloud_firestore.dart';

class CarController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addCarTo500x({
    required String fuelType,
    required String registrationNumber,
    required int registrationYear,
    required DateTime pucExpiration,
    required DateTime insuranceExpiration,
    required String transmission,
  }) async {
    try {
      print("in controller");
      CollectionReference cars500x = _firestore
          .collection('car')
          .doc('PeVE6MdvLwzcePpmZfp0')
          .collection('Compact SUV')
          .doc('WAW1MUSfq8nCJezAVWcc')
          .collection('500x');

      await cars500x.doc().set({
        'fuel_type': fuelType,
        'registration_number': registrationNumber,
        'registration_year': registrationYear,
        'puc_expiration': pucExpiration,
        'insurance_expiration': insuranceExpiration,
        'transmission': transmission,
      });

      print("Car added to 500x collection successfully.");
    } catch (e) {
      print("Error adding car to 500x collection: $e");
    }
  }
}
