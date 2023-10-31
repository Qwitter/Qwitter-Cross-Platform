import 'dart:ffi';

import 'package:flutter/material.dart';

class DecoratedTextField extends StatefulWidget {
  const DecoratedTextField(
      {super.key,
      required this.keyboardType,
      required this.placeholder,
      this.padding_value =
          const EdgeInsets.symmetric(vertical: 3, horizontal: 20),
      this.max_length = 0});
  final TextInputType keyboardType;
  final String placeholder;
  final int max_length;
  final EdgeInsets padding_value;

  @override
  State<DecoratedTextField> createState() => _DecoratedTextFieldState();
}

class _DecoratedTextFieldState extends State<DecoratedTextField> {
  // bool _isSelected = false;
  late FocusNode _focusNode;
  TextEditingController myController = TextEditingController();
  bool is_valid = true;
  Color border_color = Colors.grey.shade500;
  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding_value,
      child: TextFormField(
        controller: myController,
        onTapOutside: (event) {
          Focus.of(context).unfocus();
        },
        // The state is valid when the input text contains number 1 for testing purpose
        onChanged: (value) => setState(() {
          if (value.contains('1')) {
            is_valid = false;
          } else {
            is_valid = true;
          }
        }),
        focusNode: _focusNode,
        maxLength: widget.max_length > 0 ? widget.max_length : null,
        autocorrect: true,
        keyboardType: widget.keyboardType,
        cursorColor: Colors.blue,
        decoration: InputDecoration(
          suffixIcon: myController.text.isNotEmpty
              ? is_valid
                  ? const Icon(
                      Icons.check_circle,
                      color: Color.fromARGB(255, 0, 185, 123),
                      size: 18,
                    )
                  : const Icon(
                      Icons.error,
                      color: Color.fromARGB(255, 243, 33, 47),
                      size: 18,
                    )
              : null,
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(
              color: !is_valid && myController.text.isNotEmpty
                  ? const Color.fromARGB(255, 243, 33, 47)
                  : Colors.blue,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: !is_valid && myController.text.isNotEmpty
                  ? const Color.fromARGB(255, 243, 33, 47)
                  : const Color.fromARGB(255, 107, 125, 139),
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          labelText: _focusNode.hasFocus || myController.text.isNotEmpty
              ? widget.placeholder
              : null,
          labelStyle: TextStyle(
            color: !is_valid
                ? const Color.fromARGB(255, 243, 33, 47)
                : myController.text.isNotEmpty && !_focusNode.hasFocus
                    ? const Color.fromARGB(255, 107, 125, 139)
                    : Colors.blue,
            fontSize: 16,
          ),
          hintText: !_focusNode.hasFocus ? widget.placeholder : null,
          hintStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color.fromARGB(255, 107, 125, 139),
          ),
          counterText: widget.max_length > 0 ? null : '',
          counterStyle: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 13,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
        ),
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w300,
          color: _focusNode.hasFocus || myController.text.isNotEmpty
              ? Colors.white
              : const Color.fromARGB(255, 107, 125, 139),
        ),
      ),
    );
  }
}
