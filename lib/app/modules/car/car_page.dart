import 'package:flutter/material.dart';
import 'package:wrenchmate_user_app/app/modules/home/widgits/toprecommendedservices.dart';

class CarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('CarPage'),
      // ),
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
                      children: [
                        Text(
                          'Car Detail',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Edit action
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
                            Text('2019'),
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
                            Text('19HY7983298989'),
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
                            Text('20/12/2024'),
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
                            Text('20/08/2024'),
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
                  // ServiceCard(
                  //   serviceName: "General Wash",
                  //   price: "1,400",
                  //   rating: 4.9,
                  //   imagePath: 'assets/car/toprecommended1.png',
                  //   colors: [
                  //     Color(0xff9DB3E5),
                  //     Color(0xff3E31BF)
                  //   ], // Make sure you have an image in your assets
                  // ),
                  GradientContainer(
                    width: MediaQuery.of(context).size.width / 2 - 36,
                    height: 120,
                    colors: [Color(0xff9DB3E5), Color(0xff3E31BF)],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.start,
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
                        // crossAxisAlignment: CrossAxisAlignment.start,
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
                  // ServiceCard(
                  //   serviceName: "General Check-up",
                  //   price: "1,400",
                  //   rating: 4.9,
                  //   imagePath: 'assets/car/toprecommended2.png',
                  //   colors: [
                  //     Color(0xffFEA563),
                  //     Color(0xffFF5F81)
                  //   ], // Make sure you have an image in your assets
                  // ),
                  // GradientContainer(
                  //   width: MediaQuery.of(context).size.width / 2 - 36,
                  //   height: 120,
                  //   colors: [
                  //     Color(0xffFEA563),
                  //     Color(0xffFF5F81)
                  //   ], // Define the gradient colors
                  //   child: Text(""),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      //     BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Product'),
      //     BottomNavigationBarItem(icon: Icon(Icons.car_rental), label: 'Car'),
      //     BottomNavigationBarItem(icon: Icon(Icons.help), label: 'Help'),
      //     BottomNavigationBarItem(icon: Icon(Icons.subscriptions), label: 'Subscription'),
      //   ],
      //   currentIndex: 2,
      //   onTap: (index) {
      //     // Handle navigation
      //   },
      // ),
    );
  }
}
