import 'package:flutter/material.dart';

class PremiumToggle extends StatefulWidget {
  final bool isPremium;
  final Function(bool) onToggle;
  final Function pricesetMethod;

  const PremiumToggle({
    Key? key,
    required this.isPremium,
    required this.onToggle,
    required this.pricesetMethod,
  }) : super(key: key);

  @override
  _PremiumToggleState createState() => _PremiumToggleState();
}

class _PremiumToggleState extends State<PremiumToggle> {
  late bool premium;

  @override
  void initState() {
    super.initState();
    premium = widget.isPremium;
  }

  void togglePremium() {
    setState(() {
      premium = !premium;
    });
    widget.onToggle(premium);
    widget.pricesetMethod();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: togglePremium,
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
          ),
        ),
        SizedBox(width: 20),
        GestureDetector(
          onTap: togglePremium,
          child: Icon(
            Icons.arrow_forward_ios_rounded,
            size: 20,
          ),
        ),
      ],
    );
  }
}
