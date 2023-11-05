import 'package:flutter/material.dart';
import 'package:qwitter_flutter_app/components/layout/sidebar/account_widget.dart';

class AccountsWidget extends StatelessWidget {
  AccountsWidget({super.key});
  final List<Map<String, String>> usersList = [
    {
      "name": "Amr Magdy",
      "username": "@AmrMagdy123141",
      "imgURL":
          "https://is4-ssl.mzstatic.com/image/thumb/Purple118/v4/55/8f/0a/558f0a77-5984-573f-6899-e4b7548d3144/source/1280x1280bb.jpg",
      "isSignedIn": "true",
    },
    {
      "name": "Amr Magdy",
      "username": "@AmrMagdy214151",
      "imgURL":
          "https://i1.wp.com/icon-library.com/images/black-discord-icon/black-discord-icon-4.jpg",
      "isSignedIn": "false",
    }
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
      width: double.infinity,

      // height: 300,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 15, bottom: 15),
            margin: const EdgeInsets.only(
              top: 10,
            ),
            child: const Row(
              children: [
                Text(
                  'Accounts',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer()
              ],
            ),
          ),
          ...usersList.map(
            (e) => AccountWidget(
              name: e['name']!,
              username: e['username']!,
              imgURL: e['imgURL']!,
              isSignedIn: e["isSignedIn"]!,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {},
            style: ButtonStyle(
              splashFactory: NoSplash.splashFactory,
              padding: const MaterialStatePropertyAll(
                  EdgeInsets.symmetric(vertical: 12, horizontal: 75)),
              elevation: const MaterialStatePropertyAll(0),
              backgroundColor:
                  const MaterialStatePropertyAll(Colors.transparent),
              foregroundColor: const MaterialStatePropertyAll(Colors.white),
              shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35),
                    side: const BorderSide(
                        color: Color.fromARGB(255, 84, 121, 137), width: 0.6)),
              ),
              fixedSize: MaterialStatePropertyAll(Size(double.infinity, 50)),
            ),
            child: const Text(
              'Create a new account',
              style: TextStyle(
                  color: Colors.black,
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
              foregroundColor: const MaterialStatePropertyAll(Colors.white),
              shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35),
                    side: const BorderSide(
                        color: Color.fromARGB(255, 84, 121, 137), width: 0.6)),
              ),
              fixedSize: MaterialStatePropertyAll(Size(double.infinity, 50)),
            ),
            child: const Text(
              'Add an exsiting account',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
