import 'package:flutter/material.dart';

class UnderlineTextFieldLabelOnly extends StatelessWidget {
  const UnderlineTextFieldLabelOnly({
    super.key,
    required this.keyboardType,
    required this.placeholder,
    required this.maxLines,
    required this.controller,
    required this.validator,
    required this.intialValue,
    required this.readOnly,
    required this.onTap,
  });
  final TextInputType keyboardType;
  final String placeholder;
  final int maxLines;
  final TextEditingController? controller;
  final String? Function(String? val) validator;
  final String? intialValue;
  final bool readOnly;
  final void Function()? onTap;


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: TextFormField(
        
        onTap: onTap,
        readOnly: readOnly,
        enabled: true,
        controller: controller,
        initialValue: intialValue,
        cursorColor: Colors.blue,
        validator: validator,
        autocorrect: true,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade500),
          ),
          labelText: placeholder,
          labelStyle:
              TextStyle(color: Colors.grey.shade700, fontSize: 23, height: 1),
          hintText: "",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          floatingLabelStyle:
              TextStyle(color: Colors.grey.shade700, fontSize: 23, height: 1),
          alignLabelWithHint: true,
          counterStyle: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 15,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        ),
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
  }
}
