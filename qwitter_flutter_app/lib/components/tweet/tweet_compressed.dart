import 'package:flutter/material.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_avatar.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_header.dart';
import 'package:intl/intl.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_media.dart';

class TweetCompressed extends StatelessWidget {
  final String tweet_text;
  final List<String> tweet_imgs;
  final String tweet_user_handle;
  final String tweet_user_name;
  final bool tweet_user_verified;
  final String tweet_time;
  final bool tweet_edited;
  final String tweet_avatar;

  const TweetCompressed({
    Key? key,
    required this.tweet_text,
    required this.tweet_imgs,
    required this.tweet_avatar,
    required this.tweet_user_handle,
    required this.tweet_user_name,
    required this.tweet_user_verified,
    required this.tweet_time,
    required this.tweet_edited,
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
                          tweet_user_handle: tweet_user_handle,
                          tweet_user_name: tweet_user_name,
                          tweet_user_verified: tweet_user_verified,
                          tweet_time: tweet_time,
                          tweet_edited: tweet_edited),
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
                  tweet_text,
                  textAlign: Bidi.hasAnyRtl(tweet_text)
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
              TweetMedia(tweet_imgs: tweet_imgs, radius: 0),
            ]),
          ),
        ],
      ),
    );
  }
}
