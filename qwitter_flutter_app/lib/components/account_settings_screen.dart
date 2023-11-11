import 'package:flutter/material.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/custom_setting_card.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_back_app_bar.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(75),
        child: QwitterBackAppBar(
          currentIcon: Icons.arrow_back,
          title: "Your account",
          extraTitle: "@username",
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
        child: Column(
          children: [
            Text(
              "See information about your account, download an archive of your data or learn about your account deactivation options.",
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),
            const CustomSettingCard(
              icon: Icons.person_outline,
              title: "Account information",
              subtitle:
                  "See your account information like your phone number and email address. ",
            ),
            const CustomSettingCard(
              icon: Icons.lock_outline,
              title: "Change your password",
              subtitle: "Change your password at any time",
            ),
            const CustomSettingCard(
              icon: Icons.file_download_outlined,
              title: "Donwload an archive of your data",
              subtitle:
                  "Get insights into the type of information stored for your account.",
            ),
            const CustomSettingCard(
              icon: Icons.heart_broken_outlined,
              title: "Deactivate Account",
              subtitle: "Find out how you can deactivate your account.",
            ),
          ],
        ),
      ),
    );
  }
}
