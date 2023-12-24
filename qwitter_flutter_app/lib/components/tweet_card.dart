// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_avatar.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_body.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_bottom_action_bar.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_header.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_menu.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_reply.dart';
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:qwitter_flutter_app/models/tweet.dart';
import 'package:qwitter_flutter_app/screens/tweets/tweet_details.dart';
import 'package:qwitter_flutter_app/screens/tweets/tweet_media_viewer_screen.dart';
import 'package:qwitter_flutter_app/services/tweets_services.dart';

// ignore: must_be_immutable
class TweetCard extends ConsumerStatefulWidget {
  final Tweet tweet;
  dynamic? removeReply;

  TweetCard({required this.tweet, this.removeReply});

  @override
  ConsumerState<TweetCard> createState() => _TweetCardState();
}

class _TweetCardState extends ConsumerState<TweetCard> {
  // bool _reposted = false;
  // bool _liked = false;
  void _makeRepost(tweetProvider) {
    setState(() {
      // ref.read(tweetProvider.provider.notifier).toggleRetweet();
      String retweeted_id = TweetsServices.makeRepost(ref, tweetProvider);
      tweetProvider.currentUserRetweetId = retweeted_id;
      tweetProvider.retweetsCount = tweetProvider.retweetsCount! + 1;
    });
  }

  void _makeLike(tweetProvider) {
    setState(() {
      TweetsServices.makeLike(ref, tweetProvider);
    });
  }

  void _makeFollow(tweetProvider) {
    setState(() {
      TweetsServices.makeFollow(ref, tweetProvider);
    });
  }

  void _openRepostModal(tweetProvider) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20), bottom: Radius.zero)),
          height: 180, // Set the height of the bottom sheet
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Colors.grey[500],
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextButton.icon(
                      onPressed: () {
                        // print(tweetProvider.repostToId.toString() + " ${tweetProvider.toString()}");
                        if (widget.tweet.currentUserRetweetId != null) {
                          TweetsServices.deleteRetweet(
                              ref, context, tweetProvider);
                        } else {
                          Navigator.pop(context);
                          _makeRepost(tweetProvider);
                        }
                      },
                      icon: Icon(
                        Icons.repeat,
                        size: 25,
                        color: Colors.white,
                      ),
                      label: Text(
                        widget.tweet.currentUserRetweetId != null
                            ? "Undo Repost"
                            : "Repost",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        print(widget.tweet.currentUserRetweetId);
                        if (widget.tweet.currentUserRetweetId != null) {
                          TweetsServices.deleteRetweet(
                              ref, context, tweetProvider);
                        } else {
                          Navigator.pop(context);

                          _makeRepost(tweetProvider);
                        }
                      },
                      icon: Icon(
                        Icons.mode_edit_outlined,
                        size: 25,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Quote",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    )
                    // Add more menu items as needed
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _opentweetMenuModal(Tweet tweetProvider) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                  bottom: Radius.zero)), // Set the height of the bottom sheet
          height: 100,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Colors.grey[500],
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              Expanded(
                  child: ListView(
                children: <Widget>[
                  AppUser().username != tweetProvider.user!.username!
                      ? Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _makeFollow(tweetProvider);
                            },
                            icon: Icon(
                              Icons.person_add_alt_outlined,
                              size: 25,
                              color: Colors.grey[600],
                            ),
                            label: Text(
                              (tweetProvider.user!.isFollowed!
                                      ? "Unfollow"
                                      : "Follow") +
                                  " @" +
                                  tweetProvider.user!.username.toString(),
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        )
                      : Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: widget.removeReply ??
                                () {
                                  setState(() {
                                    TweetsServices.deleteTweet(
                                        ref, context, tweetProvider);
                                  });
                                },
                            icon: Icon(
                              Icons.delete,
                              size: 25,
                              color: Colors.grey[600],
                            ),
                            label: Text(
                              "Delete Tweet",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),

                  // Add more menu items as needed
                ],
              )),
            ],
          ),
        );
      },
    );
  }

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
    Navigator.push(
      context,
      isImage(tweetImg)
          ? MaterialPageRoute(builder: (context) {
              return TweetMediaViewerScreen(
                imageUrl: tweetImg,
                tag: uniqueid,
                isImage: isImage(tweetImg),
                tweet: tweet,
              );
            })
          : PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  TweetMediaViewerScreen(
                imageUrl: tweetImg,
                tag: uniqueid,
                isImage: isImage(tweetImg),
                tweet: tweet,
              ),
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

                // var curvedAnimation =
                //     CurvedAnimation(parent: animation, curve: curve);
                return SlideTransition(position: offsetAnimation, child: child);
              },
            ),
    ).then((t) {
      setState(() {
        ref.read(tweet.provider.notifier).setTweet(t as Tweet);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final tweetProvider = ref.watch(widget.tweet.provider);
    AppUser user = AppUser();
    user.getUserData();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return TweetDetailsScreen(
                tweet: tweetProvider, pushMediaViewerFunc: pushMediaViewer);
          }),
        ).then((t) {
          if (t == null) return;
          setState(() {
            ref.read(tweetProvider.provider.notifier).setTweet(t as Tweet);
          });
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color.fromRGBO(30, 30, 30, 1), // Set the border color
              width: 1.0, // Set the border width
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            tweetProvider.currentUserRetweetId.toString() != "null"
                ? Container(
                    padding: EdgeInsets.fromLTRB(40, 10, 10, 0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.repeat,
                          color: Colors.grey[700],
                          size: 15,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          (tweetProvider.retweetUser!.fullName == user.fullName
                                  ? "You"
                                  : tweetProvider.retweetUser!.fullName
                                      .toString()) +
                              " reposted",
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  )
                : Container(),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TweetAvatar(
                      avatar: tweetProvider.user!.profilePicture!.path
                              .startsWith("http")
                          ? tweetProvider.user!.profilePicture!.path
                          : "http://" +
                              tweetProvider.user!.profilePicture!.path,
                      username: tweetProvider.user!.username!,
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 23,
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TweetHeader(
                                  tweet: tweetProvider,
                                  tweetTime: tweetProvider.createdAt!,
                                  opentweetMenuModal: _openRepostModal,
                                  // tweet_edited: tweetProvider_edited,
                                ),
                                TweetMenu(
                                    opentweetMenuModal: () =>
                                        _opentweetMenuModal(tweetProvider))
                              ],
                            ),
                          ),
                          tweetProvider.replyToId.toString() == "null" ||
                                  tweetProvider.replyUser == null
                              ? Container()
                              : TweetReply(
                                  tweetReplyTo: tweetProvider.replyToId!,
                                  tweetReplytoUsername:
                                      tweetProvider.replyUser!.username!),
                          TweetBody(
                            tweet: tweetProvider,
                            pushMediaViewerFunc: pushMediaViewer,
                          ),
                          TweetBottomActionBar(
                            commentsCount: tweetProvider.repliesCount!,
                            repostsCount: tweetProvider.retweetsCount!,
                            likesCount: tweetProvider.likesCount!,
                            makeFollow: () => _makeFollow(tweetProvider),
                            openRepostModal: () =>
                                _openRepostModal(tweetProvider),
                            makeLike: () => _makeLike(tweetProvider),

                            reposted:
                                (tweetProvider.currentUserRetweetId != null),

                            makeComment: () => TweetsServices.makeComment(
                                context, tweetProvider),
                            liked: tweetProvider.isLiked ?? false,
                          ),
                        ],
                      ),
                    )
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
