import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_compressed.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_media.dart';

class TweetBody extends StatelessWidget {
  final String tweet_text;
  final List<String> tweet_imgs;

  final bool has_parent_tweet;
  final String sub_tweet_user_handle;
  final String sub_tweet_user_name;
  final bool sub_tweet_user_verified;
  final String sub_tweet_time;
  final bool sub_tweet_edited;
  final List<String> sub_tweet_imgs;
  final String sub_tweet_text;
  final String sub_tweet_avatar;
  final bool stretched;

  const TweetBody({
    Key? key,
    required this.tweet_text,
    required this.tweet_imgs,
    required this.has_parent_tweet,
    required this.sub_tweet_user_handle,
    required this.sub_tweet_user_name,
    required this.sub_tweet_user_verified,
    required this.sub_tweet_time,
    required this.sub_tweet_edited,
    required this.sub_tweet_imgs,
    required this.sub_tweet_text,
    required this.sub_tweet_avatar,
    this.stretched = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width -
          (stretched ? 50 : 80), // Set the maximum width for text wrapping
      child: Column(
          crossAxisAlignment: Bidi.hasAnyRtl(tweet_text)
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              tweet_text,
              textAlign:
                  Bidi.hasAnyRtl(tweet_text) ? TextAlign.end : TextAlign.start,
              style: TextStyle(
                height: 1.2,
                fontSize: 16,
                color: Colors.white,
              ),
              softWrap: true, // Allow text to wrap within the specified width
            ),
            TweetMedia(tweet_imgs: tweet_imgs),
            has_parent_tweet
                ? TweetCompressed(
                    tweet_text: sub_tweet_text,
                    tweet_imgs: sub_tweet_imgs,
                    tweet_user_handle: sub_tweet_user_handle,
                    tweet_user_name: sub_tweet_user_name,
                    tweet_user_verified: sub_tweet_user_verified,
                    tweet_time: sub_tweet_time,
                    tweet_edited: sub_tweet_edited,
                    tweet_avatar: sub_tweet_avatar,
                  )
                : Container()
          ]),
    );
  }
}
