import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/decorated_text_field.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/primary_button.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_back_app_bar.dart';

import 'package:qwitter_flutter_app/providers/primary_button_provider.dart';
import 'package:http/http.dart' as http;
import 'package:qwitter_flutter_app/screens/authentication/complements/forget_password_screen.dart';
import 'package:qwitter_flutter_app/screens/authentication/login/forget_new_password_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/app_user.dart';

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

  Future<http.Response> UpdatePassword() async {
    final url = Uri.parse(
        'http://back.qwitter.cloudns.org:3000/api/v1/auth/update-password');

    // Define the data you want to send as a map
    final Map<String, String> data = {
      "oldPassword": currentPassController.text,
      "newPassword": secondNewPassController.text
    };

    final Map<String, String> cookies = {
      'qwitter_jwt': 'Bearer ${AppUser().getToken}',
    };

    final response = await http.post(
      url,
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Cookie': cookies.entries
            .map((entry) => '${entry.key}=${entry.value}')
            .join('; '),
      },
    );

    // Successfully sent the data
    return response;
  }

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

  String? passwordEquality(String? password) {
    if (password == null || password.isEmpty) return null;

    if (password != firstNewPassController.text) {
      return 'Passwords do not match.';
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
            buttonFunction = (context) {
              UpdatePassword().then((value) {
                if (value.statusCode == 200) {
                  Fluttertoast.showToast(msg: "password changed successfully!");
                  AppUser().setPassword(secondNewPassController.text);
                  AppUser().saveUserData();
                } else {
                  Fluttertoast.showToast(
                      msg: json.decode(value.body)['message']);
                }
              }).onError((error, stackTrace) {
                Fluttertoast.showToast(msg: "error in sending");
              });
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
        child: QwitterTitleAppBar(
          title: "Update password",
          extraTitle: "@AlyMF",
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),
                DecoratedTextField(
                  keyboardType: TextInputType.emailAddress,
                  placeholder: "Current password",
                  controller: currentPassController,
                  validator: passwordValidations,
                ),
                const SizedBox(height: 30),
                DecoratedTextField(
                  keyboardType: TextInputType.emailAddress,
                  placeholder: "At least 8 characters",
                  controller: firstNewPassController,
                  validator: passwordValidations,
                ),
                const SizedBox(height: 25),
                DecoratedTextField(
                  keyboardType: TextInputType.emailAddress,
                  placeholder: "At least 8 characters",
                  controller: secondNewPassController,
                  validator: passwordEquality,
                ),
                const SizedBox(height: 25),
                Consumer(builder:
                    (BuildContext context, WidgetRef ref, Widget? child) {
                  buttonFunction = ref.watch(primaryButtonProvider);
                  return PrimaryButton(
                    text: "Update password",
                    useProvider: true,
                    paddingValue:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 35),
                    buttonSize: const Size(double.infinity, 50),
                    onPressed: buttonFunction == null
                        ? null
                        : () {
                            buttonFunction!(context);
                          },
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
