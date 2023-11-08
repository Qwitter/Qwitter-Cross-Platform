import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/primary_button.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/underlined_text_field.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_back_app_bar.dart';
import 'package:qwitter_flutter_app/providers/primary_button_provider.dart';

class UpdatePasswordScreen extends ConsumerStatefulWidget {
  const UpdatePasswordScreen({super.key});

  @override
  ConsumerState<UpdatePasswordScreen> createState() =>
      _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends ConsumerState<UpdatePasswordScreen> {
  final TextEditingController currentPassController = TextEditingController();
  final TextEditingController firstNewPassController = TextEditingController();
  final TextEditingController secondNewPassController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    currentPassController.dispose();
    firstNewPassController.dispose();
    secondNewPassController.dispose();
  }

  @override
  void initState() {
    super.initState();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(primaryButtonProvider.notifier).setPrimaryButtonFunction(null);
    });
  }

  String? passwordValidations(String? password) {
    if (password == null || password.isEmpty) return null;

    if (password.length < 8) {
      return 'Password must be at least 8 characters long.';
    }

    if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).+$').hasMatch(password)) {
      return 'Password must contain at least one letter and one number.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    void Function(BuildContext)? buttonFunction;

    for (final controller in [
      currentPassController,
      firstNewPassController,
      secondNewPassController,
    ]) {
      controller.addListener(() {
        if (currentPassController.text.isNotEmpty &&
            firstNewPassController.text.isNotEmpty &&
            secondNewPassController.text.isNotEmpty) {
          if (passwordValidations(firstNewPassController.text) == null &&
              passwordValidations(secondNewPassController.text) == null &&
              firstNewPassController.text == secondNewPassController.text) {
            //! you should add function to check that the input password is the same as the current password
            buttonFunction = (context) {
              // navigate to next screen
            };
          } else {
            buttonFunction = (context) {
              String msg = "";

              if (firstNewPassController.text != secondNewPassController.text) {
                msg = "Passwords do not match";
              } else if (passwordValidations(firstNewPassController.text) !=
                  null) {
                msg = passwordValidations(firstNewPassController.text)!;
                if (passwordValidations(secondNewPassController.text) != null) {
                  msg = passwordValidations(secondNewPassController.text)!;
                }
              }
              Fluttertoast.showToast(
                msg: msg,
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: Colors.grey[700],
                textColor: Colors.white,
              );
            };
          }
          ref
              .read(primaryButtonProvider.notifier)
              .setPrimaryButtonFunction(buttonFunction);
        } else {
          buttonFunction = null;
          ref
              .read(primaryButtonProvider.notifier)
              .setPrimaryButtonFunction(buttonFunction);
        }
      });
    }

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(75),
        child: QwitterBackAppBar(
          title: "Update password",
          extraTitle: "@AlyMF",
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
          child: Column(
            children: [
              UnderlineTextField(
                keyboardType: TextInputType.emailAddress,
                placeholder: "",
                controller: currentPassController,
              ),
              UnderlineTextField(
                keyboardType: TextInputType.emailAddress,
                placeholder: "",
                controller: firstNewPassController,
              ),
              UnderlineTextField(
                keyboardType: TextInputType.emailAddress,
                placeholder: "",
                controller: secondNewPassController,
              ),
              Consumer(builder:
                  (BuildContext context, WidgetRef ref, Widget? child) {
                buttonFunction = ref.watch(primaryButtonProvider);
                return PrimaryButton(
                  text: "Update password",
                  useProvider: true,
                  on_pressed: buttonFunction == null
                      ? null
                      : () {
                          buttonFunction!(context);
                        },
                );
              }),
              TextButton(
                onPressed: () {},
                child: Text("Forgotten your password?",
                    style: TextStyle(
                      color: Colors.grey[500],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
