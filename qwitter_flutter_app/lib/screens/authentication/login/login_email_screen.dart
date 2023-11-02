import 'package:flutter/material.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/decorated_text_field.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_app_bar.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_next_bar.dart';

class LoginEmailScreen extends StatefulWidget {
  const LoginEmailScreen({super.key});

  @override
  State<LoginEmailScreen> createState() => _LoginEmailScreenState();
}

class _LoginEmailScreenState extends State<LoginEmailScreen> {
  late TextEditingController emailController;

  bool isActive = false;
  void hello() {
    setState(() {
      isActive = false;
    });
    emailController.clear();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    emailController.addListener(() {
      setState(() {
        isActive = emailController.text.isNotEmpty;
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
                placeholder: "email",
                controller: emailController,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar:
          QwitterNextBar(buttonFunction: isActive == true ? hello : null),
    );
  }
}
