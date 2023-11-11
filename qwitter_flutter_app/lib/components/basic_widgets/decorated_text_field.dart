import 'package:flutter/material.dart';

class DecoratedTextField extends StatefulWidget {
  const DecoratedTextField({
    super.key,
    required this.keyboardType,
    required this.placeholder,
    this.paddingValue = const EdgeInsets.symmetric(vertical: 3, horizontal: 20),
    this.maxLength = 0,
    required this.controller,
    this.enabled = true,
    this.isPassword = false,
    this.validator,
  });
  final TextInputType keyboardType;
  final String placeholder;
  final int maxLength;
  final EdgeInsets paddingValue;
  final TextEditingController? controller;
  final bool enabled;
  final bool isPassword;
  final String? Function(String?)? validator;

  @override
  State<DecoratedTextField> createState() => _DecoratedTextFieldState();
}

class _DecoratedTextFieldState extends State<DecoratedTextField> {
  // bool _isSelected = false;
  late FocusNode _focusNode;
  bool isValid = true;
  bool isVisible = false;
  Color borderColor = Colors.grey.shade500;
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
    TextEditingController myController = widget.controller!;
    String? errorMessage =
        widget.validator != null ? widget.validator!(myController.text) : null;
    return Container(
      padding: widget.paddingValue,
      child: TextFormField(
        controller: myController,
        obscureText: isVisible,
        onTapOutside: (event) {
          // Focus.of(context).unfocus();
        },
        // The state is valid when the input text contains number 1 for testing purpose
        onChanged: (value) => setState(() {
          if (widget.validator != null &&
              widget.validator!(myController.text) != null) {
            errorMessage = widget.validator!(myController.text);
            isValid = false;
          } else {
            isValid = true;
          }
        }),
        focusNode: _focusNode,
        maxLength: widget.maxLength > 0 ? widget.maxLength : null,
        autocorrect: true,
        keyboardType: widget.keyboardType,
        enabled: widget.enabled,
        cursorColor: Colors.blue,
        decoration: InputDecoration(
          suffixIcon: widget.isPassword
              ? Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween, // added line
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isVisible = !isVisible;
                        });
                      },
                      icon: Icon(
                        isVisible ? Icons.visibility : Icons.visibility_off,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                    if (myController.text.isNotEmpty)
                      isValid
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
                    else
                      const SizedBox(),
                    const SizedBox(width: 10),
                  ],
                )
              : myController.text.isNotEmpty
                  ? isValid
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
              color: !isValid && myController.text.isNotEmpty
                  ? const Color.fromARGB(255, 243, 33, 47)
                  : Colors.blue,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: !isValid && myController.text.isNotEmpty
                  ? const Color.fromARGB(255, 243, 33, 47)
                  : const Color.fromARGB(255, 107, 125, 139),
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: !isValid && myController.text.isNotEmpty
                  ? const Color.fromARGB(255, 243, 33, 47)
                  : const Color.fromARGB(255, 107, 125, 139),
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          errorText: errorMessage,
          errorStyle: const TextStyle(
            color: Color.fromARGB(255, 243, 33, 47),
            fontSize: 13,
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: !isValid && myController.text.isNotEmpty
                  ? const Color.fromARGB(255, 243, 33, 47)
                  : const Color.fromARGB(255, 107, 125, 139),
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: !isValid && myController.text.isNotEmpty
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
            color: !isValid
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
          counterText: widget.maxLength > 0 ? null : '',
          counterStyle: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 13,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          filled: !widget.enabled,
          fillColor:
              !widget.enabled ? const Color.fromARGB(220, 18, 18, 18) : null,
        ),
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w300,
          color: _focusNode.hasFocus || myController.text.isNotEmpty
              ? Colors.white
              : const Color.fromARGB(255, 107, 125, 139),
        ),
        validator: widget.validator,
      ),
    );
  }
}
