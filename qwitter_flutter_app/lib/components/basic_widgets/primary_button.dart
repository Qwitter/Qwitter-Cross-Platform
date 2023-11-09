import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qwitter_flutter_app/providers/primary_button_provider.dart';

class PrimaryButton extends ConsumerWidget {
  const PrimaryButton({
    super.key,
    required this.text,
    this.on_pressed,
    this.useProvider = false,
  });

  final String text;
  final VoidCallback? on_pressed;
  final bool useProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonFunctionProvider = ref.watch(primaryButtonProvider);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor:
            const Color.fromARGB(255, 29, 155, 240), // Text color (black)
        foregroundColor: Colors.white,
        onSurface: Colors.blue, // Background color (white)
        elevation: 0, // No shadow
        padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24), // Custom shape
        ),
      ),
      onPressed: useProvider
          ? on_pressed == null
              ? null
              : () {
                  buttonFunctionProvider!(context);
                }
          : on_pressed,
      child: Text(text),
    );
  }
}
