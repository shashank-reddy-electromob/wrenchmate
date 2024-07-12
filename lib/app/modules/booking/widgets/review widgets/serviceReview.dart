import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class serviceReview extends StatefulWidget {
  const serviceReview({super.key});

  @override
  State<serviceReview> createState() => _serviceReviewState();
}

class _serviceReviewState extends State<serviceReview> {
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
              '${_getRatingText()} Service',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Row(
              children: List.generate(5, (index) => _buildStar(index)),
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
