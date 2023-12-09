import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qwitter_flutter_app/providers/primary_button_provider.dart';

class PrimaryButton extends ConsumerWidget {
  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.useProvider = false,
    this.paddingValue = const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    this.buttonSize = const Size(30, 40),
  });

  final String text;
  final VoidCallback? onPressed;
  final bool useProvider;
  final EdgeInsets? paddingValue;
  final Size buttonSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonFunctionProvider = ref.watch(primaryButtonProvider);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor:
            const Color.fromARGB(255, 29, 155, 240), // Text color (black)
        foregroundColor: Colors.white,
        disabledForegroundColor: Colors.blue.withOpacity(0.38),
        disabledBackgroundColor:
            Colors.blue.withOpacity(0.12), // Background color (white)
        elevation: 0, // No shadow),
        padding: paddingValue, // Padding
        fixedSize: buttonSize,
        minimumSize: const Size(50, 30),
        maximumSize: const Size(150, 50),
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
        

      ),
    );
  }
}
