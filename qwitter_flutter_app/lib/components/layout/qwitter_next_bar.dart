import 'package:flutter/material.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/secondary_button.dart';

class QwitterNextBar extends StatelessWidget {
  const QwitterNextBar({super.key, required this.buttonFunction});
  final VoidCallback? buttonFunction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 5),
      decoration: const BoxDecoration(
        color: Colors.black,
        border: Border(
          top: BorderSide(
            color: Colors.grey, // Border color
            width: 0.05, // Border width
          ),
        ),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        Padding(
          padding: EdgeInsets.only(right: 16),
          child: SecondaryButton(text: 'Next', on_pressed: buttonFunction),
        ),
      ]),
    );
  }
}
