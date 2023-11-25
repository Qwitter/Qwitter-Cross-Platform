// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_menu.dart';

class TweetHeader extends StatelessWidget {
  final String tweet_user_handle;
  final String tweet_user_name;
  final bool tweet_user_verified;
  String tweet_time = "";
  bool tweet_edited = false;
  bool followed = false;
  bool stretched = false;
  bool stretchedMenu = true;

  TweetHeader({
    required this.tweet_user_handle,
    required this.tweet_user_name,
    required this.tweet_user_verified,
    required this.tweet_time,
    required this.tweet_edited,
  });

  TweetHeader.stretched({
    required this.tweet_user_handle,
    required this.tweet_user_name,
    required this.tweet_user_verified,
    this.stretchedMenu = true,
  }) {
    stretched = true;
  }

  List<Widget> tweetVerifiedIcon() {
    return [
      SizedBox(width: 5),
      Container(
        child: Icon(
          Icons.verified,
          color: Colors.blue,
          size: 16,
        ),
      )
    ];
  }

  List<Widget> headerRowWidgets() {
    return [
      TextButton(
        onPressed: () {},
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          // backgroundColor: MaterialStateColor.resolveWith((states) => Colors.red),
          padding: MaterialStateProperty.all(EdgeInsets.zero),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: FittedBox(
            child: Text(
              tweet_user_name.length > 15
                  ? '${tweet_user_name.substring(0, 15)}'
                  : tweet_user_name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      ...tweet_user_verified ? tweetVerifiedIcon() : [Container()],
      Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: FittedBox(
          child: Text(
            tweet_user_handle.length > 15
                ? '${tweet_user_handle.substring(0, 15)}...'
                : tweet_user_handle,
            style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w400),
          ),
        ),
      ),
      Container(
        width: 3,
        height: 3,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[600],
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: Text(
          tweet_time,
          style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w400),
        ),
      ),
      Container(
        width: 3,
        height: 3,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[600],
        ),
      ),
      tweet_edited
          ? Container(
              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
              width: 18,
              child: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.edit,
                  color: Colors.grey[800],
                  size: 16,
                ),
                style: ButtonStyle(
                    // overlayColor: MaterialStateColor.resolveWith(
                    //     (states) => Colors.transparent),
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                    alignment: Alignment.centerRight),
              ),
            )
          : Container()
    ];
  }

  List<Widget> headerColumnWidgets() {
    return [
      Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  height: 30,
                  child: TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                      // backgroundColor: MaterialStateColor.resolveWith((states) => Colors.red),
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        child: Text(
                          tweet_user_name.length > 15
                              ? '${tweet_user_name.substring(0, 15)}'
                              : tweet_user_name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                ...tweet_user_verified ? tweetVerifiedIcon() : [Container()],
              ],
            ),
            FittedBox(
              child: Text(
                tweet_user_handle.length > 15
                    ? '${tweet_user_handle.substring(0, 15)}...'
                    : tweet_user_handle,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400),
              ),
            ),
          ]),
      Container(
        alignment: Alignment.centerRight,
        child: Expanded(
          child: Row(
            children: [
              Container(
                height: 35,
                padding: !stretchedMenu ? EdgeInsets.fromLTRB(0, 0, 15, 0) : EdgeInsets.zero,
                child: OutlinedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 25)),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Follow",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              stretchedMenu ? Container(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      // padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: IconButton(
                        style: ButtonStyle(
                            // overlayColor:
                            //     MaterialStateProperty.all(Colors.transparent),
                            // backgroundColor: MaterialStateColor.resolveWith((states) => Colors.red),
                            padding: MaterialStateProperty.all(EdgeInsets.zero),
                            alignment: Alignment.center),
                        onPressed: () {},
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.grey[600],
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ): Container()
            ],
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: stretched ? 90 : 30,
      child: stretched
          ? Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: headerColumnWidgets(),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: headerRowWidgets(),
            ),
    );
  }
}
