import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:qwitter_flutter_app/components/basic_widgets/decorated_text_field.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/secondary_button.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_app_bar.dart';
import 'package:qwitter_flutter_app/providers/secondary_button_provider.dart';
import 'package:qwitter_flutter_app/providers/next_bar_provider.dart';
import 'package:qwitter_flutter_app/screens/authentication/login/forget_password_screen.dart';
import 'package:qwitter_flutter_app/screens/authentication/signup/signup_choose_method_screen.dart';
import 'package:qwitter_flutter_app/screens/tweets/tweets_feed_screen.dart';

class LoginMainScreen extends ConsumerStatefulWidget {
  const LoginMainScreen({super.key, required this.passedInput});
  final String passedInput;

  @override
  ConsumerState<LoginMainScreen> createState() => _LoginMainScreenState();
}

class _LoginMainScreenState extends ConsumerState<LoginMainScreen> {
  final TextEditingController passController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  Future<http.Response> login() async {
    final url =
        Uri.parse('http://qwitterback.cloudns.org:3000/api/v1/auth/login');

    // Define the data you want to send as a map
    final Map<String, String> data = {
      'email_or_username': widget.passedInput,
      'password': passController.text,
    };

    final response = await http.post(
      url,
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    return response;
  }

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

  @override
  Widget build(BuildContext context) {
    void Function(BuildContext)? buttonFunction;
    passController.addListener(() {
      if (passController.text.isNotEmpty) {
        buttonFunction = (context) {
          login().then((value) {
            if (value.statusCode == 200) {
              // navigate to feed
              // Fluttertoast.showToast(
              //   msg: "Into the feed",
              //   backgroundColor: Colors.green[200],
              // );
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx){
                return TweetFeedScreen();
              }));
            } else {
              Fluttertoast.showToast(
                msg: "Wrong password",
                backgroundColor: Colors.grey[700],
              );
            }
          }).onError((error, stackTrace) {
            Fluttertoast.showToast(
              msg: "Error in sending",
              backgroundColor: Colors.grey[700],
            );
          });
        };
        ref
            .read(secondaryButtonProvider.notifier)
            .setSecondaryButtonFunction(buttonFunction);
      } else {
        buttonFunction = null;
        ref
            .read(secondaryButtonProvider.notifier)
            .setSecondaryButtonFunction(buttonFunction);
      }
    });

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
              const Text(
                "Enter your password",
                style: TextStyle(
                  fontSize: 28,
                  color: Color.fromARGB(255, 222, 222, 222),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 30),
              DecoratedTextField(
                keyboardType: TextInputType.visiblePassword,
                placeholder: widget.passedInput,
                controller: emailController,
                enabled: false,
                paddingValue: const EdgeInsets.all(0),
              ),
              const SizedBox(height: 20),
              DecoratedTextField(
                keyboardType: TextInputType.visiblePassword,
                placeholder: "Password",
                controller: passController,
                isPassword: true,
                paddingValue: const EdgeInsets.all(0),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgetPasswordScreenEmail(),
                      ),
                    );
                  },
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
              buttonFunction = ref.watch(secondaryButtonProvider);
              return SecondaryButton(
                text: "Login",
                onPressed: buttonFunction == null
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignupChooseMethodScreen(),
                      ),
                    );
                  },
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
