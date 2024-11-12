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
  bool tracking_button = false;

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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final bottomNavHeight = screenHeight * 0.085;
    final fabSize = screenWidth * 0.080;
    final fabPadding = screenHeight * 0.02;
    final fabTopPadding = screenHeight * 0.05;
    final iconSize = screenWidth * 0.065;

    try {
      final tracking_button_ = Get.arguments['tracking_button'];
      setState(() {
        tracking_button = tracking_button_;
      });
    } catch (exception) {
      print("Error!!!");
    }
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            _widgetOptions.elementAt(_selectedIndex),
            if (tracking_button)
              DraggableFab(
                child: ClipOval(
                  child: Container(
                    width: fabSize * 2,
                    height: fabSize * 2,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Colors.blueAccent,
                        onTap: () {
                          Get.toNamed(AppRoutes.TRACKING);
                        },
                        child: SizedBox(
                          width: fabSize * 2,
                          height: fabSize * 2,
                          child: Image(
                            image: AssetImage("assets/images/track_icon.png"),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: EdgeInsets.only(top: fabTopPadding),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff3B7FFF), Color(0xff2666DE)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              shape: BoxShape.circle,
            ),
            padding: EdgeInsets.all(fabPadding),
            child: InkWell(
              splashColor: Colors.blueAccent,
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                });
              },
              child: SizedBox(
                width: fabSize,
                height: fabSize,
                child: ImageIcon(
                  AssetImage('assets/icons/car.png'),
                  color: Colors.white,
                  size: fabSize * 0.7,
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: Stack(
          children: [
            CustomPaint(
              size: Size(screenWidth, bottomNavHeight),
              painter: CurvedNavigationBarShape(),
            ),
            Container(
              height: bottomNavHeight,
              child: BottomNavigationBar(
                unselectedFontSize: screenWidth * 0.025,
                selectedFontSize: screenWidth * 0.028,
                unselectedLabelStyle: TextStyle(
                  fontSize: screenWidth * 0.025,
                ),
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: ImageIcon(
                      AssetImage('assets/icons/home.png'),
                      size: iconSize,
                    ),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: ImageIcon(
                      AssetImage('assets/icons/product.png'),
                      size: iconSize,
                    ),
                    label: 'Products',
                  ),
                  BottomNavigationBarItem(
                    icon: SizedBox(width: iconSize * 1.2),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: ImageIcon(
                      AssetImage('assets/icons/support.png'),
                      size: iconSize,
                    ),
                    label: 'Help',
                  ),
                  BottomNavigationBarItem(
                    icon: ImageIcon(
                      AssetImage('assets/icons/subscription.png'),
                      size: iconSize,
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
          ],
        ),
      ),
    );
  }
}

class CurvedNavigationBarShape extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Paint shadowPaint2 = Paint()
      ..color = Colors.black.withOpacity(0.7)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width * 0.42, 0);

    path.quadraticBezierTo(
      size.width * 0.5,
      -31,
      size.width * 0.58,
      0,
    );

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    Path shadowPath = Path();
    shadowPath.moveTo(0, 0);
    shadowPath.lineTo(size.width * 0.42, 0);
    shadowPath.quadraticBezierTo(
      size.width * 0.5,
      -31,
      size.width * 0.58,
      0,
    );
    shadowPath.lineTo(size.width, 0);

    canvas.save();
    canvas.translate(0, -1);
    canvas.drawPath(shadowPath, shadowPaint2);
    canvas.restore();

    canvas.drawPath(path, paint);

    Paint shadowPaint = Paint()..color = Colors.white;

    canvas.drawPath(path, shadowPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class SlidingContainer extends StatelessWidget {
  final bool isVisible;

  SlidingContainer({required this.isVisible});

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 300),
      bottom: isVisible ? 0 : -100,
      left: 0,
      right: 0,
      child: Container(
        height: 100,
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
