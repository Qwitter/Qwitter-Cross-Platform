import 'dart:convert';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qwitter_flutter_app/components/layout/qwitter_app_bar.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_next_bar.dart';
import 'package:qwitter_flutter_app/components/user_card.dart';
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:qwitter_flutter_app/screens/authentication/signup/suggested_follows_screen.dart';

class RetweetersScreen extends StatefulWidget {
  const RetweetersScreen({super.key, required this.tweetId});
  final String? tweetId;
  @override
  State<RetweetersScreen> createState() => _RetweetersScreenState();
}

class _RetweetersScreenState extends State<RetweetersScreen> {
  List retweetersList = [];
  ScrollController _scrollController = ScrollController();
  int page = 1;
  Future<http.Response> getListOfRetweeters() async {
    print("Token: ${AppUser().getToken}");
    print("Tweet ID: ${widget.tweetId}");

    final url = Uri.parse(
        'http://back.qwitter.cloudns.org:3000/api/v1/tweets/${widget.tweetId}/retweets?page=${page.toString()}&limit=10');

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
      _scrollController.addListener(() {
        // Check if the user has reached the end of the list
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          // Fetch new data (e.g., from an API) and update the list
          page++;
          getListOfRetweeters().then((value) {
            print(value.reasonPhrase);
            print(value.body);
            final newRetweetersList = jsonDecode(value.body);
            setState(() {
              retweetersList.addAll(newRetweetersList);
            });
          });
        }
      });

      getListOfRetweeters().then((value) {
        print(value.reasonPhrase);
        print(value.body);
        setState(() {
          retweetersList = jsonDecode(value.body)['retweeters'];
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(75),
          child: QwitterAppBar(
            showLogoOnly: true,
            showLogo: false,
            showHeading: true,
            headingText: 'Retweeters',
          ),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
          child: ListView.builder(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: retweetersList.length,
            itemBuilder: (BuildContext context, int index) {
              return retweetersList.isEmpty
                  ? Container()
                  : UserCard(
                      userData: retweetersList[index],
                      isFollowed: false,
                    );
            },
          ),
        ),
      ),
    );
  }
}
