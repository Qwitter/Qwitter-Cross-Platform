import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_video.dart';
import 'package:qwitter_flutter_app/models/tweet.dart';
import 'package:qwitter_flutter_app/models/user.dart';
import 'package:qwitter_flutter_app/screens/tweet_media_viewer_screen.dart';

class TweetMedia extends ConsumerStatefulWidget {
  // final List<Media> tweet_imgs;
  // final User tweetUser;
  final Tweet tweet;
  final int radius;
  final pushMediaViewerFunc;
  TweetMedia({
    required this.tweet,
    required this.pushMediaViewerFunc,
    this.radius = 10,
    
  });

  @override
  ConsumerState<TweetMedia> createState() => _TweetMediaState();
}

class _TweetMediaState extends ConsumerState<TweetMedia> {
  bool isImage(String filePath) {
    final imageExtensions = [
      'jpg',
      'jpeg',
      'png',
      'gif',
      'bmp',
      'webp'
    ]; // Add more image formats if needed
    final fileExtension = filePath.split('.').last.toLowerCase();
    return imageExtensions.contains(fileExtension);
  }

  bool isVideo(String filePath) {
    final videoExtensions = [
      'mp4',
      'mov',
      'avi',
      'mkv',
      'wmv'
    ]; // Add more video formats if needed
    final fileExtension = filePath.split('.').last.toLowerCase();
    return videoExtensions.contains(fileExtension);
  }

  void pushMediaViewer(BuildContext context, tweetImg, uniqueid, Tweet tweet) {
    // Navigator.push(
    //   context,
    //   isImage(tweetImg)
    //       ? MaterialPageRoute(builder: (context) {
    //           return TweetMediaViewerScreen(
    //             imageUrl: tweetImg,
    //             tag: uniqueid,
    //             isImage: isImage(tweetImg),
    //             tweet: tweet,
    //           );
    //         })
    //       : PageRouteBuilder(
    //           pageBuilder: (context, animation, secondaryAnimation) =>
    //               TweetMediaViewerScreen(
    //             imageUrl: tweetImg,
    //             tag: uniqueid,
    //             isImage: isImage(tweetImg),
    //             tweet: tweet,
    //           ),
    //           transitionDuration:
    //               Duration(milliseconds: 500), // Set the duration here
    //           transitionsBuilder:
    //               (context, animation, secondaryAnimation, child) {
    //             const begin = Offset(1.0, 0.0);
    //             const end = Offset.zero;
    //             const curve = Curves.easeInOut;
    //             var tween = Tween(begin: begin, end: end)
    //                 .chain(CurveTween(curve: curve));
    //             var offsetAnimation = animation.drive(tween);

    //             var curvedAnimation =
    //                 CurvedAnimation(parent: animation, curve: curve);
    //             return SlideTransition(position: offsetAnimation, child: child);
    //           },
    //         ),
    // ).then((t) {
    //   setState(() {
    //     ref.read(tweet.provider.notifier).setTweet(t as Tweet);
    //   });
    // });

    widget.pushMediaViewerFunc(context, tweetImg, uniqueid, tweet);
  }

