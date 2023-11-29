import 'package:flutter/material.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_avatar.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_header.dart';
import 'package:intl/intl.dart';
import 'package:qwitter_flutter_app/models/tweet.dart';

class TweetCompressed extends StatelessWidget {
  final String tweetText;
  final List<Media> tweetImgs;
  final String tweetUserHandle;
  final String tweetUserName;
  final bool tweetUserVerified;
  final String tweetTime;
  final bool tweetEdited;
  final String tweet_avatar;

  const TweetCompressed({
    Key? key,
    required this.tweetText,
    required this.tweetImgs,
    required this.tweet_avatar,
    required this.tweetUserHandle,
    required this.tweetUserName,
    required this.tweetUserVerified,
    required this.tweetTime,
    required this.tweetEdited,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width - 80,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey[800]!,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    TweetAvatar(avatar: tweet_avatar, radius: 10),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                      child: TweetHeader(
                        tweetUserHandle: tweetUserHandle,
                        tweetUserName: tweetUserName,
                        tweetUserVerified: tweetUserVerified,
                        tweetTime: tweetTime,
                        // tweetEdited: tweetEdited,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Text(
                  tweetText,
                  textAlign: Bidi.hasAnyRtl(tweetText)
                      ? TextAlign.end
                      : TextAlign.start,
                  style: TextStyle(
                    height: 1.2,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  softWrap:
                      true, // Allow text to wrap within the specified width
                ),
              ),
              SizedBox(
                height: 10,
              ),
              // TweetMedia(
              //   tweetImgs: tweetImgs,
              //   radius: 0,
              // ),
            ]),
          ),
        ],
      ),
    );
  }
}
