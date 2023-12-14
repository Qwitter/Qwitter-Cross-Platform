import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qwitter_flutter_app/models/conversation_data.dart';
import 'package:qwitter_flutter_app/models/user.dart';
import 'package:qwitter_flutter_app/providers/conversations_provider.dart';
import 'package:qwitter_flutter_app/providers/messages_provider.dart';
import 'package:qwitter_flutter_app/providers/user_search_provider.dart';
import 'package:qwitter_flutter_app/screens/messaging/messaging_screen.dart';
import 'package:qwitter_flutter_app/screens/tweets/tweets_feed_screen.dart';

class SearchUserWidget extends ConsumerStatefulWidget {
  SearchUserWidget({
    super.key,
    required this.user,
    this.selected = false,
  });
  final User user;
  bool selected;
  @override
  ConsumerState<SearchUserWidget> createState() {
    return _SearchUserState();
  }
}

class _SearchUserState extends ConsumerState<SearchUserWidget> {
  void searchButtonFunction() {
    print("hello world");
    print(widget.selected);
    if (widget.selected) {
      print("rem");
      ref.watch(selectedUserProvider.notifier).removeUser(widget.user);
    } else {
      ref.watch(selectedUserProvider.notifier).addUser(widget.user);
    }
    print(widget.selected);

    setState(() {
      widget.selected = !widget.selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    double radius = 20;
    print(widget.user.profilePicture);
    return Container(
      height: 75,
      child: ElevatedButton(
        onPressed: searchButtonFunction,
        style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
        child: ListTile(
          leading: ((widget.user.profilePicture?.path ?? "") != "")
              ? Container(
                  width: radius * 2,
                  child: CircleAvatar(
                    radius: radius,
                    backgroundImage:
                        NetworkImage(widget.user.profilePicture?.path ?? ""),
                  ),
                )
              : ClipOval(
                  child: Image.asset(
                    "assets/images/def.jpg",
                    width: 35,
                  ),
                ),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user.fullName ?? "no name",
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              Text(
                "@" + (widget.user.username ?? "no handle"),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          trailing: widget.selected
              ? const Icon(Icons.check)
              : Container(
                  width: 5,
                  height: 5,
                ),
        ),
      ),
    );
  }
}
