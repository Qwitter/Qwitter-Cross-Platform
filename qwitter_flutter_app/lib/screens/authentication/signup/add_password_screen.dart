import 'package:flutter/material.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/decorated_text_field.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_app_bar.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_next_bar.dart';

class AddPasswordScreen extends StatelessWidget {
  const AddPasswordScreen({super.key, this.email = 'omarmahmoud@gmail.com'});

  final String email;

  @override
  Widget build(BuildContext context) {
    final TextEditingController codeController = TextEditingController();
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(75),
        child: QwitterAppBar(),
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
              'You\'ll need a password',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 28,
                color: Color.fromARGB(255, 222, 222, 222),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Make sure it\'s 8 characters or more.',
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
                    keyboardType: TextInputType.visiblePassword,
                    placeholder: 'Password',
                    padding_value: const EdgeInsets.all(0),
                    controller: codeController,
                    isPassword: true,
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
      bottomNavigationBar: const QwitterNextBar(
        buttonFunction: null,
      ),
    );
  }
}
