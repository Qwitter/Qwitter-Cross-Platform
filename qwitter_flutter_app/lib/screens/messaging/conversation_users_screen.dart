import 'dart:convert';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qwitter_flutter_app/components/conversation_user_card.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_app_bar.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_next_bar.dart';
import 'package:qwitter_flutter_app/components/user_card.dart';
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:qwitter_flutter_app/models/user.dart';
import 'package:qwitter_flutter_app/screens/authentication/signup/suggested_follows_screen.dart';

class ConversationUsersScreen extends StatefulWidget {
  const ConversationUsersScreen({
    super.key,
    required this.users,
  });
  final List<User> users;
  @override
  State<ConversationUsersScreen> createState() =>
      _ConversationUsersScreenState();
}

class _ConversationUsersScreenState extends State<ConversationUsersScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List followersList = widget.users;
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
            headingText: 'Followers',
          ),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: followersList.length,
            itemBuilder: (BuildContext context, int index) {
              return followersList.isEmpty
                  ? Container()
                  : ConversationUserCard(
                      userData: followersList[index],
                    );
            },
          ),
        ),
      ),
    );
  }
}
