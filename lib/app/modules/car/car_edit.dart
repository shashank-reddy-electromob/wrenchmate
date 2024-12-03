import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wrenchmate_user_app/app/modules/bottomnavigation/bottomnavigation.dart';
import 'package:wrenchmate_user_app/app/widgets/blueButton.dart';
import 'package:get/get.dart';

import '../../controllers/car_controller.dart';
import '../../widgets/custombackbutton.dart';

class CarEdit extends StatefulWidget {
  const CarEdit({super.key});

  @override
  State<CarEdit> createState() => _CarDetailsState();
}

class _CarDetailsState extends State<CarEdit> {
  late Map<String, dynamic>? existingCar;
  late String carId;
  String? selectedFuelType;
  String? selectedTransmissionType;
  String? selectedCarModel;
  TextEditingController regNoController = TextEditingController();
  TextEditingController regYearController = TextEditingController();
  TextEditingController insuranceExpController = TextEditingController();
  TextEditingController pucExpDateController = TextEditingController();
  CarController? carController = Get.find<CarController>();
  int? selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    existingCar = Get.arguments['carDetails'];
    carId = Get.arguments['carId'];
    if (existingCar != null) {
      selectedFuelType = existingCar!['fuel_type'];
      regNoController.text = existingCar!['registration_number'];
      insuranceExpController.text = existingCar!['insurance_expiration'] != null
          ? DateFormat('dd/MM/yyyy').format(
              (existingCar!['insurance_expiration'] as Timestamp).toDate())
          : '';
      selectedTransmissionType = existingCar!['transmission'];
      selectedCarModel = existingCar!['car_model'];

      regYearController.text = existingCar!['registration_year'] != null
          ? DateFormat('dd/MM/yyyy')
              .format((existingCar!['registration_year'] as Timestamp).toDate())
          : '';

      pucExpDateController.text = existingCar!['puc_expiration'] != null
          ? DateFormat('dd/MM/yyyy')
              .format((existingCar!['puc_expiration'] as Timestamp).toDate())
          : '';

      selectedIndex = carNames.indexOf(existingCar!['car_type']);
    } else {
      selectedIndex = Get.arguments as int? ?? 0;
    }
  }

  final List<String> carNames = ['Hatchback', 'Sedan', 'Compact SUV', 'SUV'];
  final List<String> carImages = [
    'assets/car/hatchback.png',
    'assets/car/sedan.png',
    'assets/car/compact_suv.png',
    'assets/car/suv.png'
  ];

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null)
      setState(() {
        controller.text = DateFormat('dd/MM/yyyy').format(picked);
      });
  }

  void saveCar() async {
    if (selectedCarModel == null ||
        selectedTransmissionType == null ||
        selectedFuelType == null ||
        regNoController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all required fields',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    await carController?.updateCar(
      carId: carId,
      fuelType: selectedFuelType!,
      registrationNumber: regNoController.text,
      insuranceExpiration: insuranceExpController.text.isNotEmpty
          ? DateFormat('dd/MM/yyyy').parse(insuranceExpController.text)
          : null,
      transmission: selectedTransmissionType!,
      carType: carNames[selectedIndex ?? 0],
      carModel: selectedCarModel!,
      registrationYear: regYearController.text.isNotEmpty
          ? DateFormat('dd/MM/yyyy').parse(regYearController.text)
          : null,
      pucExpiration: pucExpDateController.text.isNotEmpty
          ? DateFormat('dd/MM/yyyy').parse(pucExpDateController.text)
          : null,
    );
      // Navigator.push(context, MaterialPageRoute(builder: (context)=>bottomnavigation()));

  }

  @override
  Widget build(BuildContext context) {
    final int index = selectedIndex ?? 0;
    String selectedCarType = carNames[index];
    String selectedCarImage = carImages[index];

    List<String> carModels = carController!.getCarModels(selectedCarType);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Select Your Car',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Custombackbutton(),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 16, top: 8),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xff3778F2),
                    ),
                  ),
                  Positioned(
                    left: 8,
                    child: Container(
                      width: MediaQuery.of(context).size.width - 16,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Image.asset(
                              selectedCarImage,
                              height: 90,
                            ),
                          ),
                          Expanded(
                            child: CustomDropdown(
                              label: "Car Model",
                              value: selectedCarModel,
                              items: carModels,
                              onChanged: (value) {
                                setState(() {
                                  selectedCarModel = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height - 216,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CustomDropdown(
                      label: "Fuel Type",
                      value: selectedFuelType,
                      items: ["Petrol", "Diesel", "CNG"],
                      onChanged: (value) {
                        setState(() {
                          selectedFuelType = value;
                        });
                      },
                    ),
                    CustomTextField(
                      controller: regNoController,
                      hintText: 'Reg No.',
                    ),
                    Wrap(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: CustomDateField(
                            controller: regYearController,
                            label: "Reg Year",
                            onTap: () =>
                                _selectDate(context, regYearController),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: CustomDateField(
                            controller: insuranceExpController,
                            label: "Insurance Exp.",
                            onTap: () =>
                                _selectDate(context, insuranceExpController),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: CustomDateField(
                            controller: pucExpDateController,
                            label: "PUC Exp Date",
                            onTap: () =>
                                _selectDate(context, pucExpDateController),
                          ),
                        ),
                      ],
                    ),
                    CustomDropdown(
                      label: "Car Transmission Type",
                      value: selectedTransmissionType,
                      items: ["Manual", "Automatic", "IMT"],
                      onChanged: (value) {
                        setState(() {
                          selectedTransmissionType = value;
                        });
                      },
                    ),
                    Spacer(),
                    BlueButton(
                      text: 'SAVE',
                      onTap: saveCar,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const CustomDropdown({
    Key? key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        hintText: label,
        hintStyle: TextStyle(color: Color(0xFFB8B8BC)),
        contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFB8B8BC)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFB8B8BC)),
        ),
      ),
      value: value,
      onChanged: onChanged,
      dropdownColor: Colors.white,
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem(
          value: value,
          child: Text(
            value,
            style: TextStyle(fontSize: 16.0),
          ),
        );
      }).toList(),
      isExpanded: false,
    );
  }
}

class CustomDateField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final VoidCallback onTap;

  const CustomDateField({
    Key? key,
    required this.controller,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ((MediaQuery.of(context).size.width - 32) / 2) - 8,
      padding: EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(color: Color(0xFFB8B8BC)),
          contentPadding:
              EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFB8B8BC)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFB8B8BC)),
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.calendar_month_outlined, color: Color(0xff7F7F7F)),
            onPressed: onTap,
          ),
        ),
        readOnly: true,
        style: TextStyle(fontSize: 18.0),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textCapitalization: TextCapitalization.characters,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Color(0xFFB8B8BC)),
        contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFB8B8BC)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFB8B8BC)),
        ),
      ),
      style: TextStyle(fontSize: 18.0),
    );
  }
}
