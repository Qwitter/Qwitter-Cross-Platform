import 'package:flutter/material.dart';
import 'package:qwitter_flutter_app/screens/authentication/signup/select_languages_screen.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton(
      {super.key, required this.text, required this.on_pressed});

  final String text;
  final VoidCallback on_pressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: on_pressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white, // Background color (white)
        foregroundColor: Colors.black, // Text color (black)
        elevation: 0, // No shadow
        padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24), // Custom shape
        ),
      ),
      child: Text(text),
    );
  }
}
