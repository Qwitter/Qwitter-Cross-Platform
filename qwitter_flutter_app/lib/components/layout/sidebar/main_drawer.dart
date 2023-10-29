import 'package:flutter/material.dart';
import 'package:qwitter_flutter_app/components/layout/sidebar/profile_picture.dart';
import 'package:qwitter_flutter_app/components/layout/theme_changing_widget.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  void _openChangeThemeOverLay(BuildContext context) {
    Navigator.of(context).pop();
    showModalBottomSheet(
        context: context, builder: (context) => const ThemeChangingWidget());
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 375,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 60, left: 40, bottom: 15),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ProfilePicture(
                      imageURL:
                          'https://hips.hearstapps.com/digitalspyuk.cdnds.net/17/13/1490989105-twitter1.jpg?resize=480:*',
                      name: 'Amr Magdy',
                      username: 'AmrMagdy551267'),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.more_vert_outlined,
                        color: Colors.black,
                      ),
                      padding: const EdgeInsets.only(right: 20)),
                ]),
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
                  onTap: () {},
                  leading: const Icon(Icons.person_2_outlined,
                      size: 40, color: Colors.black),
                  title: const Text(
                    'Profile',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: ListTile(
                    onTap: () {},
                    leading:
                        const Icon(Icons.close, size: 40, color: Colors.black),
                    title: const Text(
                      'Premium',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: ListTile(
                    onTap: () {},
                    leading: const Icon(Icons.bookmark_outline_outlined,
                        size: 40, color: Colors.black),
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
                        size: 40, color: Colors.black),
                    title: const Text(
                      'Lists',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: ListTile(
                    onTap: () {},
                    leading: const Icon(Icons.mic_none_sharp,
                        size: 40, color: Colors.black),
                    title: const Text(
                      'Spaces',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 20),
                  child: ListTile(
                    onTap: () {},
                    leading: const Icon(Icons.attach_money_outlined,
                        size: 40, color: Colors.black),
                    title: const Text(
                      'Monetization',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
                    tilePadding: const EdgeInsets.only(top: 20, right: 30, left: 30),
                    childrenPadding: const EdgeInsets.only(left: 20),
                    iconColor: Colors.black,
                    title: const Text(
                      'Settings & Privacy',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                    children: [
                      ListTile(
                        onTap: () {},
                        leading: const Icon(Icons.settings,
                            size: 25, color: Colors.black),
                        title: const Text(
                          'Settings and privacy',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400),
                        ),
                      ),
                      ListTile(
                        onTap: () {},
                        leading: const Icon(Icons.help_outline,
                            size: 25, color: Colors.black),
                        title: const Text(
                          'Help Center',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400),
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
              _openChangeThemeOverLay(context);
            },
            icon: const Icon(
              Icons.brightness_4_outlined,
              color: Colors.black,
              size: 40,
            ),
            padding: const EdgeInsets.only(left: 50, top: 20, bottom: 30),
          )
        ],
      ),
    );
  }
}
