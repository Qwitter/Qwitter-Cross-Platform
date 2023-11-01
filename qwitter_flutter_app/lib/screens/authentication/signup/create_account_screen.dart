import 'package:flutter/material.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/decorated_text_field.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_app_bar.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_next_bar.dart';

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController birthdayController = TextEditingController();
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(75),
        child: QwitterAppBar(),
      ),
      body: Container(
        width: double.infinity,
        color: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(children: [
            const Text(
              'Create your account',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                color: Color.fromARGB(255, 222, 222, 222),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 112),
            Form(
              child: Column(
                children: [
                  DecoratedTextField(
                    keyboardType: TextInputType.name,
                    placeholder: 'Name',
                    max_length: 50,
                    controller: usernameController,
                  ),
                  DecoratedTextField(
                    keyboardType: TextInputType.emailAddress,
                    placeholder: 'Email',
                    controller: emailController,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18),
                    child: DecoratedTextField(
                      keyboardType: TextInputType.name,
                      placeholder: 'Date of birth',
                      controller: birthdayController,
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
      bottomNavigationBar: const QwitterNextBar(buttonFunction: null),
    );
  }
}
