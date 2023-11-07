import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/secondary_button.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/secondary_button_outlined.dart';
import 'package:qwitter_flutter_app/providers/next_bar_provider.dart';

class QwitterNextBar extends ConsumerWidget {
  const QwitterNextBar(
      {super.key,
      required this.buttonFunction,
      this.useProvider = false,
      this.buttonText = "Next",
      this.secondaryButtonText = "",
      this.secondaryButtonFunction});
  final VoidCallback? buttonFunction;
  final bool useProvider;
  final String buttonText;
  final String secondaryButtonText;
  final VoidCallback? secondaryButtonFunction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonFunctionProvider = ref.watch(nextBarProvider);
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
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        secondaryButtonText == ""
            ? const SizedBox(
                width: 1,
              )
            : Padding(
                padding: const EdgeInsets.only(left: 16),
                child: SecondaryButtonOutlined(
                    text: secondaryButtonText,
                    on_pressed: secondaryButtonFunction ?? () {}),
              ),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: SecondaryButton(
              text: buttonText,
              on_pressed: useProvider
                  ? buttonFunction == null
                      ? null
                      : () {
                          buttonFunctionProvider!(context);
                        }
                  : buttonFunction),
        ),
      ]),
    );
  }
}
