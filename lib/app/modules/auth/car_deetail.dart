import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wrenchmate_user_app/app/widgets/blueButton.dart';
import 'package:get/get.dart'; // Ensure you have this import

import '../../controllers/car_controller.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custombackbutton.dart';

class CarDetails extends StatefulWidget {
  const CarDetails({super.key}); // Remove selectedIndex from constructor

  @override
  State<CarDetails> createState() => _CarDetailsState();
}

class _CarDetailsState extends State<CarDetails> {
  String? selectedFuelType;
  String? selectedTransmissionType;
  TextEditingController regNoController = TextEditingController();
  TextEditingController regYearController = TextEditingController();
  TextEditingController insuranceExpController = TextEditingController();
  TextEditingController pucExpDateController = TextEditingController();
  CarController? carController;
@override

void initState() {
  carController = Get.put(CarController());
  selectedIndex = Get.arguments as int;
  }
  final List<String> carNames = ['Hatchback', 'Sedan', 'Compact SUV', 'SUV'];
  final List<String> carImages = [
    'assets/car/Matchback.png',
    'assets/car/sedan.png',
    'assets/car/compact_suv.png',
    'assets/car/suv.png'
  ];
  int? selectedIndex;

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
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

  @override
  Widget build(BuildContext context) {
    String selectedCarName = carNames[selectedIndex!];
    String selectedCarImage = carImages[selectedIndex!];
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
      body: SingleChildScrollView(scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 16,top: 8),
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
                          SizedBox(width: 16,),
                          Image.asset(selectedCarImage,height: 90,),
                          SizedBox(width: 16,),
                          Text(selectedCarName,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 24),)
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
                            onTap: () => _selectDate(context, regYearController),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: CustomDateField(
                            controller: insuranceExpController,
                            label: "Insurance Exp.",
                            onTap: () => _selectDate(context, insuranceExpController),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: CustomDateField(
                            controller: pucExpDateController,
                            label: "PUC Exp Date",
                            onTap: () => _selectDate(context, pucExpDateController),
                          ),
                        ),
                      ],
                    ),
                    CustomDropdown(
                      label: "Car Transmission Type",
                      value: selectedTransmissionType,
                      items: ["Manual", "Automatic"],
                      onChanged: (value) {
                        setState(() {
                          selectedTransmissionType = value;
                        });
                      },
                    ),
                    Spacer(),
                    blueButton(text: 'COMPLETED', onTap: () async{
                      print("tapped");
                      // await carController?.addCarTo500x(
                      //   fuelType: 'Petrol',
                      //   registrationNumber: 'ABC1234',
                      //   registrationYear: 2021,
                      //   pucExpiration: DateTime(2022, 12, 31),
                      //   insuranceExpiration: DateTime(2023, 12, 31),
                      //   transmission: 'Automatic',
                      // );
                      Get.toNamed(AppRoutes.BOTTOMNAV);
                    }),
                    SizedBox(width: 16,),

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
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem(
          value: value,
          child: Text(
            value,
            style: TextStyle(fontSize: 18.0),
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
          contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
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