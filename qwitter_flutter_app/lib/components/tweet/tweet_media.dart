import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_video.dart';
import 'package:qwitter_flutter_app/models/tweet.dart';

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
    int orientationFactor =
        MediaQuery.of(context).orientation == Orientation.portrait
            ? 1
            : MediaQuery.of(context).orientation == Orientation.landscape
                ? 2
                : 1;
    // double width = (MediaQuery.of(context).size.width - 65) / 2;
    if (tweetProvider.media!.length >= 2) {
      return Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          ClipRRect(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(widget.radius.toDouble()),
                bottom: const Radius.circular(10)),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
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
                          child: SizedBox(
                            height: orientationFactor *
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
                                    height: orientationFactor *
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
                                  const SizedBox(height: 5),
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
                                        ? SizedBox(
                                            height: orientationFactor *
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
                                            height: orientationFactor *
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
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: SizedBox(
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
                                child: SizedBox(
                                  height: orientationFactor *
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
                                          height: orientationFactor *
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
                                  : const SizedBox(
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
          const SizedBox(
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
                    bottom: const Radius.circular(10)),
                child: isImage(tweetProvider.media![0].value)
                    ? Hero(
                        tag: uniqueIds[0],
                        child: Image.network(
                          tweetProvider.media![0].value,
                          fit: BoxFit.cover,
                          // width: (MediaQuery.of(context).size.width - 65),
                        ),
                      )
                    : SizedBox(
                      child: TweetVideo(
                          video: tweetProvider.media![0].value,
                          aspectRatio: 1,
                          tweet: tweetProvider,
                          height: MediaQuery.of(context).size.height / 3 +
                              (5 * (tweetProvider.media!.length % 2)),
                          autoPlay: true,
                        ),
                    ),
              ))
        ],
      );
    } else {
      return Container();
    }
  }
}
