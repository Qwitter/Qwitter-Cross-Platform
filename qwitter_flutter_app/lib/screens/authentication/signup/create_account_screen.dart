import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/decorated_text_field.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_app_bar.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_next_bar.dart';
import 'package:qwitter_flutter_app/providers/next_bar_provider.dart';
import 'package:qwitter_flutter_app/screens/authentication/signup/confirmation_code_screen.dart';
import 'package:qwitter_flutter_app/screens/authentication/signup/suggested_follows_screen.dart';

class CreateAccountScreen extends ConsumerStatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  ConsumerState<CreateAccountScreen> createState() =>
      _CreateAccountScreenState();
}

class _CreateAccountScreenState extends ConsumerState<CreateAccountScreen> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController birthdayController = TextEditingController();
    void Function()? buttonFunction;

    for (final controller in [
      usernameController,
      emailController,
      birthdayController
    ]) {
      controller.addListener(() {
        if (usernameController.text.isNotEmpty &&
            emailController.text.isNotEmpty &&
            birthdayController.text.isNotEmpty) {
          buttonFunction = () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ConfirmationCodeScreen(),
              ),
            );
          };
          ref.read(nextBarProvider.notifier).setNextBarFunction(buttonFunction);
        } else {
          buttonFunction = null;
          ref.read(nextBarProvider.notifier).setNextBarFunction(buttonFunction);
        }
      });
    }

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
      bottomNavigationBar: QwitterNextBar(
        buttonFunction: buttonFunction,
        useProvider: true,
      ),
    );
  }
}
