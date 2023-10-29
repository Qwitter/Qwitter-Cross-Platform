import 'package:flutter/material.dart';

class SecondaryButtonOutlined extends StatelessWidget {
  const SecondaryButtonOutlined({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Add your button click logic here
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent, // Background color (white)
        foregroundColor: Colors.white, // Text color (black)
        elevation: 0, // No shadow
        padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24), // Custom shape
          side: const BorderSide(color: Colors.white),
        ),
      ),
      child: Text(text),
    );
  }
}
