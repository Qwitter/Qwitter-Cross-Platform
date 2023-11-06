import 'package:flutter/material.dart';

import 'package:qwitter_flutter_app/components/basic_widgets/decorated_text_field.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/custom_icon_button.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/secondary_button.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/secondary_button_outlined.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_app_bar.dart';

class LoginChooseScreen extends StatefulWidget {
  const LoginChooseScreen({super.key});

  @override
  State<LoginChooseScreen> createState() => _LoginChooseScreenState();
}

//the text not matching the button size is caused by decorated text widget  

class _LoginChooseScreenState extends State<LoginChooseScreen> {
  
  final String googleImagePath='assets/images/google.png';
  final String appleImagePath='assets/images/apple.png';

  final emailController = TextEditingController();
  late TextEditingController passController;

  bool isActive = false;
  void hello() {
    setState(() {
      isActive = false;
    });
    passController.clear();
  }

  void ForgotPassword() {}

  void SignInApple() {}

  void SignInGoogle(){}
  
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
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(75),
        child: QwitterAppBar(),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: 500,
          padding: const EdgeInsets.symmetric(vertical: 90, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Text(
                  "Sign in to X",
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
                  text: "Sign in with Google",
                  onPressed: SignInGoogle,
                  image: googleImagePath,
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(15, 20, 0, 0),
                width: double.infinity,
                height: 60,
                child: CustomIconButton(
                  text: "Sign in with Apple",
                  onPressed: SignInGoogle,
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
                width: double.infinity,
                child: DecoratedTextField(
                  keyboardType: TextInputType.text,
                  placeholder: "Phone, email or username",
                  controller: passController,
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                width: double.infinity,
                child: SecondaryButton(
                  text: "Next",
                  on_pressed: isActive == true ? hello : null,
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                width: double.infinity,
                child: SecondaryButtonOutlined(
                  text: "Forgot password ?",
                  on_pressed: ForgotPassword,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 20, 0, 0), 
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
        ),
      ),
    );
  }
}
