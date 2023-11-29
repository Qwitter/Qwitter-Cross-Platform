import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/decorated_text_field.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_app_bar.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_next_bar.dart';
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:qwitter_flutter_app/models/user.dart';
import 'package:qwitter_flutter_app/providers/next_bar_provider.dart';
import 'package:qwitter_flutter_app/screens/authentication/signup/profile_picture_screen.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class AddPasswordScreen extends ConsumerStatefulWidget {
  const AddPasswordScreen({super.key, required this.user});

  final User? user;

  @override
  ConsumerState<AddPasswordScreen> createState() => _AddPasswordScreenState();
}

class _AddPasswordScreenState extends ConsumerState<AddPasswordScreen> {
  final TextEditingController passwordController = TextEditingController();

  String? passwordValidations(String? password) {
    if (password == null || password.isEmpty) return null;

    if (password.contains(' ')) return 'Password cannot contain spaces.';
    if (password.length < 8) {
      return 'Password must be at least 8 characters long.';
    }

    if (!RegExp(r'^(?=.*[a-zA-Z])[^\s]+$').hasMatch(password)) {
      return 'Password must contain at least one letter and no spaces.';
    }

    return null;
  }

  Future<bool> sendData() async {
    final url =
        Uri.parse('http://qwitterback.cloudns.org:3000/api/v1/auth/signup');

    // Define the data you want to send as a map
    final Map<String, String> data = {
      'email': widget.user!.email!,
      'name': widget.user!.fullName!,
      'password': widget.user!.password!,
      'birthDate': widget.user!.birthDate!,
      'passwordConfirmation': widget.user!.password!,
    };

    final response = await http.post(
      url,
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
    );

    if (response.statusCode == 200) {
      // Successfully sent the data
      final responseBody = json.decode(response.body);
      // //print(responseBody);
      User user = User.fromJson(responseBody["data"]);
      user.token = responseBody['token'];
      // //print(responseBody["token"]);
      // user.printUserData();
      final appUser = AppUser().copyUserData(user);
      appUser.saveUserData();
      widget.user!.setUsername(responseBody['data']['userName']);
      widget.user!.setUsernameSuggestions(responseBody['suggestions']);
      widget.user!.setToken(responseBody['token']);
      //printresponseBody['data']['userName']);
      //printresponseBody['suggestions'][0]);
      return true;
    } else {
      // Handle errors
      //print('Error sending data ${response.statusCode} ${response.body}');
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    ToastContext ctx = ToastContext();
    ctx.init(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(nextBarProvider.notifier).setNextBarFunction(null);
    });
  }

  @override
  void dispose() {
    super.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void Function(BuildContext)? buttonFunction;
    passwordController.addListener(() {
      if (passwordController.text.isNotEmpty &&
          passwordValidations(passwordController.text) == null) {
        buttonFunction = (context) {
          widget.user!.password = passwordController.text;
          sendData().then((value) {
            if(value){
              Toast.show('Account created successfully!');

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePictureScreen(
                  user: widget.user,
                ),
              ),
            );
            }else{
              //print("Failed to create account");
            }
          }).onError((error, stackTrace) {
            // Toast.show('Error sending data $stackTrace');
            //print('Error sending data $error');
            //print(stackTrace);
          });
        };
        widget.user!.setPassword(passwordController.text);
        ref.read(nextBarProvider.notifier).setNextBarFunction(buttonFunction);
      } else {
        buttonFunction = null;
        ref.read(nextBarProvider.notifier).setNextBarFunction(buttonFunction);
      }
    });
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(75),
          child: QwitterAppBar(
            showLogoOnly: true,
            autoImplyLeading: false,
          ),
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
                      paddingValue: const EdgeInsets.all(0),
                      controller: passwordController,
                      isPassword: true,
                      validator: passwordValidations,
                    ),
                  ],
                ),
              ),
            ]),
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
          );
        }),
      ),
    );
  }
}
