import 'dart:convert';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:qwitter_flutter_app/components/basic_widgets/decorated_text_field.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_app_bar.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_next_bar.dart';
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:qwitter_flutter_app/models/user.dart';
import 'package:qwitter_flutter_app/providers/next_bar_provider.dart';
import 'package:qwitter_flutter_app/screens/authentication/signup/suggested_follows_screen.dart';
import 'package:toast/toast.dart';

class AddBirthdateScreen extends ConsumerStatefulWidget {
  const AddBirthdateScreen({super.key, required this.user});

  final User user;
  @override
  ConsumerState<AddBirthdateScreen> createState() => _AddBirthdateScreenState();
}

class _AddBirthdateScreenState extends ConsumerState<AddBirthdateScreen> {
  final TextEditingController birthdayController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    ToastContext ctx = ToastContext();
    ctx.init(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(nextBarProvider.notifier).setNextBarFunction(null);
    });
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

  Future<http.Response> googleSignUp() async {
    //print('Signing up with Google');
    final url = Uri.parse(
        'http://qwitterback.cloudns.org:3000/api/v1/auth/google/signup');

    // Define the data you want to send as a map
    final Map<String, String?> data = {
      'birthDate': widget.user.birthDate!,
    };

    String token;

    String private = await readTextFromFile('private.txt');
    // Create the json web token
    final jwt = JWT(
      {
        'google_id': widget.user.id,
        'name': widget.user.fullName,
        'email': widget.user.email,
      },
    );
    // Sign it
    token = jwt.sign(SecretKey(private));

    //print('Signed token: $token\n');
    final Map<String, String> cookies = {
      'qwitter_jwt': 'Bearer $token',
    };

    final response = await http.post(
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

    // Successfully sent the data
    return response;
  }

  @override
  Widget build(BuildContext context) {
    void Function(BuildContext)? buttonFunction;
    String? userBirthDate;

    Future<void> showDates(BuildContext context) async {
      // ignore: unused_local_variable
      FocusScope.of(context).unfocus();
    }

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(75),
        child: QwitterAppBar(
          showLogoOnly: true,
        ),
      ),
      body: GestureDetector(
        onTap: () {},
        child: Container(
          width: double.infinity,
          color: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(children: [
              const Text(
                'Add your birthdate',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  color: Color.fromARGB(255, 222, 222, 222),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 18),
                      child: GestureDetector(
                        onTap: () {
                          if (defaultTargetPlatform == TargetPlatform.iOS) {
                            showDates(context);
                          } else {
                            FocusScope.of(context).unfocus();
                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now().subtract(
                                const Duration(days: 365 * 21),
                              ),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                              builder: (BuildContext context, Widget? child) {
                                return Theme(
                                  data: ThemeData(
                                    primarySwatch: Colors
                                        .blue, // Customize other theme attributes as needed
                                    primaryColor: Colors.black,
                                    colorScheme: const ColorScheme.light(
                                      primary: Colors.black,
                                    ),
                                    buttonTheme: const ButtonThemeData(
                                        textTheme: ButtonTextTheme.primary),
                                  ),
                                  child: child!,
                                );
                              },
                            ).then((value) {
                              //print('value: $value');
                              if (value != null) {
                                //print('signing up with google');
                                userBirthDate = '${value.toIso8601String()}Z';
                                // save the date as ISO 8601 string
                                birthdayController.text =
                                    '${value.month}-${value.day}-${value.year}';
                                if (birthdayController.text.isNotEmpty) {
                                  buttonFunction = (context) {
                                    widget.user.setBirthDate(userBirthDate);

                                    googleSignUp().then((value) {
                                      //print('Response: ${value.statusCode}S');
                                      if (value.statusCode == 200) {
                                        // user.printUserData();
                                        final userJson = jsonDecode(value.body);
                                        // //print(userJson);
                                        User user =
                                            User.fromJson(userJson["user"]);
                                        final String rawCookies =
                                            (value.headers['set-cookie']) ?? '';
                                        final String token = rawCookies
                                            .split(';')[0]
                                            .split('=')[1]
                                            .split('%20')[1];
                                        user.token = token;
                                        // user.printUserData();
                                        final appUser =
                                            AppUser().copyUserData(user);
                                        appUser.saveUserData();
                                        // ignore: use_build_context_synchronously
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const SuggestedFollowsScreen()),
                                        );
                                      } else if (value.statusCode == 409) {
                                        Toast.show(
                                            'This email is already registered. Please try another email.',
                                            duration: 3);
                                        Navigator.of(context).pop();
                                      } else {
                                        Toast.show(
                                            'Sign up failed. Please try again.');
                                      }
                                    });
                                  };
                                  ref
                                      .read(nextBarProvider.notifier)
                                      .setNextBarFunction(buttonFunction);
                                } else {
                                  buttonFunction = null;
                                  ref
                                      .read(nextBarProvider.notifier)
                                      .setNextBarFunction(buttonFunction);
                                }
                              }
                            });
                          }
                        },
                        child: DecoratedTextField(
                          keyboardType: TextInputType.none,
                          placeholder: 'Date of birth',
                          controller: birthdayController,
                          enabled: false,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
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
        );
      }),
    );
  }
}
