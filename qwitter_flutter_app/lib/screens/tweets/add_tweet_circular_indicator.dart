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
          progress < 0.8
              ? progress < 0.4
                  ? Colors.red
                  : const Color.fromARGB(255, 236, 214, 13)
              : Colors.blue,
        ),
      ),
    );
  }
}
