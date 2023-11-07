import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/decorated_text_field.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/secondary_button.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_app_bar.dart';
import 'package:qwitter_flutter_app/providers/login_button_provider.dart';
import 'package:qwitter_flutter_app/providers/next_bar_provider.dart';

class LoginMainScreen extends ConsumerStatefulWidget {
  const LoginMainScreen({super.key, required this.passedInput});
  final String passedInput;

  @override
  ConsumerState<LoginMainScreen> createState() => _LoginMainScreenState();
}

class _LoginMainScreenState extends ConsumerState<LoginMainScreen> {
  final TextEditingController passController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(nextBarProvider.notifier).setNextBarFunction(null);
    });
  }

  @override
  void dispose() {
    super.dispose();
    passController.dispose();
  }

  String? inputValidation(String? email) {
    if (email == null || email.isEmpty) return null;
    // email validation api call
    if (email == "13245678") {
      return 'email right.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    void Function(BuildContext)? buttonFunction;

    passController.addListener(() {
      if (passController.text.isNotEmpty) {
        buttonFunction = (context) {
          if (inputValidation(passController.text) != null) {
            // go to the feed screen
          } else {
            // show toast image with error
            Fluttertoast.showToast(
              msg: "Password is wrong",
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: Colors.grey[700],
              textColor: Colors.white,
            );
          }
        };
        ref
            .read(loginButtonProvider.notifier)
            .setLoginButtonFunction(buttonFunction);
      } else {
        buttonFunction = null;
        ref
            .read(loginButtonProvider.notifier)
            .setLoginButtonFunction(buttonFunction);
      }
    });

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(75),
        child: QwitterAppBar(isButton: true),
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
                  "Enter your password",
                  style: TextStyle(
                    fontSize: 28,
                    color: Color.fromARGB(255, 222, 222, 222),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              DecoratedTextField(
                keyboardType: TextInputType.visiblePassword,
                placeholder: widget.passedInput,
                controller: emailController,
                enabled: false,
              ),
              const SizedBox(height: 20),
              DecoratedTextField(
                keyboardType: TextInputType.visiblePassword,
                placeholder: "Password",
                controller: passController,
                isPassword: true,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Forgot password?",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
            width: double.infinity,
            child: Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
              buttonFunction = ref.watch(loginButtonProvider);
              return SecondaryButton(
                text: "Login",
                on_pressed: buttonFunction == null
                    ? null
                    : () {
                        buttonFunction!(context);
                      },
                useProvider: true,
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
            child: Row(
              children: [
                const Text(
                  "Don't have an account",
                  style: TextStyle(color: Colors.grey),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Sign up",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
