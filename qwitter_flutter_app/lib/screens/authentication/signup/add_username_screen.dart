import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/decorated_text_field.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_app_bar.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_next_bar.dart';
import 'package:qwitter_flutter_app/providers/next_bar_provider.dart';
import 'package:qwitter_flutter_app/screens/authentication/signup/suggested_follows_screen.dart';

class AddUsernameScreen extends ConsumerWidget {
  const AddUsernameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void Function()? buttonFunction;
    final TextEditingController usernameController = TextEditingController();

    usernameController.addListener(() {
      if (usernameController.text.isNotEmpty) {
        buttonFunction = () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SuggestedFollowsScreen(),
            ),
          );
        };
        ref.read(nextBarProvider.notifier).setNextBarFunction(buttonFunction);
      } else {
        buttonFunction = null;
        ref.read(nextBarProvider.notifier).setNextBarFunction(buttonFunction);
      }
    });
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
              'What should we call you?',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 28,
                color: Color.fromARGB(255, 222, 222, 222),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Your @username is your unique identifier on X. You can always change it later.',
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
                    keyboardType: TextInputType.name,
                    placeholder: 'Username',
                    padding_value: const EdgeInsets.all(0),
                    controller: usernameController,
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
