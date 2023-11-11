// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qwitter_flutter_app/components/account_information_screen.dart';
import 'package:qwitter_flutter_app/components/account_settings_screen.dart';
import 'package:qwitter_flutter_app/models/user.dart';
import 'package:qwitter_flutter_app/screens/authentication/complements/change_email_screen.dart';
import 'package:qwitter_flutter_app/screens/authentication/complements/forget_password_screen.dart';
import 'package:qwitter_flutter_app/screens/authentication/login/forget_new_password_screen.dart';
import 'package:qwitter_flutter_app/screens/authentication/login/forget_password_screen.dart';
// import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:qwitter_flutter_app/screens/authentication/login/login_choose_screen.dart';
import 'package:qwitter_flutter_app/screens/authentication/login/login_email_screen.dart';
import 'package:qwitter_flutter_app/screens/authentication/login/login_main_screen.dart';
import 'package:qwitter_flutter_app/screens/authentication/login/update_password_screen.dart';
import 'package:qwitter_flutter_app/screens/authentication/signup/confirmation_code_screen.dart';
import 'package:qwitter_flutter_app/screens/authentication/signup/create_account_screen.dart';
import 'package:qwitter_flutter_app/screens/authentication/signup/select_languages_screen.dart';
import 'package:qwitter_flutter_app/screens/authentication/signup/signup_choose_method_screen.dart';
import 'package:qwitter_flutter_app/screens/authentication/signup/suggested_follows_screen.dart';
import 'package:qwitter_flutter_app/screens/authentication/login/forget_password_screen.dart';
import 'package:qwitter_flutter_app/screens/messaging/conversations_screen.dart';
import 'package:riverpod/riverpod.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // AppUser user = AppUser();
    // user.getUserData();
    // print('user data : ${user.getUsername}');
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData( 
            color: Colors.white, // Change the color of the back icon
          ),
        ),
      ),
      home:  ConversationScreen(),
    );
  }
}

// Home Screen depending on if user is logged in or not
// FutureBuilder(
//         future: user.getUserData(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             // Display a loading indicator while the future is loading
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           } else if (snapshot.hasData) {
//             return SuggestedFollowsScreen();
//           } else {
//             return SignupChooseMethodScreen();
//           }
//         },