  @override
  Widget build(BuildContext context) {
    
    final tweetProvider = ref.watch(widget.tweet.provider);

    List<String> uniqueIds = [
      UniqueKey().toString(),
      UniqueKey().toString(),
      UniqueKey().toString(),
      UniqueKey().toString()
    ];
    int orientation_factor =
        MediaQuery.of(context).orientation == Orientation.portrait
            ? 1
            : MediaQuery.of(context).orientation == Orientation.landscape
                ? 2
                : 1;
    // double width = (MediaQuery.of(context).size.width - 65) / 2;
    if (tweetProvider.media!.length >= 2) {
      return Column(
        children: [
          SizedBox(
            height: 10,
          ),
          ClipRRect(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(widget.radius.toDouble()),
                bottom: Radius.circular(10)),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    // height: 180,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            pushMediaViewer(
                                context,
                                tweetProvider.media![0].value,
                                uniqueIds[0],
                                tweetProvider);
                          },
                          child: Container(
                            height: orientation_factor *
                                (tweetProvider.media!.length == 4
                                    ? MediaQuery.of(context).size.height / 6
                                    : MediaQuery.of(context).size.height / 3 +
                                        (5 *
                                            (tweetProvider.media!.length % 2))),
                            child: isImage(tweetProvider.media![0].value)
                                ? Hero(
                                    tag: uniqueIds[0],
                                    child: Image.network(
                                      tweetProvider.media![0].value,
                                      fit: BoxFit.cover,
                                      // width: (MediaQuery.of(context).size.width - 65),
                                    ),
                                  )
                                : TweetVideo(
                                    video: tweetProvider.media![0].value,
                                    aspectRatio: 1,
                                    tweet: tweetProvider,
                                    height: orientation_factor *
                                        (tweetProvider.media!.length == 4
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                6
                                            : MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    3 +
                                                (5 *
                                                    (tweetProvider
                                                            .media!.length %
                                                        2))),
                                    autoPlay: true,
                                  ),
                          ),
                        ),
                        tweetProvider.media!.length == 4
                            ? Column(
                                children: [
                                  SizedBox(height: 5),
                                  GestureDetector(
                                    onTap: () {
                                      pushMediaViewer(
                                          context,
                                          tweetProvider.media![3].value,
                                          uniqueIds[3],
                                          tweetProvider);
                                    },
                                    child: isImage(
                                            tweetProvider.media![3].value)
                                        ? Container(
                                            height: orientation_factor *
                                                (tweetProvider.media!.length ==
                                                        4
                                                    ? MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        6
                                                    : MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        3),
                                            width: (MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    65) /
                                                2,
                                            child: Hero(
                                              tag: uniqueIds[3],
                                              child: Image.network(
                                                tweetProvider.media![3].value,
                                                fit: BoxFit.cover,
                                                // width: (MediaQuery.of(context).size.width - 65),
                                              ),
                                            ),
                                          )
                                        : TweetVideo(
                                            video:
                                                tweetProvider.media![3].value,
                                            aspectRatio: 1.0,
                                            tweet: tweetProvider,
                                            height: orientation_factor *
                                                (tweetProvider.media!.length ==
                                                        4
                                                    ? MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        6
                                                    : MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        3),
                                          ),
                                  )
                                ],
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Container(
                    // height: 180,
                    child: Column(
                      children: tweetProvider.media!
                          .sublist(
                              1,
                              tweetProvider.media!.length > 3
                                  ? 3
                                  : tweetProvider.media!.length)
                          .asMap()
                          .entries
                          .map(
                        (image) {
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  pushMediaViewer(context, image.value.value,
                                      uniqueIds[image.key + 1], tweetProvider);
                                },
                                child: Container(
                                  height: orientation_factor *
                                      (tweetProvider.media!.length == 2
                                          ? MediaQuery.of(context).size.height /
                                              3
                                          : MediaQuery.of(context).size.height /
                                              6),
                                  width:
                                      (MediaQuery.of(context).size.width - 65) /
                                          2,
                                  child: isImage(image.value.value)
                                      ? Hero(
                                          tag: uniqueIds[image.key + 1],
                                          child: Image.network(
                                            image.value.value,
                                            fit: BoxFit.cover,
                                            // width: (MediaQuery.of(context).size.width - 65),
                                          ),
                                        )
                                      : TweetVideo(
                                          video: image.value.value,
                                          aspectRatio: 1.0,
                                          tweet: tweetProvider,
                                          height: orientation_factor *
                                              (tweetProvider.media!.length == 2
                                                  ? MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      3
                                                  : MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      6),
                                        ),
                                ),
                              ),
                              image.key ==
                                      min(tweetProvider.media!.length, 3) - 2
                                  ? Container()
                                  : SizedBox(
                                      height: 5,
                                    )
                            ],
                          );
                        },
                      ).toList(),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      );
    } else if (tweetProvider.media!.length == 1) {
      return Column(
        children: [
          SizedBox(
            height: 10,
          ),
          GestureDetector(
              onTap: () {
                pushMediaViewer(context, tweetProvider.media![0].value,
                    uniqueIds[0], tweetProvider);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(widget.radius.toDouble()),
                    bottom: Radius.circular(10)),
                child: isImage(tweetProvider.media![0].value)
                    ? Hero(
                        tag: uniqueIds[0],
                        child: Image.network(
                          tweetProvider.media![0].value,
                          fit: BoxFit.cover,
                          // width: (MediaQuery.of(context).size.width - 65),
                        ),
                      )
                    : TweetVideo(
                        video: tweetProvider.media![0].value,
                        aspectRatio: 1,
                        tweet: tweetProvider,
                        height: MediaQuery.of(context).size.height / 3 +
                            (5 * (tweetProvider.media!.length % 2)),
                        autoPlay: true,
                      ),
              ))
        ],
      );
    } else {
      return Container();
    }
  }
}
