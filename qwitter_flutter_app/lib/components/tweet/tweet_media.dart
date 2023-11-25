import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_video.dart';
import 'package:qwitter_flutter_app/screens/tweet_media_viewer_screen.dart';

class TweetMedia extends StatelessWidget {
  final List<String> tweet_imgs;
  final int radius;
  TweetMedia({required this.tweet_imgs, this.radius = 10});

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

  void pushMediaViewer(BuildContext context, tweet_img, unique_id) {
    Navigator.push(
      context,
      isImage(tweet_img)
          ? MaterialPageRoute(builder: (context) {
              return TweetMediaViewerScreen(
                imageUrl: tweet_img,
                tag: unique_id,
                isImage: isImage(tweet_img),
              );
            })
          : PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  TweetMediaViewerScreen(imageUrl: tweet_img,
                tag: unique_id,
                isImage: isImage(tweet_img)),
              transitionDuration:
                  Duration(milliseconds: 500), // Set the duration here
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;
                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);

                var curvedAnimation =
                    CurvedAnimation(parent: animation, curve: curve);
                return SlideTransition(position: offsetAnimation, child: child);
              },
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> unique_ids = [
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
    if (tweet_imgs.length >= 2) {
      return Column(
        children: [
          SizedBox(
            height: 10,
          ),
          ClipRRect(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(radius.toDouble()),
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
                                context, tweet_imgs[0], unique_ids[0]);
                          },
                          child: Container(
                            height: orientation_factor *
                                (tweet_imgs.length == 4
                                    ? MediaQuery.of(context).size.height / 6
                                    : MediaQuery.of(context).size.height / 3 +
                                        (5 * (tweet_imgs.length % 2))),
                            child: isImage(tweet_imgs[0])
                                ? Hero(
                                    tag: unique_ids[0],
                                    child: Image.asset(
                                      tweet_imgs[0],
                                      fit: BoxFit.cover,
                                      // width: (MediaQuery.of(context).size.width - 65),
                                    ),
                                  )
                                : TweetVideo(
                                    video: tweet_imgs[0],
                                    aspect_ratio: 1,
                                    height: orientation_factor *
                                        (tweet_imgs.length == 4
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                6
                                            : MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    3 +
                                                (5 * (tweet_imgs.length % 2))),
                                    auto_play: true,
                                  ),
                          ),
                        ),
                        tweet_imgs.length == 4
                            ? Column(
                                children: [
                                  SizedBox(height: 5),
                                  GestureDetector(
                                    onTap: () {
                                      pushMediaViewer(context, tweet_imgs[3],
                                          unique_ids[3]);
                                    },
                                    child: isImage(tweet_imgs[3])
                                        ? Container(
                                            height: orientation_factor *
                                                (tweet_imgs.length == 4
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
                                              tag: unique_ids[3],
                                              child: Image.asset(
                                                tweet_imgs[3],
                                                fit: BoxFit.cover,
                                                // width: (MediaQuery.of(context).size.width - 65),
                                              ),
                                            ),
                                          )
                                        : TweetVideo(
                                            video: tweet_imgs[3],
                                            aspect_ratio: 1.0,
                                            height: orientation_factor *
                                                (tweet_imgs.length == 4
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
                      children: tweet_imgs
                          .sublist(
                              1, tweet_imgs.length > 3 ? 3 : tweet_imgs.length)
                          .asMap()
                          .entries
                          .map(
                        (image) {
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  pushMediaViewer(context, image.value,
                                      unique_ids[image.key + 1]);
                                },
                                child: Container(
                                  height: orientation_factor *
                                      (tweet_imgs.length == 2
                                          ? MediaQuery.of(context).size.height /
                                              3
                                          : MediaQuery.of(context).size.height /
                                              6),
                                  width:
                                      (MediaQuery.of(context).size.width - 65) /
                                          2,
                                  child: isImage(image.value)
                                      ? Hero(
                                          tag: unique_ids[image.key + 1],
                                          child: Image.asset(
                                            image.value,
                                            fit: BoxFit.cover,
                                            // width: (MediaQuery.of(context).size.width - 65),
                                          ),
                                        )
                                      : TweetVideo(
                                          video: image.value,
                                          aspect_ratio: 1.0,
                                          height: orientation_factor *
                                              (tweet_imgs.length == 2
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
                              image.key == min(tweet_imgs.length, 3) - 2
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
    } else if (tweet_imgs.length == 1) {
      return Column(
        children: [
          SizedBox(
            height: 10,
          ),
          GestureDetector(
              onTap: () {
                //print"Test Image");
              },
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(radius.toDouble()),
                    bottom: Radius.circular(10)),
                child: Image.asset(
                  'assets/images/tweet_img.jpg',
                  fit: BoxFit.cover,
                  width: (MediaQuery.of(context).size.width - 65),
                ),
              ))
        ],
      );
    } else {
      return Container();
    }
  }
}
