import 'package:flutter/material.dart';

class SecondaryButtonOutlined extends StatelessWidget {
  const SecondaryButtonOutlined(
      {super.key, required this.text, required this.on_pressed});

  final String text;
  final VoidCallback on_pressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: on_pressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent, // Background color (white)
        foregroundColor: Colors.white,
        onSurface: Colors.grey, // Text color (black)
        elevation: 0, // No shadow
        padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 5), // Padding
        minimumSize: const Size(30, 30),
        maximumSize: const Size(170, 35),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: Colors.white),
        ),
      ),
      child: Text(text),
    );
  }
}
