import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenuTab extends StatefulWidget {
  final int index;
  final int? selectedIndex;
  final Function(int) onTap;
  final IconData icon;
  final String text;

  const MenuTab({
    Key? key,
    required this.index,
    this.selectedIndex,
    required this.onTap,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  _MenuTabState createState() => _MenuTabState();
}

class _MenuTabState extends State<MenuTab> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bool isSelected = widget.index == widget.selectedIndex;

    return GestureDetector(
      onTap: () => widget.onTap(widget.index),
      child: MouseRegion(
        onEnter: (_) => _onHover(true),
        onExit: (_) => _onHover(false),
        child: Container(
          // width: 200,
          decoration: BoxDecoration(
            color: isSelected || _isHovered
                ? Color(0xff2666DE)
                : Colors.transparent,
            gradient: LinearGradient(
              colors: [Color(0xff2666DE), Color(0xffFFFFFF)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          child: Row(
            children: [
              Icon(
                widget.icon,
                color: isSelected ? Colors.white : Color(0xff797979),
              ),
              SizedBox(width: 10),
              Text(
                widget.text,
                style: TextStyle(
                  fontFamily: 'Raleway',
                  color: isSelected ? Colors.white : Color(0xff797979),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
  }
}
