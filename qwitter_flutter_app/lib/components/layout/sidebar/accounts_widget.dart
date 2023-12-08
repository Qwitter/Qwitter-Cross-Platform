import 'package:flutter/material.dart';
import 'package:qwitter_flutter_app/components/layout/sidebar/account_widget.dart';
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:qwitter_flutter_app/models/user.dart';

class AccountsWidget extends StatelessWidget {
  AccountsWidget({super.key});
  AppUser appUser = AppUser();
  final List<User> usersList = [];
  @override
  Widget build(BuildContext context) {
    AppUser appUser = AppUser();
    usersList.add(appUser);
    return Container(
      padding: const EdgeInsets.only(left: 30, right: 30, bottom: 40),
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
              user: e,
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
