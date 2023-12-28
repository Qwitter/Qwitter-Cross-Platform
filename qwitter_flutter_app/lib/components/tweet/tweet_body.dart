import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:qwitter_flutter_app/components/profile/profile_details_screen.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_media.dart';
import 'package:qwitter_flutter_app/models/tweet.dart';
import 'package:qwitter_flutter_app/screens/searching/search_screen.dart';

class TweetBody extends ConsumerStatefulWidget {
  final Tweet tweet;
  final bool stretched;
  final Function? pushMediaViewerFunc;

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
  List<InlineSpan> buildTextWithButton(String text) {
    final List<InlineSpan> textWithButtons = [];
    final RegExp wordBoundaryRegex = RegExp(r'\s+');
    final List<String> splitBySpace = text.split(wordBoundaryRegex);
    final RegExp mentionRegex = RegExp(r'@[\w\u0600-\u06FF]+');
    final RegExp hashtagRegex = RegExp(r'#[\w\u0600-\u06FF]+');

    for (String segment in splitBySpace) {
      if (mentionRegex.hasMatch(segment)) {
        textWithButtons.add(TextSpan(
          text: '$segment ',
          style: const TextStyle(
              color: Colors.blue, fontWeight: FontWeight.bold),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileDetailsScreen(
                            username: segment.trim().replaceAll('@', '')),
                      ));
                print("Mention");

            },
        )
            );
      } else if (hashtagRegex.hasMatch(segment)) {
        textWithButtons.add(
          TextSpan(
            text: '$segment ',
            style: const TextStyle(
                color: Colors.blue, fontWeight: FontWeight.bold),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchScreen(
                            hastag: segment.trim(), query: "",),
                      ));
                print("Hashtag");
              },
          ),
        );
      } else {
        textWithButtons.add(
          TextSpan(
            text: '$segment ', // Add space after each segment except the last one
            style: const TextStyle(
              height: 1.2,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        );
      }
    }

    return textWithButtons;
  }

  @override
  Widget build(BuildContext context) {
    // //print("rebuilt");
    final tweetProvider = ref.read(widget.tweet.provider);
    return SizedBox(
      width: MediaQuery.of(context).size.width -
          (widget.stretched
              ? 50
              : 80), // Set the maximum width for text wrapping
      child: Column(
          crossAxisAlignment: Bidi.hasAnyRtl(widget.tweet.text!)
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            // Text(
            //   widget.tweet.text!,
            //   textAlign: Bidi.hasAnyRtl(widget.tweet.text!)
            //       ? TextAlign.end
            //       : TextAlign.start,
            //   style: const TextStyle(
            //     height: 1.2,
            //     fontSize: 16,
            //     color: Colors.white,
            //   ),
            //   softWrap: true, // Allow text to wrap within the specified width
            // ),
            RichText(
              textAlign: Bidi.hasAnyRtl(widget.tweet.text!)
                  ? TextAlign.end
                  : TextAlign.start,
              text: TextSpan(
                style: const TextStyle(
                  height: 1.2,
                  fontSize: 16,
                  color: Colors.white,
                ),
                children: buildTextWithButton(widget.tweet.text!),
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
