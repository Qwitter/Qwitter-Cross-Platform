import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key, required this.text, this.on_pressed});

  final String text;
  final VoidCallback? on_pressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor:
            const Color.fromARGB(255, 29, 155, 240), // Text color (black)
        foregroundColor: Colors.white,
        onSurface: Colors.blue, // Background color (white)
        elevation: 0, // No shadow
        padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24), // Custom shape
        ),
      ),
      onPressed: on_pressed,
      child: Text(text),
    );
  }
}
