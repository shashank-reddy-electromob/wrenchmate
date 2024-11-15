import 'package:flutter/material.dart';

class PlanCard extends StatelessWidget {
  final Map<String, dynamic> plan;
  final bool isMonthly;
  final int totalPlans;
  final int currentIndex;

  PlanCard(
    this.plan,
    this.isMonthly,
    this.totalPlans,
    this.currentIndex,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xffC6DFFE),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomRight: isMonthly ? Radius.circular(16) : Radius.circular(0),
              bottomLeft: isMonthly ? Radius.circular(0) : Radius.circular(16)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              plan['title'],
              style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: MediaQuery.of(context).size.width * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            ...plan['details'].map<Widget>((detail) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      detail['title'],
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      detail['description'],
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: List.generate(totalPlans, (index) {
                    //     return Container(
                    //       margin: EdgeInsets.symmetric(horizontal: 4.0),
                    //       width: 8.0,
                    //       height: 8.0,
                    //       decoration: BoxDecoration(
                    //         shape: BoxShape.circle,
                    //         color: currentIndex == index
                    //             ? Colors.blue
                    //             : Colors.grey,
                    //       ),
                    //     );
                    //   }),
                    // ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
