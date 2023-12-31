import 'dart:convert';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qwitter_flutter_app/components/layout/qwitter_app_bar.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_next_bar.dart';
import 'package:qwitter_flutter_app/components/user_card.dart';
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:qwitter_flutter_app/screens/authentication/signup/suggested_follows_screen.dart';

class FollowingScreen extends StatefulWidget {
  const FollowingScreen({super.key, this.username});

  final String? username;

  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  List followersList = [];
  final ScrollController _scrollController = ScrollController();
  int page = 1;
  Future<http.Response> getListOfFollowing() async {
    final url = Uri.parse(
        'http://back.qwitter.cloudns.org:3000/api/v1/user/follow/${widget.username}?page=${page.toString()}&limit=10');

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

  void scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      getListOfFollowing().then((value) {
        print(value.reasonPhrase);
        print(value.body);
        final newFollowersList = jsonDecode(value.body);
        setState(() {
          page++;
          followersList.addAll(newFollowersList);
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.addListener(scrollListener);
      getListOfFollowing().then((value) {
        // print(value.reasonPhrase);
        // print(value.body);
        setState(() {
          followersList = jsonDecode(value.body);
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
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(75),
          child: QwitterAppBar(
            showLogoOnly: true,
            showLogo: false,
            showHeading: true,
            headingText: 'Following',
            includeActions: true,
            actionButton: IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SuggestedFollowsScreen(
                        parent: 'followScreen',
                      ),
                    ),
                  );
                },
                icon: const Icon(BootstrapIcons.person_add)),
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
            itemCount: followersList.length,
            itemBuilder: (BuildContext context, int index) {
              return followersList.isEmpty
                  ? Container()
                  : UserCard(
                      userData: followersList[index],
                      isFollowed: true,
                    );
            },
          ),
        ),
      ),
    );
  }
}
