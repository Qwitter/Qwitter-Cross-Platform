import 'package:flutter/material.dart';

class MessagingTextField extends StatelessWidget {
  const MessagingTextField({super.key, required this.textController});
  final TextEditingController textController;
  @override
  Widget build(context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: TextField(
            controller: textController,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(12),
              hintText: 'Start a messeage',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
