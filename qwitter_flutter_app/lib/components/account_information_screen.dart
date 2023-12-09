import 'package:flutter/material.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/custom_setting_card.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_back_app_bar.dart';
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:qwitter_flutter_app/screens/authentication/complements/change_email_screen.dart';
import 'package:qwitter_flutter_app/screens/authentication/signup/signup_choose_method_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountInformationScreen extends StatelessWidget {
  const AccountInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppUser user = AppUser();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75),
        child: QwitterTitleAppBar(
          title: "Account information",
          extraTitle: "@${user.username}",
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomSettingCard(
                title: "Username",
                subtitle: "@${user.username}",
              ),
              CustomSettingCard(
                title: "Email Address",
                subtitle: user.email!,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangeEmailScreen(
                                email: user.email!,
                              )));
                },
              ),
              const CustomSettingCard(
                title: "Country",
                subtitle: "Select a country",
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'select the country you live in.',
                        style: TextStyle(color: Colors.grey[700], fontSize: 14),
                      ),
                      WidgetSpan(
                        child: InkWell(
                          onTap: () {
                            // Handle the click action for "strong password" here.
                          },
                          child: const Text(
                            ' Learn more',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const CustomSettingCard(
                title: "Automation",
                subtitle: "Manage your automated account",
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(17, 0, 0, 0),
                child: TextButton(
                    onPressed: () {
                      SharedPreferences.getInstance().then((prefs) {
                        prefs.clear().then((value) {
                          //print('SharedPreferences cleared!');
                        });
                      });
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) =>
                              const SignupChooseMethodScreen()));
                    },
                    child: const Text(
                      "Log out",
                      style: TextStyle(color: Colors.red),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
