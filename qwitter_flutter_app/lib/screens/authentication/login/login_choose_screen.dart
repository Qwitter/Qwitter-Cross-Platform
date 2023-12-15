import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'package:qwitter_flutter_app/api/google_signin_api.dart';

import 'package:qwitter_flutter_app/components/basic_widgets/decorated_text_field.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/custom_icon_button.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/secondary_button.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/secondary_button_outlined.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_app_bar.dart';
import 'package:qwitter_flutter_app/models/user.dart';
import 'package:qwitter_flutter_app/screens/authentication/login/login_main_screen.dart';
import 'package:qwitter_flutter_app/screens/authentication/signup/add_birthdate_screen.dart';
import 'package:qwitter_flutter_app/screens/authentication/signup/suggested_follows_screen.dart';
import 'package:toast/toast.dart' as toast;
import 'package:fluttertoast/fluttertoast.dart' as flutter_toast;

class LoginChooseScreen extends StatefulWidget {
  const LoginChooseScreen({super.key});

  @override
  State<LoginChooseScreen> createState() => _LoginChooseScreenState();
}

//the text not matching the button size is caused by decorated text widget

class _LoginChooseScreenState extends State<LoginChooseScreen> {
  final String googleImagePath = 'assets/images/google.png';
  final String appleImagePath = 'assets/images/apple.png';
  void Function()? buttonFunction;
  User user = User();
  final emailController = TextEditingController();

  Future<String> readTextFromFile(String fileName) async {
    try {
      // Use rootBundle to load the file from the assets
      String contents = await rootBundle.loadString('assets/$fileName');
      return contents;
    } catch (e) {
      //print('Error reading file: $e');
      return '';
    }
  }

  Future<http.Response> checkEmailAvailability() async {
    final url = Uri.parse(
        'http://qwitter.cloudns.org:3000/api/v1/auth/check-existence');

    // Define the data you want to send as a map
    //print('Email: ${user.email}');
    final Map<String, String> data = {
      'userNameOrEmail': user.email!,
    };

    final response = await http.post(
      url,
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // Successfully sent the data
    return response;
  }

  Future<http.Response> googleSignIn() async {
    final url =
        Uri.parse('http://qwitter.cloudns.org:3000/api/v1/auth/google/login');

    String token;

    String private = await readTextFromFile('private.txt');
    // Create the json web token
    final jwt = JWT(
      {
        'google_id': user.id,
        'name': user.fullName,
        'email': user.email,
      },
    );
    // Sign it
    token = jwt.sign(SecretKey(private));

    //print('Signed token: $token\n');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'authorization': 'Bearer $token',
      },
    );

    // Successfully sent the data
    return response;
  }

  Future signInGoogle() async {
    final authUser = await GoogleSignInApi.login();
    if (authUser == null) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sign in failed'),
        ),
      );
    } else {
      final gid = authUser.id;
      final username = authUser.displayName;
      final email = authUser.email;
      user = User().setFullName(username).setEmail(email).setId(gid);
      // ignore: use_build_context_synchronously
      checkEmailAvailability().then((value) {
        //print('Response: ${value.statusCode}');
        if (value.statusCode == 200) {
          //print('email not found go add birthdate');
          // ignore: use_build_context_synchronously
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => AddBirthdateScreen(user: user)),
          );
        } else {
          // New token should be recieved here
          //print('email found go to suggested follows');
          googleSignIn().then((value) {
            if (value.statusCode == 200) {
              // ignore: use_build_context_synchronously
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const SuggestedFollowsScreen()),
              );
            }
          });
        }
      });
    }
  }

  Future<http.Response> sendEmail() async {
    final url = Uri.parse(
        'http://qwitter.cloudns.org:3000/api/v1/auth/check-existence');

    // Define the data you want to send as a map
    final Map<String, String> data = {
      'userNameOrEmail': emailController.text,
    };

    final response = await http.post(
      url,
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    return response;
  }

  bool isActive = false;
  void hello() {
    setState(() {
      isActive = false;
    });
    emailController.clear();
  }

  void forgotPassword() {}

  void signInApple() {}

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  @override
  void initState() {
    super.initState();
    toast.ToastContext ctx = toast.ToastContext();
    ctx.init(context);
    emailController.addListener(() {
      setState(() {
        isActive = emailController.text.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    emailController.addListener(() {
      if (emailController.text.isNotEmpty) {
        buttonFunction = () {
          sendEmail().then((value) {
            if (value.statusCode == 404) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginMainScreen(
                    passedInput: emailController.text,
                  ),
                ),
              );
            } else {
              flutter_toast.Fluttertoast.showToast(
                msg: "Email not found",
                backgroundColor: Colors.grey[700],
              );
            }
          }).onError((error, stackTrace) {
            flutter_toast.Fluttertoast.showToast(
              msg: "Error in sending",
              backgroundColor: Colors.grey[700],
            );
          });
        };
      }
    });

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(75),
        child: QwitterAppBar(
          showLogoOnly: true,
          autoImplyLeading: false,
        ),
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
                  onPressed: signInGoogle,
                  image: googleImagePath,
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(15, 20, 0, 0),
                width: double.infinity,
                height: 60,
                child: CustomIconButton(
                  text: "Sign in with Apple",
                  onPressed: signInGoogle,
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
              SizedBox(
                width: double.infinity,
                child: DecoratedTextField(
                  keyboardType: TextInputType.text,
                  placeholder: "Phone, email or username",
                  controller: emailController,
                  paddingValue: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                width: double.infinity,
                child: SecondaryButton(
                  text: "Next",
                  onPressed: buttonFunction,
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                width: double.infinity,
                child: SecondaryButtonOutlined(
                  text: "Forgot password ?",
                  onPressed: forgotPassword,
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
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
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
