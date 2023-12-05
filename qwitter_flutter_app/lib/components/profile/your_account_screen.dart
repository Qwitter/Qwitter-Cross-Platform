import 'package:flutter/material.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_app_bar.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_next_bar.dart';
import 'package:qwitter_flutter_app/components/user_card.dart';
import 'package:qwitter_flutter_app/screens/tweets/tweets_feed_screen.dart';
import 'package:qwitter_flutter_app/theme/theme_constants.dart';

class YourAccountScreen extends StatelessWidget {
  const YourAccountScreen({super.key});

  void accountInformation(){
      print("go account info");
  }
  void changePassword(){
    print("go change password");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75),
        child: AppBar(
          automaticallyImplyLeading: true,
          title: const Text(
            "Your account",
            style: TextStyle(
              color: white,
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
        child: Column(
          children: [
            const SizedBox(
              height: 80,
              child:  Text(
                "See information about your account,download an archive of your data or learn about your accoint deactivation options.",
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            ElevatedButton(
              onPressed: accountInformation,
              style: ElevatedButton.styleFrom(
                  backgroundColor: black, foregroundColor: white),
              child: const SizedBox(
                height: 100,
                width: double.infinity,
                child:  Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                     SizedBox(
                      height: 50,
                      width: 50,
                      child: Icon(Icons.person),
                    ),
                    Expanded(
                      child:  Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text(
                            "Account information",
                            style: TextStyle(fontSize: 18),
                          ),
                           SizedBox(
                            height: 3,
                          ),
                           Text(
                            "See your account information like yourr phone number and email adress.",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            ElevatedButton(
              onPressed: changePassword,
              style: ElevatedButton.styleFrom(
                  backgroundColor: black, foregroundColor: white),
              child: const SizedBox(
                height: 100,
                width: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                     SizedBox(
                      height: 50,
                      width: 50,
                      child: Icon(Icons.lock),
                    ),
                    Expanded(
                      child:  Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text(
                            "Change your password.",
                            style: TextStyle(fontSize: 18),
                          ),
                           SizedBox(
                            height: 3,
                          ),
                          Text(
                            "Change your password at any time.",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: black, foregroundColor: white),
              child: const SizedBox(
                height: 100,
                width: double.infinity,
                child:  Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: Icon(Icons.file_download_outlined),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Download an archive of your data",
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            "Get insights into the type of information stored for your account.",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: black, foregroundColor: white),
              child: const SizedBox(
                height: 100,
                width: double.infinity,
                child:  Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: Icon(Icons.heart_broken_outlined),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Deactivate Account",
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            "Find out how you can deactivate you account.",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
