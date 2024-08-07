import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wrenchmate_user_app/app/widgets/blueButton.dart';

import '../../routes/app_routes.dart';
import '../../widgets/custombackbutton.dart';

class CarRegister extends StatefulWidget {
  const CarRegister({super.key});

  @override
  State<CarRegister> createState() => _CarRegisterState();
}

class _CarRegisterState extends State<CarRegister> {
  int _selectedCardIndex=0;

  void _onCardTap(int index) {
    setState(() {
      _selectedCardIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
        child: Container(
          height: MediaQuery.of(context).size.height-100,
          child: Column(
            children: [
              //search
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:  16.0,vertical: 8),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("What your Car name?",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Color(0xff969696)),)),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                    color: Color(0xffF7F7F7),
                    borderRadius: BorderRadius.circular(8)
                ),
                child: Center(
                  child: TextField(
                    cursorColor: Colors.grey,
                    decoration: InputDecoration(
                      hintText: "Search your Car",
                      hintStyle: TextStyle(
                        color: Color(0xff858585),
                        fontSize: 20,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Color(0xff838383),
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    style: TextStyle(
                      fontSize:
                      20, // Increase the font size for the entered text
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:  16.0,vertical: 8),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Your car comes under",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Color(0xff969696)),)),
              ),
              //cards
              Container(
                height: MediaQuery.of(context).size.height*0.48,
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: GridView.count(
                  crossAxisCount: 2,
                  children: [
                    CarCard(
                      onTap: () => _onCardTap(0),
                      isSelected: _selectedCardIndex == 0,
                      name: 'Hatchback',
                      imagePath: 'assets/car/Matchback.png',
                    ),
                    CarCard(
                      onTap: () => _onCardTap(1),
                      isSelected: _selectedCardIndex == 1,
                      name: 'Sedan',
                      imagePath: 'assets/car/sedan.png',
                    ),
                    CarCard(
                      onTap: () => _onCardTap(2),
                      isSelected: _selectedCardIndex == 2,
                      name: 'Compact SUV',
                      imagePath: 'assets/car/compact_suv.png',
                    ),
                    CarCard(
                      onTap: () => _onCardTap(3),
                      isSelected: _selectedCardIndex == 3,
                      name: 'SUV',
                      imagePath: 'assets/car/suv.png',
                    ),
                  ],
                ),
              ),
              Spacer(),
              blueButton(text: "CONTINUE", onTap: (){
                Get.toNamed(AppRoutes.CAR_DETALS,arguments:_selectedCardIndex);
              }),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class CarCard extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isSelected;
  final String name;
  final String imagePath;

  const CarCard({
    Key? key,
    this.onTap,
    required this.isSelected,
    required this.name,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Color(0xffEAEAEA),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, height: MediaQuery.of(context).size.height*0.09), // Use the provided image path
            SizedBox(height: 8),
            Text(
              name, // Use the provided name
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}