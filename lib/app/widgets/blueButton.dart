import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlueButton extends StatelessWidget {
  final String text;
  final double buttonHeight;
  final double fontSize;
  final VoidCallback onTap;
  final IconData? icon;

  const BlueButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.fontSize = 20.0,
    this.buttonHeight = 16.0,
    this.icon, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      child: ElevatedButton(
        onPressed: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (icon != null) ...[
                SizedBox(width: 15), 
              ],
              Expanded(
                child: Align(
                  alignment: Alignment.center, 
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: fontSize,
                      color: Colors.white,
                      fontFamily: 'Raleway',
                    ),
                  ),
                ),
              ),
              if (icon != null) ...[
                SizedBox(width: 8), 
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Color(0xff2c45e1)),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Icon(icon, color: Colors.white),
                    )),
              ],
            ],
          ),
        ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 10),
          backgroundColor: Color(0XFF1671D8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
      ),
    );
  }
}
