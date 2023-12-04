import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qwitter_flutter_app/providers/secondary_button_provider.dart';

class SecondaryButton extends ConsumerWidget {
  const SecondaryButton(
      {super.key,
      required this.text,
      this.useProvider = false,
      required this.onPressed,
      this.paddingValue =
          const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      this.textStyle = const TextStyle(
        fontSize: 14,
      )});

  final String text;
  final VoidCallback? onPressed;
  final EdgeInsets? paddingValue;
  final TextStyle? textStyle;
  final bool useProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonFunctionProvider = ref.watch(secondaryButtonProvider);
    return ButtonTheme(
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white, // Background color (white)
          foregroundColor: Colors.black,
          disabledForegroundColor: Colors.grey.withOpacity(0.38),
          disabledBackgroundColor:
              Colors.grey.withOpacity(0.12), // Text color (black)
          elevation: 0, // No shadow
          padding: paddingValue, // Padding
          minimumSize: const Size(30, 30),
          maximumSize: const Size(170, 35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24), // Custom shape
          ),
        ),
        onPressed: useProvider
            ? onPressed == null
                ? null
                : () {
                    buttonFunctionProvider!(context);
                  }
            : onPressed,
        child: Text(
          text,
          style: textStyle,
        ),
      ),
    );
  }
}
