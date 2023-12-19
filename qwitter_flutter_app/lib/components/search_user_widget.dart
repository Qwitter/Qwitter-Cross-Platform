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
    if (widget.selected) {
      ref.watch(selectedUserProvider.notifier).removeUser(widget.user);
    } else {
      ref.watch(selectedUserProvider.notifier).addUser(widget.user);
    }
    setState(() {
      widget.selected = !widget.selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    double radius = 20;
    return InkWell(
      onTap: widget.user.inConversation ?? false ? null : searchButtonFunction,
      child: Container(
        color: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        height: 75,
        width: double.infinity,
        child: Opacity(
          opacity: widget.user.inConversation ?? false ? 0.5 : 1,
          child: ListTile(
            leading: ClipOval(
              // borderRadius: BorderRadius.circular(30),
              child: Image.network(
                widget.user.profilePicture?.path ?? "",
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    // Image has successfully loaded
                    return child;
                  } else {
                    // Image is still loading
                    return CircularProgressIndicator();
                  }
                },
                errorBuilder: (BuildContext context, Object error,
                    StackTrace? stackTrace) {
                  // Handle image loading errors
                  return ClipOval(
                    child: Image.asset(
                      "assets/images/def.jpg",
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  );
                },
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
            trailing: widget.selected || (widget.user.inConversation ?? false)
                ? const Icon(Icons.check)
                : Container(
                    width: 5,
                    height: 5,
                  ),
          ),
        ),
      ),
    );
  }
}
