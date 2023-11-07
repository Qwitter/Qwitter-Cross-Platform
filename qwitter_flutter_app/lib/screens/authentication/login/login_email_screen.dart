import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/decorated_text_field.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_app_bar.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_next_bar.dart';
import 'package:qwitter_flutter_app/providers/next_bar_provider.dart';
import 'package:qwitter_flutter_app/screens/authentication/login/login_main_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginEmailScreen extends ConsumerStatefulWidget {
  const LoginEmailScreen({super.key});

  @override
  ConsumerState<LoginEmailScreen> createState() => _LoginEmailScreenState();
}

class _LoginEmailScreenState extends ConsumerState<LoginEmailScreen> {
  final TextEditingController emailController = TextEditingController();
  String? inputValidation(String? email) {
    if (email == null || email.isEmpty) return null;
    // email validation api call
    if (email == "aly.mf.2001@gmail.com") {
      return 'email right.';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(nextBarProvider.notifier).setNextBarFunction(null);
    });
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void Function(BuildContext)? buttonFunction;

    emailController.addListener(() {
      if (emailController.text.isNotEmpty) {
        buttonFunction = (context) {
          if (inputValidation(emailController.text) != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    LoginMainScreen(passedInput: emailController.text),
              ),
            );
          } else {
            // show toast image with error
            Fluttertoast.showToast(
              msg: "Email is not found",
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: Colors.grey[700],
              textColor: Colors.white,
            );
          }
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
        child: QwitterAppBar(isButton: true),
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
      bottomNavigationBar: Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
        buttonFunction = ref.watch(nextBarProvider);
        return QwitterNextBar(
          buttonFunction: buttonFunction == null
              ? null
              : () {
                  buttonFunction!(context);
                },
          useProvider: true,
          secondaryButtonText: "Fogot password?",
          secondaryButtonFunction: (){
            
          },
        );
      }),
    );
  }
}
