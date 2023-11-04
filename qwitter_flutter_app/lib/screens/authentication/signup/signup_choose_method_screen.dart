// import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/primary_button.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/custom_icon_button.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/secondary_button_outlined.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_app_bar.dart';
import 'package:qwitter_flutter_app/screens/authentication/signup/select_languages_screen.dart';

class SignupChooseMethodScreen extends StatefulWidget {
  const SignupChooseMethodScreen({super.key});

  @override
  State<SignupChooseMethodScreen> createState() =>
      _SignupChooseMethodScreenState();
}

//the text not matching the button size is caused by decorated text widget

class _SignupChooseMethodScreenState extends State<SignupChooseMethodScreen> {
  final String googleImagePath = 'assets/images/google.png';
  final String appleImagePath = 'assets/images/apple.png';

  final emailController = TextEditingController();
  late TextEditingController passController;

  bool isActive = false;
  void hello() {
    setState(() {
      isActive = false;
    });
    passController.clear();
  }

  void forgotPassword() {}

  void signupApple() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const SelectLanguagesScreen()),
    );
  }

  void signupGoogle() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const SelectLanguagesScreen()),
    );
  }

  void createAccont() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const SelectLanguagesScreen()),
    );
  }

  void signIn() {}

  @override
  void dispose() {
    super.dispose();
    passController.dispose();
  }

  @override
  void initState() {
    super.initState();
    passController = TextEditingController();
    passController.addListener(() {
      setState(() {
        isActive = passController.text.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: 500,
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
                child: Image.network(
                    'https://freelogopng.com/images/all_img/1690643777twitter-x%20logo-png-white.png',
                    width: 24,
                    height: 24),
              ),
              SizedBox(
                height: 50,
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Text(
                  "Happening now ",
                  style: TextStyle(
                    fontSize: 45,
                    color: Color.fromARGB(255, 222, 222, 222),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(15, 30, 0, 0),
                child: Text(
                  "Join today.",
                  style: TextStyle(
                    fontSize: 28,
                    color: Color.fromARGB(255, 222, 222, 222),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(15, 20, 0, 0),
                width: double.infinity,
                height: 60,
                child: CustomIconButton(
                  text: "Sign up with Google",
                  onPressed: signupGoogle,
                  image: googleImagePath,
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(15, 20, 0, 0),
                width: double.infinity,
                height: 60,
                child: CustomIconButton(
                  text: "Sign up with Apple",
                  onPressed: signupGoogle,
                  image: appleImagePath,
                ),
              ),
              const SizedBox(height: 15),
              const Divider(
                color: Color.fromARGB(255, 107, 125, 139),
                thickness: 1,
                indent: 20,
                endIndent: 5,
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                width: double.infinity,
                child: PrimaryButton(
                  text: "Create account",
                  on_pressed: createAccont,
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(15, 80, 0, 0),
                child: Text(
                  "Already have an account?",
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 222, 222, 222),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                width: double.infinity,
                child: SecondaryButtonOutlined(
                  text: "Sign in",
                  on_pressed: signIn,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
