import 'package:flutter/material.dart';

class IconButton extends StatelessWidget {
  const IconButton(
      {super.key,
      required this.text,
      required this.onPressed,
      required this.image});

  final String image;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white, // Text color (black)
        foregroundColor: Colors.black, // Background color (white)
        elevation: 0, // No shadow
        padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24), // Custom shape
        ),
      ),
      icon: Image.asset(
        image,
      ),
      label: Text(text),
    );
  }
}