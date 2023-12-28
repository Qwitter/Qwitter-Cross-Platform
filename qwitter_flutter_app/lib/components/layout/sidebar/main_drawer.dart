import 'package:flutter/material.dart';
import 'package:qwitter_flutter_app/components/account_settings_screen.dart';
import 'package:qwitter_flutter_app/components/layout/sidebar/accounts_widget.dart';
import 'package:qwitter_flutter_app/components/layout/sidebar/profile_picture.dart';
import 'package:qwitter_flutter_app/components/layout/sidebar/theme_changing_widget.dart';
import 'package:qwitter_flutter_app/components/profile/profile_details_screen.dart';
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  final bool isSignedIn = true;
  void _openChangeThemeOverLay(BuildContext context) {
    Navigator.of(context).pop();
    showModalBottomSheet(
        context: context, builder: (context) => const ThemeChangingWidget());
  }

  void clearSharedPreferences() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.clear().then((value) {
        print('SharedPreferences cleared!');
      });
    });
  }

  void _openChangingAccountsModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return AccountsWidget();
        });
  }
  void onTap(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileDetailsScreen(username: AppUser().username!),));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 375,
      backgroundColor: Colors.black,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isSignedIn)
            Container(
              margin: const EdgeInsets.only(top: 60, left: 40, bottom: 15),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ProfilePicture(),
                    IconButton(
                        onPressed: () {
                          _openChangingAccountsModal(context);
                        },
                        icon: const Icon(
                          Icons.more_vert_outlined,
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.only(right: 20)),
                  ]),
            )
          else
            SafeArea(
              child: Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Join X Now',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Create an offical X account to get the full experience',
                      style:
                          TextStyle(fontSize: 17, color: Colors.grey.shade700),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        splashFactory: NoSplash.splashFactory,
                        padding: const MaterialStatePropertyAll(
                            EdgeInsets.symmetric(vertical: 12, horizontal: 65)),
                        elevation: const MaterialStatePropertyAll(0),
                        backgroundColor:
                            const MaterialStatePropertyAll(Colors.blue),
                        foregroundColor:
                            const MaterialStatePropertyAll(Colors.white),
                        shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35),
                              side: const BorderSide(
                                  color: Color.fromARGB(255, 84, 121, 137),
                                  width: 0.6)),
                        ),
                        fixedSize: const MaterialStatePropertyAll(
                            Size(double.maxFinite, 50)),
                      ),
                      child: const Text(
                        'Create account',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        splashFactory: NoSplash.splashFactory,
                        padding: const MaterialStatePropertyAll(
                            EdgeInsets.symmetric(vertical: 12, horizontal: 65)),
                        elevation: const MaterialStatePropertyAll(0),
                        backgroundColor:
                            const MaterialStatePropertyAll(Colors.transparent),
                        foregroundColor:
                            const MaterialStatePropertyAll(Colors.white),
                        shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35),
                              side: const BorderSide(
                                  color: Color.fromARGB(255, 84, 121, 137),
                                  width: 0.6)),
                        ),
                        fixedSize: const MaterialStatePropertyAll(
                            Size(double.maxFinite, 50)),
                      ),
                      child: const Text(
                        'Log in',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Divider(
            color: Colors.grey.shade300,
            indent: 30,
            endIndent: 30,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(
                left: 20,
                top: 20,
              ),
              children: [
                ListTile(
                  onTap: () {onTap(context);},
                  leading: const Icon(Icons.person_2_outlined,
                      size: 40, color: Colors.white),
                  title: const Text(
                    'Profile',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                if (isSignedIn)
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: ListTile(
                      onTap: () => clearSharedPreferences(),
                      leading: const Icon(Icons.close,
                          size: 40, color: Colors.white),
                      title: const Text(
                        'Premium',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: ListTile(
                    onTap: () {},
                    leading: const Icon(Icons.bookmark_outline_outlined,
                        size: 40, color: Colors.white),
                    title: const Text(
                      'Bookmarks',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: ListTile(
                    onTap: () {},
                    leading: const Icon(Icons.list_alt_outlined,
                        size: 40, color: Colors.white),
                    title: const Text(
                      'Lists',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                if (isSignedIn)
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: ListTile(
                      onTap: () {},
                      leading: const Icon(Icons.mic_none_sharp,
                          size: 40, color: Colors.white),
                      title: const Text(
                        'Spaces',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                if (isSignedIn)
                  Container(
                    padding: const EdgeInsets.only(top: 10, bottom: 20),
                    child: ListTile(
                      onTap: () {},
                      leading: const Icon(Icons.attach_money_outlined,
                          size: 40, color: Colors.white),
                      title: const Text(
                        'Monetization',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                Divider(
                  color: Colors.grey.shade300,
                  indent: 30,
                  endIndent: 30,
                ),
                Theme(
                  data: ThemeData().copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    tilePadding:
                        const EdgeInsets.only(top: 20, right: 30, left: 30),
                    childrenPadding: const EdgeInsets.only(left: 20),
                    iconColor: Colors.white,
                    title: const Text(
                      'Settings & Privacy',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                    children: [
                      ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const AccountSettingsScreen(),
                            ),
                          );
                        },
                        leading: const Icon(Icons.settings,
                            size: 25, color: Colors.white),
                        title: const Text(
                          'Settings and privacy',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      ListTile(
                        onTap: () {},
                        leading: const Icon(Icons.help_outline,
                            size: 25, color: Colors.white),
                        title: const Text(
                          'Help Center',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // _openChangeThemeOverLay(context);
            },
            icon: const Icon(
              Icons.brightness_4_outlined,
              color: Colors.white,
              size: 40,
            ),
            padding: const EdgeInsets.only(left: 50, top: 20, bottom: 30),
          )
        ],
      ),
    );
  }
}
