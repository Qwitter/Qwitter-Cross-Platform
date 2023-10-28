// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class TweetHeader extends StatelessWidget {
  final String tweet_user_handle;
  final String tweet_user_name;
  final bool tweet_user_verified;
  final String tweet_time;
  final bool tweet_edited;

  TweetHeader({
    required this.tweet_user_handle,
    required this.tweet_user_name,
    required this.tweet_user_verified,
    required this.tweet_time,
    required this.tweet_edited,
  });

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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
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
                  tweet_user_name.length > 15 ? '${tweet_user_name.substring(0, 15)}' : tweet_user_name,
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
                tweet_user_handle.length > 15 ? '${tweet_user_handle.substring(0, 15)}...' : tweet_user_handle,
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
        ],
      ),
    );
  }
}
