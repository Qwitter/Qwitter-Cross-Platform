import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/decorated_text_field.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_app_bar.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_next_bar.dart';
import 'package:qwitter_flutter_app/providers/next_bar_provider.dart';
import 'package:qwitter_flutter_app/screens/authentication/login/forget_password_screen.dart';
import 'package:qwitter_flutter_app/screens/authentication/login/login_main_screen.dart';
import 'package:http/http.dart' as http;

class LoginEmailScreen extends ConsumerStatefulWidget {
  const LoginEmailScreen({super.key});

  @override
  ConsumerState<LoginEmailScreen> createState() => _LoginEmailScreenState();
}

class _LoginEmailScreenState extends ConsumerState<LoginEmailScreen> {
  final TextEditingController emailController = TextEditingController();

  // 192.168.1.106
  Future<http.Response> sendEmail() async {
    final url = Uri.parse(
        'http://qwitterback.cloudns.org:3000/api/v1/auth/check-existence');

    // Define the data you want to send as a map
    final Map<String, String> data = {
      'userNameOrEmail': emailController.text,
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
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void Function(BuildContext)? buttonFunction;

    emailController.addListener(() {
      if (emailController.text.isNotEmpty) {
        buttonFunction = (context) {
          sendEmail().then((value) {
            if (value.statusCode == 404) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginMainScreen(
                    passedInput: emailController.text,
                  ),
                ),
              );
            } else {
              Fluttertoast.showToast(
                msg: "Email not found",
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
        ref.read(nextBarProvider.notifier).setNextBarFunction(buttonFunction);
      } else {
        buttonFunction = null;
        ref.read(nextBarProvider.notifier).setNextBarFunction(buttonFunction);
      }
    });

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(75),
        child: QwitterAppBar(
          showLogoOnly: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
          child: Column(
            children: [
              const Text(
                "To get started,first enter your phone, email address or @username",
                style: TextStyle(
                  fontSize: 28,
                  color: Color.fromARGB(255, 222, 222, 222),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              DecoratedTextField(
                keyboardType: TextInputType.emailAddress,
                placeholder: "Phone,email address or username",
                controller: emailController,
                padding_value: const EdgeInsets.all(0),
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
          secondaryButtonText: "Fogot password?",
          secondaryButtonFunction: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ForgetPasswordScreenEmail()));
          },
        );
      }),
    );
  }
}
