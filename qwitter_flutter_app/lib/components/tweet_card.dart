// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_avatar.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_body.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_bottom_action_bar.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_header.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_media.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_menu.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_reply.dart';

class TweetCard extends StatefulWidget {
  // const TweetCard({super.key});

  final String tweet_text;
  final String avatar_image;
  final String tweet_user_handle;
  final String tweet_user_name;
  final bool tweet_user_verified;
  final String tweet_replied_to;
  bool tweet_edited;
  final String tweet_time;
  List<String> tweet_imgs = [];
  int comments_count = 0;
  int reposts_count = 0;
  int likes_count = 0;

  final bool has_parent_tweet;
  String sub_tweet_name = '';
  String sub_tweet_handle = '';
  String sub_tweet_text = '';
  String sub_tweet_time = '';
  bool sub_tweet_verified = false;
  bool sub_tweet_edited = false;
  List<String> sub_tweet_imgs = [];
  String sub_avatar_image = '';

  TweetCard(
      {required this.tweet_text,
      required this.avatar_image,
      required this.tweet_user_handle,
      required this.tweet_user_name,
      required this.tweet_user_verified,
      required this.tweet_time,
      required this.tweet_edited,
      this.tweet_replied_to = '',
      this.has_parent_tweet = false});

  setTweetImages(List<String> imgs_arr) {
    tweet_imgs = imgs_arr;
    return this;
  }

  setTweetStats(int comments, int reposts, int likes) {
    comments_count = comments;
    reposts_count = reposts;
    likes_count = likes;
    return this;
  }

  setTweetParent(String name, String handle, String text, bool verified,
      bool edited, String time, List<String> imgs, String avatar) {
    sub_tweet_name = name;
    sub_tweet_handle = handle;
    sub_tweet_text = text;
    sub_tweet_time = time;
    sub_tweet_imgs = imgs;
    sub_tweet_verified = verified;
    sub_tweet_edited = edited;
    sub_avatar_image = avatar;
    return this;
  }

  @override
  State<TweetCard> createState() => _TweetCardState();
}

class _TweetCardState extends State<TweetCard> {
  bool _reposted = false;
  bool _liked = false;
  bool _followed = false;

  void _makeRepost() {
    setState(() {
      _reposted = !_reposted;
      widget.reposts_count += _reposted ? 1 : -1;
    });
  }

  void _makeLike() {
    setState(() {
      _liked = !_liked;
      widget.likes_count += _liked ? 1 : -1;
    });
  }

  void _makeFollow() {
    setState(() {
      _followed = !_followed;
    });
  }

  void _openRepostModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.vertical(top: Radius.circular(20), bottom: Radius.zero)),
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
                        Navigator.pop(context);
                        _makeRepost();
                      },
                      icon: Icon(
                        Icons.repeat,
                        size: 25,
                        color: Colors.white,
                      ),
                      label: Text(
                        _reposted ? "Undo Repost" : "Repost",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _makeRepost();
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

  void _opentweetMenuModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20), bottom: Radius.zero)), // Set the height of the bottom sheet
          height: 900,
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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _makeFollow();
                      },
                      icon: Icon(
                        Icons.person_add_alt_outlined,
                        size: 25,
                        color: Colors.grey[600],
                      ),
                      label: Text(
                        (_followed ? "Unfollow" : "Follow") + " @abdallah_aali",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.post_add_outlined,
                        size: 25,
                        color: Colors.grey[600],
                      ),
                      label: Text(
                        "Add/remove from Lists",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.volume_off,
                        size: 25,
                        color: Colors.grey[600],
                      ),
                      label: Text(
                        "Mute @abdaallah_aali",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.volume_off,
                        size: 25,
                        color: Colors.grey[600],
                      ),
                      label: Text(
                        "Mute this conversation",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.visibility_outlined,
                        size: 25,
                        color: Colors.grey[600],
                      ),
                      label: Text(
                        "View Hidden Replies",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.favorite_outline,
                        size: 25,
                        color: Colors.grey[600],
                      ),
                      label: Text(
                        "Add to Circle",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.block_outlined,
                        size: 25,
                        color: Colors.grey[600],
                      ),
                      label: Text(
                        "Block @abdallah_aali",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.flag_outlined,
                        size: 25,
                        color: Colors.grey[600],
                      ),
                      label: Text(
                        "Report post",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.thumb_down_outlined,
                        size: 25,
                        color: Colors.grey[600],
                      ),
                      label: Text(
                        "Not interested in this post",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  )
                  // Add more menu items as needed
                ],
              )),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color.fromRGBO(30, 30, 30, 1), // Set the border color
            width: 1.0, // Set the border width
          ),
        ),
      ),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TweetAvatar(avatar: widget.avatar_image),
            const SizedBox(
              width: 3,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 23,
                  width: MediaQuery.of(context).size.width - 65,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TweetHeader(
                        tweet_user_handle: widget.tweet_user_handle,
                        tweet_user_name: widget.tweet_user_name,
                        tweet_user_verified: widget.tweet_user_verified,
                        tweet_time: widget.tweet_time,
                        tweet_edited: widget.tweet_edited,
                      ),
                      TweetMenu(opentweetMenuModal: _opentweetMenuModal)
                    ],
                  ),
                ),
                TweetReply(tweet_reply_to: widget.tweet_replied_to),
                TweetBody(
                  sub_tweet_text: widget.sub_tweet_text,
                  sub_tweet_imgs: widget.sub_tweet_imgs,
                  tweet_text: widget.tweet_text,
                  tweet_imgs: widget.tweet_imgs,
                  sub_tweet_user_handle: widget.sub_tweet_handle,
                  sub_tweet_user_name: widget.sub_tweet_name,
                  sub_tweet_user_verified: widget.sub_tweet_verified,
                  sub_tweet_time: widget.sub_tweet_time,
                  sub_tweet_edited: widget.sub_tweet_edited,
                  has_parent_tweet: widget.has_parent_tweet,
                  sub_tweet_avatar: widget.sub_avatar_image,
                ),
                TweetBottomActionBar(
                    comments_count: widget.comments_count,
                    reposts_count: widget.reposts_count,
                    likes_count: widget.likes_count,
                    makeFollow: _makeFollow,
                    openRepostModal: _openRepostModal,
                    makeLike: _makeLike,
                    reposted: _reposted,
                    liked: _liked),
              ],
            )
          ]),
    );
  }
}
