import 'package:flutter/material.dart';

class MessagingTextField extends StatelessWidget {
  const MessagingTextField({super.key, required this.textController});
  final TextEditingController textController;
  @override
  Widget build(context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color.fromARGB(255, 50, 57, 64),
          ),
          child: TextField(
            style: const TextStyle(color: Color.fromARGB(255, 204, 203, 203)),
            controller: textController,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              hintStyle: TextStyle(
                color: Color.fromARGB(255, 204, 203, 203),
              ),
              contentPadding: const EdgeInsets.all(12),
              hintText: 'Start a message',
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
