import 'package:flutter/material.dart';

class TweetReply extends StatelessWidget {
  final String tweet_reply_to;

  TweetReply({required this.tweet_reply_to});

  @override
  Widget build(BuildContext context) {
    return tweet_reply_to != ''
        ? Column(
            children: [
              Container(
                height: 23,
                padding: EdgeInsets.zero,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      Text(
                        "replied to ",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w400),
                      ),
                      TextButton(
                        style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all(EdgeInsets.zero)),
                        child: Text(
                          tweet_reply_to,
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                              fontWeight: FontWeight.w400),
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              )
            ],
          )
        : Container();
  }
}
