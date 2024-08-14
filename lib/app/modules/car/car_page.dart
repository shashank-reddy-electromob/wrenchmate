import 'package:flutter/material.dart';
import 'package:wrenchmate_user_app/app/modules/home/widgits/toprecommendedservices.dart';

class CarPage extends StatefulWidget {
  @override
  _CarPageState createState() => _CarPageState();
}

class _CarPageState extends State<CarPage> {
  bool isEditing = false;

  final TextEditingController regYearController =
      TextEditingController(text: '2019');
  final TextEditingController regNoController =
      TextEditingController(text: '19HY7983298989');
  final TextEditingController insuranceExpController =
      TextEditingController(text: '20/12/2024');
  final TextEditingController pucExpController =
      TextEditingController(text: '20/08/2024');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 46),
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
                        'Hyundai-Venue',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Petrol/ diesel',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Icon(Icons.chevron_right),
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: Image.asset(
                  'assets/car/imageofcar.png',
                  height: 150,
                ),
              ),
              SizedBox(height: 20),

              // Car Detail Section
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
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                setState(() {
                                  isEditing = !isEditing;
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                // Delete action
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    Divider(),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                            isEditing
                                ? TextField(
                                    controller: regYearController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      isDense:
                                          true, // Reduces the height of the text field
                                    ),
                                  )
                                : Text(regYearController.text),
                          ],
                        ),
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
                            isEditing
                                ? TextField(
                                    controller: regNoController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      isDense: true,
                                    ),
                                  )
                                : Text(regNoController.text),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                            isEditing
                                ? TextField(
                                    controller: insuranceExpController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      isDense: true,
                                    ),
                                  )
                                : Text(insuranceExpController.text),
                          ],
                        ),
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
                            isEditing
                                ? TextField(
                                    controller: pucExpController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      isDense: true,
                                    ),
                                  )
                                : Text(pucExpController.text),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              Row(
                children: [
                  GradientContainer(
                    width: MediaQuery.of(context).size.width / 2 - 36,
                    height: 120,
                    colors: [Color(0xff9DB3E5), Color(0xff3E31BF)],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/addnewcar.png',
                            height: 70,
                          ),
                          Text(
                            'Add New Car',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          )
                        ],
                      ),
                    ),
                  ),
                  GradientContainer(
                    width: MediaQuery.of(context).size.width / 2 - 36,
                    height: 120,
                    colors: [Color(0xffFEA563), Color(0xffFF5F81)],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/servicehistroy.png',
                            height: 70,
                          ),
                          Text(
                            'Service History',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          )
                        ],
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
