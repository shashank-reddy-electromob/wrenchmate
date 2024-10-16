import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimeLineText extends StatelessWidget {
  final bool isPast;
  final String child;
  final String time;
  const TimeLineText({super.key,required this.isPast, required this.child, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal:  30),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(child,style: TextStyle(fontSize: 18, color: isPast?Colors.black:Colors.grey,),),
              Text(time,style: TextStyle(color:Colors.grey,),),
            ],
          ),
          SizedBox(height: 8,),
          Text("Your Booking accepted",style: TextStyle(fontSize: 14, color: isPast?Colors.black:Colors.grey,),),
          Text(time,style: TextStyle(fontSize: 12, color: isPast?Colors.black:Colors.grey,),),
        ],
      ),
    );
  }
}
