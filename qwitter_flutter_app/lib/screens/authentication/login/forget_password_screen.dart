import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:qwitter_flutter_app/components/basic_widgets/decorated_text_field.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_app_bar.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_next_bar.dart';
import 'package:qwitter_flutter_app/models/user.dart';
import 'package:qwitter_flutter_app/providers/next_bar_provider.dart';
import 'package:qwitter_flutter_app/screens/authentication/signup/confirmation_code_screen.dart';

class ForgetPasswordScreenEmail extends ConsumerStatefulWidget {
  const ForgetPasswordScreenEmail({super.key});

  @override
  ConsumerState<ForgetPasswordScreenEmail> createState() =>
      _ForgetPasswordScreen();
}

class _ForgetPasswordScreen extends ConsumerState<ForgetPasswordScreenEmail> {
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(nextBarProvider.notifier).setNextBarFunction(null);
    });
  }

  Future<http.Response> sendEmail() async {
    final url = Uri.parse(
        'http://qwitter.cloudns.org:3000/api/v1/auth/forgot-password');

    // Define the data you want to send as a map
    final Map<String, String> data = {
      'email': emailController.text,
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
            if (value.statusCode == 200) {
              final User u = User(email: emailController.text);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConfirmationCodeScreen(
                    user: u,
                    code: ConfirmationCodeType.password,
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
        child: QwitterAppBar(showLogoOnly: true),
      ),
      body: Container(
        width: double.infinity,
        color: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text(
            'Find your X account',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 28,
              color: Color.fromARGB(255, 222, 222, 222),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Enter the email, phone number, or username associated with your account to change your password.',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 15,
              color: Color.fromARGB(255, 132, 132, 132),
            ),
          ),
          const SizedBox(height: 15),
          Form(
            child: Column(
              children: [
                DecoratedTextField(
                  keyboardType: TextInputType.name,
                  placeholder: 'Email address, phone number, or username',
                  paddingValue: const EdgeInsets.all(0),
                  controller: emailController,
                ),
              ],
            ),
          ),
        ]),
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
