import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wrenchmate_user_app/app/data/models/booking_model.dart';
import 'package:wrenchmate_user_app/app/modules/booking/widgets/review%20widgets/deliveryReview.dart';

import '../../controllers/service_controller.dart';
import '../../data/models/Service_firebase.dart';
import '../../widgets/blueButton.dart';

class reviewPage extends StatefulWidget {
  const reviewPage({super.key});

  @override
  State<reviewPage> createState() => _reviewPageState();
}

class _reviewPageState extends State<reviewPage> {
  final Servicefirebase services = Get.arguments['service'];
  final Booking booking = Get.arguments['booking'];

  final ServiceController serviceController =
      Get.find(); // Get the ServiceController instance
  TextEditingController _controller = TextEditingController();
  TextEditingController _driverReviewcontroller = TextEditingController();

  int _rating = 0;

  void _setRating(int rating) {
    setState(() {
      _rating = rating;
    });
  }

  int _driverRating = 0;

  void _setDriverRating(int rating) {
    setState(() {
      _driverRating = rating;
    });
  }

  Widget _buildStar(int index) {
    return IconButton(
      icon: Icon(
        index < _rating ? Icons.star_rounded : Icons.star_border_rounded,
        color: Color(0xff1671D8),
        size: 28,
      ),
      onPressed: () => _setRating(index + 1),
    );
  }

  Widget _buildDriverStar(int index) {
    return IconButton(
      icon: Icon(
        index < _driverRating ? Icons.star_rounded : Icons.star_border_rounded,
        color: Color(0xff1671D8),
        size: 28,
      ),
      onPressed: () => _setDriverRating(index + 1),
    );
  }

  String _getRatingText() {
    switch (_rating) {
      case 1:
        return "Poor";
      case 2:
        return "Fair";
      case 3:
        return "Good";
      case 4:
        return "Very Good";
      case 5:
        return "Excellent";
      default:
        return "Rate this";
    }
  }

  void _printServiceReview(String review, double rating) {
    //handeling is remaining
    if (review.isNotEmpty && rating > 0) {
      serviceController.addReview(
        services.id,
        FirebaseAuth.instance.currentUser!.uid,
        review,
        rating,
      );
    }
  }

  void submitDriverReview(String review, double rating) {
    if (review.isNotEmpty && rating > 0) {
      serviceController.addDriverReview(
        FirebaseAuth.instance.currentUser!.uid,
        review,
        booking.assignedDriverPhone ?? '',
        booking.assignedDriverName ?? '',
        rating,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              //appbar
              Row(
                children: [
                  //back button
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffF6F6F5),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: IconButton(
                      icon: Icon(
                        CupertinoIcons.back,
                        color: Color(0xff1E1E1E),
                        size: 22,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Text(
                    "Write a Review",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  )
                ],
              ),
              SizedBox(
                height: 32,
              ),
              //service review tab
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 15,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 24.0, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_getRatingText()} Service',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children:
                            List.generate(5, (index) => _buildStar(index)),
                      ),
                      SizedBox(height: 8.0),
                      TextField(
                        controller: _controller,
                        maxLines: null,
                        minLines: 4,
                        keyboardType: TextInputType.multiline,
                        style: TextStyle(
                          color: Colors.grey, // Text color
                          fontSize: 18.0, // Text font size
                        ),
                        decoration: InputDecoration(
                          hintText: 'Write your thoughts',
                          hintStyle: TextStyle(
                            color: Colors.grey, // Hint text color
                            fontSize: 18.0, // Hint text font size
                          ),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 0.3),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 0.3),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 0.3),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 32,
              ),
              // deliveryReview(),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 15,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 24.0, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Row(
                          children: [
                            ClipOval(
                              child: Image.asset(
                                'assets/images/weekend.png',
                                fit: BoxFit.cover,
                                height: 65.0,
                                width: 65.0,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "   ${booking.assignedDriverName}",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                Row(
                                  children: List.generate(
                                      5, (index) => _buildDriverStar(index)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8.0),
                      TextField(
                        controller: _driverReviewcontroller,
                        maxLines: null,
                        minLines: 4,
                        keyboardType: TextInputType.multiline,
                        style: const TextStyle(
                          color: Colors.grey, // Text color
                          fontSize: 18.0, // Text font size
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Write your thoughts',
                          hintStyle: TextStyle(
                            color: Colors.grey, // Hint text color
                            fontSize: 18.0, // Hint text font size
                          ),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 0.3),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 0.3),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 0.3),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 32,
              ),
              SizedBox(
                height: 32,
              ),
              BlueButton(
                text: 'SUBMIT REVIEW',
                onTap: () {
                  _printServiceReview(_controller.text, _rating.toDouble());
                  submitDriverReview(_driverReviewcontroller.text,
                      _driverRating.toDouble()); // Print the review text
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return BottomSheet();
                    },
                  );
                },
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget BottomSheet() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 32,
          ),
          ClipOval(
            child: Image.asset(
              'assets/images/feedbackack.png',
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            "Thanks for giving \nyour feedback ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            "Your feedback means a lot for us and \nhelp us to improve our services.",
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 16,
          ),
          BlueButton(
              text: "DONE",
              onTap: () {
                Navigator.pop(context);
              })
        ],
      ),
    );
  }
}
