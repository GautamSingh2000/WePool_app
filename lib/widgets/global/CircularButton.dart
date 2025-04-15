import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  final double size;
  final VoidCallback? onTap;

  CircularButton({
    required this.size,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue, // You can customize the color
          border: Border.all(
            color: Colors.blue.withOpacity(0.3), // You can customize the border color
            width: 2.0, // You can customize the border width
          ),
        ),
        child: Center(
          child: Icon(
            Icons.arrow_forward, // The arrow icon
            color: Colors.white, // You can customize the icon color
            size: size * 0.5, // Adjust the icon size relative to the button size
          ),
        ),
      ),
    );
  }
}