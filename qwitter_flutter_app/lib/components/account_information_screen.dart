import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/custom_setting_card.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_back_app_bar.dart';
import 'package:qwitter_flutter_app/models/user.dart';

class AccountInformationScreen extends StatelessWidget {
  const AccountInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user;
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(75),
        child: QwitterBackAppBar(
          currentIcon: Icons.arrow_back,
          title: "Account information",
          extraTitle: "@username",
        ),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomSettingCard(
              title: "Username",
              subtitle: "@Maes",
            ),
            const CustomSettingCard(
              title: "Phone",
              subtitle: "+20101111002",
            ),
            const CustomSettingCard(
              title: "Email Address",
              subtitle: "x@gmail.com",
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
                          print('Strong password clicked');
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
                  onPressed: () {},
                  child: const Text(
                    "Log out",
                    style: TextStyle(color: Colors.red),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
