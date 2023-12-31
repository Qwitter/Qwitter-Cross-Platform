import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/decorated_text_field.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_app_bar.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_next_bar.dart';
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:qwitter_flutter_app/models/user.dart';
import 'package:qwitter_flutter_app/providers/next_bar_provider.dart';
import 'package:qwitter_flutter_app/screens/authentication/signup/suggested_follows_screen.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class AddUsernameScreen extends ConsumerStatefulWidget {
  const AddUsernameScreen({super.key, this.user, this.previousScreen});

  final User? user;
  final String? previousScreen;

  @override
  ConsumerState<AddUsernameScreen> createState() => _AddUsernameScreenState();
}

class _AddUsernameScreenState extends ConsumerState<AddUsernameScreen> {
  final TextEditingController usernameController = TextEditingController();

  String? usernameValidations(String? username) {
    if (username == null || username.isEmpty) {
      return null;
    }

    if (!RegExp(r'^[a-zA-Z0-9](?!.*__)(?!.*_$)[a-zA-Z0-9_]{0,15}$')
        .hasMatch(username)) {
      return 'Invalid Twitter username. Please check the format.';
    }

    return null;
  }

  Future<Response> updateUsername(String username) async {
    final url =
        Uri.parse('http://back.qwitter.cloudns.org:3000/api/v1/user/username');

    // Define the data you want to send as a map
    final Map<String, String> data = {
      'userName': username,
    };

    final Map<String, String> cookies = {
      'qwitter_jwt': 'Bearer ${widget.user!.getToken}',
    };

    final response = await http.patch(
      url,
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Cookie': cookies.entries
            .map((entry) => '${entry.key}=${entry.value}')
            .join('; '),
      },
    );

    return response;
  }

  @override
  void initState() {
    super.initState();
    usernameController.text = widget.user!.username ?? '';
    print("username ${widget.user!.username}");
    ToastContext ctx = ToastContext();
    ctx.init(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(nextBarProvider.notifier).setNextBarFunction(null);
    });
  }

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void Function(BuildContext)? buttonFunction;

    usernameController.addListener(() {
      if (usernameController.text.isNotEmpty &&
          usernameValidations(usernameController.text) == null) {
        buttonFunction = (context) {
          updateUsername(usernameController.text).then((value) {
            print(value.reasonPhrase);
            print(value.body);
            if (value.statusCode == 200) {
              Toast.show('Username updated successfully.');
              widget.user!.setUsername(usernameController.text);
              print("Updated username : ${widget.user!.username}");
              // Perform Sign Up Logic
              AppUser appUser = AppUser();
              appUser.copyUserData(widget.user!);
              appUser.saveUserData();
              widget.previousScreen == "EditUsername"
                  ? Navigator.pop(context)
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SuggestedFollowsScreen(),
                      ),
                    );
            } else {
              Toast.show('Error updating username. Please try another one.');
            }
          }).onError((error, stackTrace) {
            Toast.show('Error sending data $error');
            //print'Error sending data $error');
          });
        };
        ref.read(nextBarProvider.notifier).setNextBarFunction(buttonFunction);
      } else {
        buttonFunction = null;
        ref.read(nextBarProvider.notifier).setNextBarFunction(buttonFunction);
      }
    });
    return WillPopScope(
      onWillPop: () async {
        Navigator.popUntil(context, (route) => route.isFirst);
        return true;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(75),
          child: QwitterAppBar(
            showLogoOnly: true,
            autoImplyLeading:
                widget.previousScreen == 'EditUsername' ? true : false,
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
                      paddingValue: const EdgeInsets.all(0),
                      controller: usernameController,
                      validator: usernameValidations,
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (final suggestion
                              in widget.user!.usernameSuggestions ?? [])
                            TextButton(
                              onPressed: () {
                                usernameController.text = suggestion;
                              },
                              child: Text(
                                suggestion,
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                        ],
                      ),
                    )
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
            secondaryButtonText:
                widget.previousScreen == "EditUsername" ? '' : 'Skip for now',
            secondaryButtonFunction: () {
              widget.user!.profilePicture = null;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SuggestedFollowsScreen(),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
