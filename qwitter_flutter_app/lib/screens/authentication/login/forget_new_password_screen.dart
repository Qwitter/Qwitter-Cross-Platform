import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/decorated_text_field.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/secondary_button.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_app_bar.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_next_bar.dart';
import 'package:qwitter_flutter_app/providers/next_bar_provider.dart';

class ForgetNewPasswordScreen extends ConsumerStatefulWidget {
  const ForgetNewPasswordScreen({super.key});

  @override
  ConsumerState<ForgetNewPasswordScreen> createState() =>
      _ForgetNewPasswordScreenState();
}

class _ForgetNewPasswordScreenState
    extends ConsumerState<ForgetNewPasswordScreen> {
  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    passController.dispose();
    confirmPassController.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(nextBarProvider.notifier).setNextBarFunction(null);
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
      passController,
      confirmPassController,
    ]) {
      controller.addListener(() {
        if (passController.text.isNotEmpty &&
            confirmPassController.text.isNotEmpty) {
          if (passwordValidations(passController.text) == null &&
              passwordValidations(confirmPassController.text) == null &&
              passController.text == confirmPassController.text) {
            buttonFunction = (context) {
              // navigate to next screen
            };
          } else {
            buttonFunction = (context) {
              String msg = "";

              if (passController.text != confirmPassController.text) {
                msg = "Passwords do not match";
              } else if (passwordValidations(passController.text) != null) {
                msg = passwordValidations(passController.text)!;
                if (passwordValidations(confirmPassController.text) != null) {
                  msg = passwordValidations(confirmPassController.text)!;
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
          ref.read(nextBarProvider.notifier).setNextBarFunction(buttonFunction);
        } else {
          buttonFunction = null;
          ref.read(nextBarProvider.notifier).setNextBarFunction(buttonFunction);
        }
      });
    }

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(75),
        child: QwitterAppBar(showLogoOnly: true),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Text(
                  "Choose a new password",
                  style: TextStyle(
                    fontSize: 28,
                    color: Color.fromARGB(255, 222, 222, 222),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // const Expanded(
              //   child: Text(
              //     "Make sure your new password is 8 characters or more. Try including numbers, letters, and punctuation marks for a ",
              //     style: TextStyle(color: Colors.grey, fontSize: 14),
              //   ),
              // ),
              // TextButton(
              //     onPressed: () {}, child: const Text("strong password")),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                            'Make sure your new password is 8 characters or more. Try including numbers, letters, and punctuation marks for a ',
                        style: TextStyle(color: Colors.grey[700], fontSize: 14),
                      ),
                      WidgetSpan(
                        child: InkWell(
                          onTap: () {
                            // Handle the click action for "strong password" here.
                            print('Strong password clicked');
                          },
                          child: const Text(
                            'strong password',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Text(
                  "You'll be logged out of all active X sessions after your password is changed.",
                  style: TextStyle(color: Colors.grey[700], fontSize: 14),
                ),
              ),

              const SizedBox(height: 30),
              DecoratedTextField(
                keyboardType: TextInputType.visiblePassword,
                placeholder: "Enter a new password",
                controller: passController,
                isPassword: true,
              ),
              const SizedBox(height: 20),
              DecoratedTextField(
                keyboardType: TextInputType.visiblePassword,
                placeholder: "Confirm your password",
                controller: confirmPassController,
                isPassword: true,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
        buttonFunction = ref.watch(nextBarProvider);
        return QwitterNextBar(
          buttonFunction: buttonFunction == null
              ? null
              : () {
                  buttonFunction!(context);
                },
          useProvider: true,
        );
      }),
    );
  }
}
