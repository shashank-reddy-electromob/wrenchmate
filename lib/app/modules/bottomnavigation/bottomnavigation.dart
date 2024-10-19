import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:wrenchmate_user_app/app/modules/home/home_page.dart';
import '../../routes/app_routes.dart';
import '../car/car_page.dart';
import '../product/productscreen.dart';
import '../subscription/subscription_page.dart';
import '../support/support_page.dart';

class bottomnavigation extends StatefulWidget {
  const bottomnavigation({super.key});

  @override
  State<bottomnavigation> createState() => _bottomnavigationState();
}

class _bottomnavigationState extends State<bottomnavigation> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = [
    HomePage(),
    ProductScreen(),
    CarPage(),
    SupportPage(),
    SubscriptionPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0;
      });
      return false;
    } else {
      SystemNavigator.pop();
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            _widgetOptions.elementAt(_selectedIndex),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: ClipOval(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff3B7FFF), Color(0xff2666DE)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              shape: BoxShape.circle,
            ),
            padding: EdgeInsets.all(12),
            child: InkWell(
              splashColor: Colors.blueAccent,
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                });
              },
              child: SizedBox(
                width: 36,
                height: 36,
                child: ImageIcon(
                  AssetImage('assets/icons/car.png'),
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('assets/icons/home.png'),
                size: 25,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('assets/icons/product.png'),
                size: 25,
              ),
              label: 'Product',
            ),
            BottomNavigationBarItem(
              icon: SizedBox(width: 10),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('assets/icons/support.png'),
                size: 25,
              ),
              label: 'Help',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('assets/icons/subscription.png'),
                size: 25,
              ),
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
          showUnselectedLabels: true,
        ),
      ),
    );
  }
}

class SlidingContainer extends StatelessWidget {
  final bool isVisible;

  SlidingContainer({required this.isVisible});

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 300),
      bottom: isVisible ? 0 : -100, // Adjust these values as needed
      left: 0,
      right: 0,
      child: Container(
        height: 100, // Adjust height as needed
        color: Colors.blueAccent,
        child: Center(
          child: Text(
            "Sliding Container",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
