import 'package:flutter/material.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/decorated_text_field.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_app_bar.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_next_bar.dart';

class ChangeEmailScreen extends StatelessWidget {
  const ChangeEmailScreen({super.key, this.email = 'omarmahmoud@gmail.com'});

  final String email;

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(75),
        child: QwitterAppBar(),
      ),
      body: Container(
        width: double.infinity,
        color: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text(
            'Change email',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 28,
              color: Color.fromARGB(255, 222, 222, 222),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Your current email address is $email. what would you like to update it to? Your email address is not displayed on your public profile on X.',
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
                  keyboardType: TextInputType.emailAddress,
                  placeholder: 'Email address',
                  padding_value: const EdgeInsets.all(0),
                  controller: emailController,
                ),
              ],
            ),
          ),
        ]),
      ),
      bottomNavigationBar: const QwitterNextBar(
        buttonFunction: null,
      ),
    );
  }
}
