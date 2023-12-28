// import 'dart:js_util';

import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:qwitter_flutter_app/components/basic_widgets/primary_button.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/custom_icon_button.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/secondary_button_outlined.dart';
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:qwitter_flutter_app/models/user.dart';
import 'package:qwitter_flutter_app/screens/authentication/login/forget_password_screen.dart';
import 'package:qwitter_flutter_app/screens/authentication/login/login_choose_screen.dart';
import 'package:qwitter_flutter_app/screens/authentication/signup/add_birthdate_screen.dart';
import 'package:qwitter_flutter_app/screens/authentication/signup/select_languages_screen.dart';
import 'package:qwitter_flutter_app/screens/authentication/signup/suggested_follows_screen.dart';

import '../../../api/google_signin_api.dart';

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
  User user = User();

  bool isActive = false;
  void hello() {
    setState(() {
      isActive = false;
    });
    passController.clear();
  }

  void forgotPassword() {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => const ForgetPasswordScreenEmail()),
    );
  }

  void signupApple() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const SelectLanguagesScreen()),
    );
  }

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
        'http://back.qwitter.cloudns.org:3000/api/v1/auth/check-existence');

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
    final url = Uri.parse(
        'http://back.qwitter.cloudns.org:3000/api/v1/auth/google/login');

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

    print('Signed token: $token\n');
    final Map<String, String> cookies = {
      'qwitter_jwt': 'Bearer $token',
    };

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Cookie': cookies.entries
            .map((entry) => '${entry.key}=${entry.value}')
            .join('; '),
      },
    );

    // Successfully sent the data
    return response;
  }

  Future signGoogle() async {
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
      user.setEmail(email).setFullName(username).setId(gid);
      checkEmailAvailability().then((value) {
        print('Response: ${value.statusCode}');
        if (value.statusCode == 200) {
          print('email not found go add birthdate');
          // ignore: use_build_context_synchronously
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => AddBirthdateScreen(user: user)),
          );
        } else {
          // New token should be recieved here
          //print('email found go to suggested follows');
          googleSignIn().then((value) {
            print("response : ${value.statusCode}");
            print("response : ${value.body}");
            print("reason : ${value.reasonPhrase}");

            if (value.statusCode == 200) {
              final userJson = jsonDecode(value.body);
              // //print(userJson);
              User user = User.fromJson(userJson["user"]);
              // final String rawCookies = (value.headers['set-cookie']) ?? '';
              // print("rawCookies: $rawCookies");
              final token = jsonDecode(value.body)["token"];

              user.token = token;

              print("Token : $token");
              // user.printUserData();
              final appUser = AppUser().copyUserData(user);
              appUser.saveUserData();
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

  void createAccont() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const SelectLanguagesScreen()),
    );
  }

  void signIn() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const LoginChooseScreen()),
    );
  }

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
                  padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                  child: Image.asset('assets/images/qwitter.png', height: 50)),
              const SizedBox(
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
                  onPressed: signGoogle,
                  image: googleImagePath,
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(15, 20, 0, 0),
                width: double.infinity,
                height: 60,
                child: CustomIconButton(
                  text: "Sign up with Apple",
                  onPressed: () {},
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
                  onPressed: createAccont,
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
                  onPressed: signIn,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
