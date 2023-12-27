import 'package:flutter/material.dart';
import 'package:qwitter_flutter_app/components/profile/profile_details_screen.dart';

class TweetReply extends StatelessWidget {
  final String tweetReplyTo;
  final String tweetReplytoUsername;

  TweetReply({required this.tweetReplyTo, required this.tweetReplytoUsername});

  @override
  Widget build(BuildContext context) {
    return tweetReplyTo != ''
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
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Text(
                            "@" + tweetReplytoUsername,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileDetailsScreen(
                                    username: tweetReplytoUsername),
                              ));
                        },
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
