import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart'; // Ensure to import this package

class Car {
  String fuelType;
  String registrationNumber;
  DateTime? insuranceExpiration;
  String transmission;
  String carType;
  String carModel;
  DateTime? registrationYear;
  DateTime? pucExpiration;

  Car({
    required this.fuelType,
    required this.registrationNumber,
    required this.insuranceExpiration,
    required this.transmission,
    required this.carType,
    required this.carModel,
    required this.registrationYear,
    required this.pucExpiration,
  });

  Car copyWith({
    String? fuelType,
    String? registrationNumber,
    DateTime? insuranceExpiration,
    String? transmission,
    String? carType,
    String? carModel,
    DateTime? registrationYear,
    DateTime? pucExpiration,
  }) {
    return Car(
      fuelType: fuelType ?? this.fuelType,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      insuranceExpiration: insuranceExpiration ?? this.insuranceExpiration,
      transmission: transmission ?? this.transmission,
      carType: carType ?? this.carType,
      carModel: carModel ?? this.carModel,
      registrationYear: registrationYear ?? this.registrationYear,
      pucExpiration: pucExpiration ?? this.pucExpiration,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fuelType': fuelType,
      'registrationNumber': registrationNumber,
      'insuranceExpiration': insuranceExpiration?.millisecondsSinceEpoch,
      'transmission': transmission,
      'carType': carType,
      'carModel': carModel,
      'registrationYear': registrationYear?.millisecondsSinceEpoch,
      'pucExpiration': pucExpiration?.millisecondsSinceEpoch,
    };
  }

  factory Car.fromMap(Map<String, dynamic> map) {
    try {
      return Car(
        fuelType: map['fuel_type'] as String, // Adjusted to match your log
        registrationNumber: map['registration_number'] as String, // Adjusted to match your log
        insuranceExpiration: map['insurance_expiration'] is Timestamp
            ? (map['insurance_expiration'] as Timestamp).toDate()
            : null,
        transmission: map['transmission'] as String,
        carType: map['car_type'] as String, // Adjusted to match your log
        carModel: map['car_model'] as String, // Adjusted to match your log
        registrationYear: map['registration_year'] is Timestamp
            ? (map['registration_year'] as Timestamp).toDate()
            : null,
        pucExpiration: map['puc_expiration'] is Timestamp
            ? (map['puc_expiration'] as Timestamp).toDate()
            : null,
      );
    } catch (e) {
      // Logging the error for debugging
      print('Error in Car.fromMap: $e');
      throw e; // Rethrow the error after logging it
    }
  }

  String toJson() => json.encode(toMap());

  factory Car.fromJson(String source) => Car.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Car(fuelType: $fuelType, registrationNumber: $registrationNumber, insuranceExpiration: $insuranceExpiration, transmission: $transmission, carType: $carType, carModel: $carModel, registrationYear: $registrationYear, pucExpiration: $pucExpiration)';
  }

  @override
  bool operator ==(covariant Car other) {
    if (identical(this, other)) return true;

    return 
      other.fuelType == fuelType &&
      other.registrationNumber == registrationNumber &&
      other.insuranceExpiration == insuranceExpiration &&
      other.transmission == transmission &&
      other.carType == carType &&
      other.carModel == carModel &&
      other.registrationYear == registrationYear &&
      other.pucExpiration == pucExpiration;
  }

  @override
  int get hashCode {
    return fuelType.hashCode ^
      registrationNumber.hashCode ^
      insuranceExpiration.hashCode ^
      transmission.hashCode ^
      carType.hashCode ^
      carModel.hashCode ^
      registrationYear.hashCode ^
      pucExpiration.hashCode;
  }
}
