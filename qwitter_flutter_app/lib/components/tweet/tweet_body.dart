import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_compressed.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_media.dart';
import 'package:qwitter_flutter_app/models/tweet.dart';
import 'package:qwitter_flutter_app/providers/single_tweet_provider.dart';

class TweetBody extends ConsumerStatefulWidget {
  final Tweet tweet;
  final bool stretched;
  final pushMediaViewerFunc;

  TweetBody({
    Key? key,
    required this.tweet,
    Function? this.pushMediaViewerFunc,
    this.stretched = false,
  }) : super(key: key);

  @override
  ConsumerState<TweetBody> createState() => _TweetBodyState();
}

class _TweetBodyState extends ConsumerState<TweetBody> {
  

  @override
  Widget build(BuildContext context) {
    print("rebuilt");
    final tweetProvider = ref.read(widget.tweet.provider);
    return Container(
      width: MediaQuery.of(context).size.width -
          (widget.stretched ? 50 : 80), // Set the maximum width for text wrapping
      child: Column(
          crossAxisAlignment: Bidi.hasAnyRtl(widget.tweet.text!)
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              widget.tweet.text!,
              textAlign:
                  Bidi.hasAnyRtl(widget.tweet.text!) ? TextAlign.end : TextAlign.start,
              style: TextStyle(
                height: 1.2,
                fontSize: 16,
                color: Colors.white,
              ),
              softWrap: true, // Allow text to wrap within the specified width
            ),
            TweetMedia(
              tweet: tweetProvider,
              pushMediaViewerFunc: widget.pushMediaViewerFunc,
            ),
          ]),
    );
  }
}
