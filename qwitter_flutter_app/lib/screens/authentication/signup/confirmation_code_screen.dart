import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/decorated_text_field.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_app_bar.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_next_bar.dart';
import 'package:qwitter_flutter_app/models/user.dart';
import 'package:qwitter_flutter_app/providers/next_bar_provider.dart';
import 'package:qwitter_flutter_app/screens/authentication/login/forget_new_password_screen.dart';
import 'package:qwitter_flutter_app/screens/authentication/signup/add_password_screen.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class ConfirmationCodeScreen extends ConsumerStatefulWidget {
  const ConfirmationCodeScreen({super.key, this.user});

  final User? user;

  @override
  ConsumerState<ConfirmationCodeScreen> createState() =>
      _ConfirmationCodeScreenState();
}

class _ConfirmationCodeScreenState
    extends ConsumerState<ConfirmationCodeScreen> {
  final TextEditingController codeController = TextEditingController();

  Future<String> sendVerificationEmail() async {
    final url = Uri.parse(
        'http://qwitterback.cloudns.org:3000/api/v1/auth/send-verification-email');

    // Define the data you want to send as a map
    final Map<String, String> data = {
      'email': widget.user!.email!,
    };

    final response = await http.post(
      url,
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // Successfully sent the data
    final responseBody = json.decode(response.body);
    return responseBody['message'];
  }

  Future verifyEmail() async {
    final url = Uri.parse(
        'http://qwitterback.cloudns.org:3000/api/v1/auth/verify-email/${codeController.text}');

    // Define the data you want to send as a map
    final Map<String, String> data = {
      'email': widget.user!.email!,
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

  String? codeValidations(String? code) {
    if (code == null || code.isEmpty) return null;

    if (code.length != 6) {
      return 'Invalid confirmation code.';
    }

    return null;
  }

  @override
  void initState() {
    super.initState();
    sendVerificationEmail();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(nextBarProvider.notifier).setNextBarFunction(null);
    });
  }

  @override
  void dispose() {
    super.dispose();
    codeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void Function(BuildContext)? buttonFunction;

    codeController.addListener(() {
      if (codeController.text.isNotEmpty &&
          codeValidations(codeController.text) == null) {
        buttonFunction = (context) {
          verifyEmail().then((value) {
            Toast.show(json.decode(value.body)['message']);
            if (value.statusCode == 200) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddPasswordScreen(
                    user: widget.user,
                  ),
                ),
              );
            } else {
              buttonFunction = null;
            }
          }).onError((error, stackTrace) {
            Toast.show('Error sending data $error');
            print('Error sending data $error');
            buttonFunction = null;
          });
        };
        ref.read(nextBarProvider.notifier).setNextBarFunction(buttonFunction);
      } else {
        buttonFunction = null;
        ref.read(nextBarProvider.notifier).setNextBarFunction(buttonFunction);
      }
    });
    return WillPopScope(
      onWillPop: () {
        buttonFunction = (context) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ConfirmationCodeScreen(
                user: widget.user,
              ),
            ),
          );
        };
        ref.read(nextBarProvider.notifier).setNextBarFunction(buttonFunction);
        return Future.value(true);
      },
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(75),
          child: QwitterAppBar(
            showLogoOnly: true,
          ),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                'We sent you a code',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 28,
                  color: Color.fromARGB(255, 222, 222, 222),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Enter it below to verify ${widget.user!.getEmail}.',
                textAlign: TextAlign.start,
                style: const TextStyle(
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
                      placeholder: 'Verification code',
                      padding_value: const EdgeInsets.all(0),
                      controller: codeController,
                      max_length: 6,
                      validator: codeValidations,
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            _showOverlay(context);
                          },
                          child: const Text(
                            'Didn\'t receive an email?',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ]),
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
      ),
    );
  }

  void _showOverlay(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.fromLTRB(18, 15, 25, 2),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 38, 38, 38),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            height: 170,
            width: 300,
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                        child: Text(
                          "Didn't receive an email?",
                          style: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 222, 222, 222),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          // Add your action here for the first option.
                          sendVerificationEmail();
                          Navigator.of(context).pop(); // Close the overlay
                        },
                        style: ButtonStyle(
                          textStyle: MaterialStateProperty.all<TextStyle>(
                            const TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 222, 222, 222),
                              fontWeight: FontWeight.w400,
                            ), // Set an empty TextStyle
                          ),
                          foregroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 222, 222, 222),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Colors
                                .transparent, // Set transparent background color
                          ),
                        ),
                        child: const Text(
                          "Resend Email",
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Add your action here for the second option.
                          Navigator.of(context).pop(); // Close the overlay
                        },
                        style: ButtonStyle(
                          textStyle: MaterialStateProperty.all<TextStyle>(
                            const TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 222, 222, 222),
                              fontWeight: FontWeight.w400,
                            ), // Set an empty TextStyle
                          ),
                          foregroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 222, 222, 222),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Colors
                                .transparent, // Set transparent background color
                          ),
                        ),
                        child: const Text(
                          "Use phone instead",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 222, 222, 222),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ]),
          ),
        );
      },
    );
  }
}
