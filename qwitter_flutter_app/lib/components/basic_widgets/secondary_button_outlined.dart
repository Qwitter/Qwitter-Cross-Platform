import 'package:flutter/material.dart';

class SecondaryButtonOutlined extends StatelessWidget {
  const SecondaryButtonOutlined(
      {super.key,
      required this.text,
      required this.onPressed,
      this.paddingValue =
          const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      this.textStyle = const TextStyle(fontSize: 14)});

  final String text;
  final VoidCallback onPressed;
  final EdgeInsets paddingValue;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent, // Background color (white)
        foregroundColor: Colors.white,
        disabledForegroundColor: Colors.grey.withOpacity(0.38),
        disabledBackgroundColor:
            Colors.grey.withOpacity(0.12), // Text color (black)
        elevation: 0, // No shadow
        padding: paddingValue,
        minimumSize: const Size(30, 30),
        maximumSize: const Size(170, 35),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: Colors.white),
        ),
      ),
      child: Text(text, style: textStyle),
    );
  }
}
