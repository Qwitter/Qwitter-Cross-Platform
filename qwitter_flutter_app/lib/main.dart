// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:qwitter_flutter_app/models/conversation_data.dart';
import 'package:qwitter_flutter_app/models/message_data.dart';
import 'package:qwitter_flutter_app/models/user.dart';
import 'package:qwitter_flutter_app/providers/user_search_provider.dart';
import 'package:qwitter_flutter_app/screens/authentication/complements/forget_password_screen.dart';

import 'package:qwitter_flutter_app/screens/authentication/login/login_choose_screen.dart';
import 'package:qwitter_flutter_app/screens/authentication/login/login_email_screen.dart';
import 'package:qwitter_flutter_app/screens/authentication/login/login_main_screen.dart';
import 'package:qwitter_flutter_app/screens/authentication/signup/signup_choose_method_screen.dart';
import 'package:qwitter_flutter_app/screens/messaging/conversation_info_screen.dart';
import 'package:qwitter_flutter_app/screens/messaging/create_conversation_screen.dart';
import 'package:qwitter_flutter_app/screens/messaging/messaging_screen.dart';
import 'package:qwitter_flutter_app/screens/messaging/create_conversation_screen.dart';
import 'package:qwitter_flutter_app/screens/messaging/messaging_screen.dart';
import 'package:qwitter_flutter_app/screens/tweets/tweets_feed_screen.dart';
import 'package:qwitter_flutter_app/screens/messaging/conversations_screen.dart';
import 'package:qwitter_flutter_app/screens/messaging/messaging_screen.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:qwitter_flutter_app/theme/theme_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.

  void clearSharedPreferences() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.reload().then((value) {
        //print('SharedPreferences cleared!');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    AppUser user = AppUser();
    user.getUserData();
    // clearSharedPreferences();
    // print('user data : ${user.getToken}');
    return MaterialApp(
      title: 'Flutter Demo',
      theme: darkTheme,
      home: FutureBuilder(
          future: user.getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Display a loading indicator while the future is loading
              return Center(
                child: CircularProgressIndicator(),
              );  
            } else if (user.username != null) {
              // //print(snapshot.data);
              return ConversationScreen();
            } else {
              return SignupChooseMethodScreen();
            }
          }),
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
