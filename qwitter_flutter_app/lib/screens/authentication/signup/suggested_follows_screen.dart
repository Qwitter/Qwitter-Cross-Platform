import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qwitter_flutter_app/components/layout/qwitter_app_bar.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_bottom_navigation.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_next_bar.dart';
import 'package:qwitter_flutter_app/components/user_card.dart';
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:qwitter_flutter_app/screens/tweets/tweets_feed_screen.dart';

class SuggestedFollowsScreen extends StatefulWidget {
  const SuggestedFollowsScreen({super.key, this.parent = 'signup'});

  final String parent;
  @override
  State<SuggestedFollowsScreen> createState() => _SuggestedFollowsScreenState();
}

class _SuggestedFollowsScreenState extends State<SuggestedFollowsScreen> {
  List suggestionList = [];
  Future<http.Response> getListOfSuggestions() async {
    final url = Uri.parse(
        'http://back.qwitter.cloudns.org:3000/api/v1/user/suggestions');

    final Map<String, String> cookies = {
      'qwitter_jwt': 'Bearer ${AppUser().getToken}',
    };

    final response = await http.get(
      url,
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getListOfSuggestions().then((value) {
        print(value.reasonPhrase);
        print(value.body);
        setState(() {
          suggestionList = jsonDecode(value.body);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        int count = 0;
        widget.parent == 'signup'
            ? Navigator.popUntil(context, (route) => route.isFirst)
            : Navigator.of(context).popUntil((_) => count++ >= 2);
        ;
        return true;
      },
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(75),
          child: QwitterAppBar(
            showLogoOnly: true,
            autoImplyLeading: true,
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
                'Suggested Follows',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 28,
                  color: Color.fromARGB(255, 222, 222, 222),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'You\'ll see Tweets from people you follow in your Home Timeline.',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 15,
                  color: Color.fromARGB(255, 132, 132, 132),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'People you may know',
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 222, 222, 222),
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  return suggestionList.isEmpty
                      ? Container()
                      : UserCard(
                          userData: suggestionList[index],
                        );
                },
              ),
            ]),
          ),
        ),
        bottomNavigationBar: QwitterNextBar(
          buttonFunction: () {
            Navigator.popUntil(context, (route) => route.isFirst);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (ctx) {
              return QwitterBottomNavigationBar();
            }));
          },
        ),
      ),
    );
  }
}
