import 'package:flutter/material.dart';

class AddTweetCircularIndicator extends StatelessWidget {
  final double progress;

  const AddTweetCircularIndicator({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: CircularProgressIndicator(
        value: progress,
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          progress < 0.2 ? Colors.red : Colors.blue,
        ),
      ),
    );
  }
}
