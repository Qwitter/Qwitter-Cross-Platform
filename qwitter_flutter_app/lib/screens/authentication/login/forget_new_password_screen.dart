import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/decorated_text_field.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/secondary_button.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_app_bar.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_next_bar.dart';

class ForgetNewPasswordScreen extends StatefulWidget {
  const ForgetNewPasswordScreen({super.key});

  @override
  State<ForgetNewPasswordScreen> createState() =>
      _ForgetNewPasswordScreenState();
}

class _ForgetNewPasswordScreenState extends State<ForgetNewPasswordScreen> {
  final emailController = TextEditingController();
  late TextEditingController passController;
  late TextEditingController confirmPassController;

  bool isActive = false;
  void hello() {
    setState(() {
      isActive = false;
    });
    passController.clear();
    confirmPassController.clear();
  }

  @override
  void dispose() {
    super.dispose();
    passController.dispose();
    confirmPassController.dispose();
  }

  void check() {
    setState(() {
      isActive = passController.text.isNotEmpty &&
          confirmPassController.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    passController = TextEditingController();
    confirmPassController = TextEditingController();
    passController.addListener(() {
      check();
    });
    confirmPassController.addListener(() {
      check();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 14),
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
        bottomNavigationBar: QwitterNextBar(
            buttonText: "Change password",
            buttonFunction: isActive == true ? hello : null));
  }
}
