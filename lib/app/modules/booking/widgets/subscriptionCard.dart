import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SubscriptionCard extends StatefulWidget {
  final String title;
  final DateTime startDate;
  final int totalSlots;
  final int selectedSlotIndex;
  final Function(DateTime)? onDateSelected;

  const SubscriptionCard({
    Key? key,
    required this.title,
    required this.startDate,
    required this.totalSlots,
    required this.selectedSlotIndex,
    this.onDateSelected,
  }) : super(key: key);

  @override
  State<SubscriptionCard> createState() => _SubscriptionCardState();
}

class _SubscriptionCardState extends State<SubscriptionCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(width: 1, color: Colors.grey.shade300)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Subscription include',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade800,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 25,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: List.generate(widget.totalSlots, (index) {
                        return Flexible(
                          flex: index == widget.selectedSlotIndex ? 2 : 1,
                          child: Container(
                            decoration: BoxDecoration(
                              color: widget.selectedSlotIndex == index
                                  ? Color(0xff1671D8)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.only(
                                topLeft: index == 0
                                    ? const Radius.circular(10)
                                    : Radius.zero,
                                bottomLeft: index == 0
                                    ? const Radius.circular(10)
                                    : Radius.zero,
                                topRight: index == widget.totalSlots - 1
                                    ? const Radius.circular(10)
                                    : Radius.zero,
                                bottomRight: index == widget.totalSlots - 1
                                    ? const Radius.circular(10)
                                    : Radius.zero,
                              ),
                              border: Border(
                                right: index < widget.totalSlots - 1
                                    ? BorderSide(color: Colors.blue)
                                    : BorderSide.none,
                              ),
                            ),
                            child: Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 5, right: 5),
                                child: Text(
                                  index == widget.selectedSlotIndex
                                      ? DateFormat('dd MMM yyyy')
                                          .format(widget.startDate)
                                      : '',
                                  style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Horizontal scrollable list of subscription cards
// class SubscriptionsList extends StatelessWidget {
//   final List<SubscriptionData> subscriptions;

//   const SubscriptionsList({
//     Key? key,
//     required this.subscriptions,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: subscriptions.map((subscription) {
//           return Container(
//             width: Get.width * 0.86,
//             margin: const EdgeInsets.only(right: 15),
//             child: SubscriptionCard(
//               title: subscription.title,
//               startDate: subscription.startDate,
//               totalSlots: subscription.totalSlots,
//               selectedSlotIndex: subscription.selectedSlotIndex,
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
// }

// // Data model for subscription
// class SubscriptionData {
//   final String title;
//   final DateTime startDate;
//   final int totalSlots;
//   final int selectedSlotIndex;
//   final double progress;

//   SubscriptionData({
//     required this.title,
//     required this.startDate,
//     required this.totalSlots,
//     this.selectedSlotIndex = 0,
//     this.progress = 0,
//   });
// }
