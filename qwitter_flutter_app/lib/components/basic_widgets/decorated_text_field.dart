import 'package:flutter/material.dart';

class DecoratedTextField extends StatefulWidget {
  const DecoratedTextField(
      {super.key, required this.keyboardType, required this.placeholder});
  final TextInputType keyboardType;
  final String placeholder;

  @override
  State<DecoratedTextField> createState() => _DecoratedTextFieldState();
}

class _DecoratedTextFieldState extends State<DecoratedTextField> {
  // bool _isSelected = false;
  late FocusNode _focusNode;

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
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: TextFormField(
        onTapOutside: (event) {
          Focus.of(context).unfocus();
        },
        focusNode: _focusNode,
        maxLength: 50,
        autocorrect: true,
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: Colors.blue),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade500),
            borderRadius: const BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          labelText: _focusNode.hasFocus ? widget.placeholder : null,
          labelStyle: const TextStyle(
            color: Colors.blue,
            fontSize: 25,
          ),
          hintText: !_focusNode.hasFocus ? widget.placeholder : null,
          hintStyle: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
          counterStyle: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 15,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal:10 ,vertical: 15),
        ),
        style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w300,
          color: Colors.white,
        ),
      ),
    );
  }
}
