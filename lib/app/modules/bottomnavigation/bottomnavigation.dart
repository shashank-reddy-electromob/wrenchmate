import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wrenchmate_user_app/app/modules/home/home_page.dart';

import '../../controllers/home_controller.dart';
import '../../routes/app_routes.dart';
import '../booking/booking_page.dart';
import '../car/car_page.dart';
import '../subscription/subscription_page.dart';
import '../support/support_page.dart';

class bottomnavigation extends StatefulWidget {
  const bottomnavigation({super.key});

  @override
  State<bottomnavigation> createState() => _bottomnavigationState();
}

class _bottomnavigationState extends State<bottomnavigation> {
  int _selectedIndex = 0;
  static  List<Widget> _widgetOptions = [
    HomePage(),
    BookingPage(),
    CarPage(),
    SupportPage(),
    SubscriptionPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    return Scaffold(
      backgroundColor: Colors.white,

      body: _widgetOptions.elementAt(_selectedIndex),
      // floatingActionButton: DraggableFab(
      //   child:ClipOval(
      //     child: Material(
      //       color: Colors.blue, // Button color
      //       child: InkWell(
      //         splashColor: Colors.blueAccent, // Splash color
      //         onTap: () {
      //           Get.toNamed(AppRoutes.TRACKING);
      //         },
      //         child: SizedBox(
      //           width: 60,
      //           height: 60,
      //         ),
      //       ),
      //     ),
      //   )
      //
      //
      // ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined,size: 30,),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined,size: 30,),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff3B7FFF), Color(0xff2666DE)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              padding: EdgeInsets.all(8),
              child: Icon(Icons.directions_car, color: Colors.white,size: 30,),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.call,size: 30,),
            label: 'Support',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.subscriptions_outlined,size: 30,),
            label: 'Subscription',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xff2C6DE7),
        unselectedItemColor: Color(0xff323232),
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,


      ),
    );
  }
}