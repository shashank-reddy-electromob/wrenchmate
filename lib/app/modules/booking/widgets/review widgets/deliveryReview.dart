import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class deliveryReview extends StatefulWidget {
  const deliveryReview({super.key});

  @override
  State<deliveryReview> createState() => _deliveryReviewState();
}

class _deliveryReviewState extends State<deliveryReview> {
  TextEditingController _controller = TextEditingController();
  int _rating = 0;

  void _setRating(int rating) {
    setState(() {
      _rating = rating;
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
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
        padding: const EdgeInsets.symmetric(vertical: 24.0,horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rate Our Deliver',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
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
                  Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("   Alex Brother",style: TextStyle(
                        fontSize: 20,
                      ),),
                      Row(
                        children: List.generate(5, (index) => _buildStar(index)),
                      ),
                    ],
                  ),
                ],
              ),
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
                  borderSide: BorderSide(color: Colors.grey,width: 0.3),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey,width: 0.3),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey,width: 0.3),
                ),
              ),
            ),



            SizedBox(height: 10),

          ],
        ),
      ),
    );
  }
}
