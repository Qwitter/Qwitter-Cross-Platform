// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qwitter_flutter_app/components/profile/profile_details_screen.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_menu.dart';
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:qwitter_flutter_app/models/tweet.dart';
import 'package:qwitter_flutter_app/services/tweets_services.dart';
import 'package:qwitter_flutter_app/utils/date_humanizer.dart';

class TweetHeader extends ConsumerStatefulWidget {
  final String tweetTime;
  final bool followed;
  final bool stretched;
  final bool stretchedMenu;
  final opentweetMenuModal;
  final Tweet tweet;

  const TweetHeader({
    Key? key,
    required this.opentweetMenuModal,
    required this.tweet,
    this.tweetTime = "",
    this.followed = false,
    this.stretched = false,
    this.stretchedMenu = false,
    // required this.tweet_edited,
  }) : super(key: key);

  const TweetHeader.stretched({
    Key? key,
    required this.opentweetMenuModal,
    required this.tweet,
    this.stretchedMenu = true,
    this.tweetTime = "",
    this.followed = false,
  })  : stretched = true,
        super(key: key);

  @override
  ConsumerState<TweetHeader> createState() => _TweetHeaderState();
}

class _TweetHeaderState extends ConsumerState<TweetHeader> {
  List<Widget> tweetVerifiedIcon() {
    return [
      SizedBox(width: 5),
      Icon(
        Icons.verified,
        color: Colors.blue,
        size: 16,
      ),
    ];
  }

  List<Widget> headerRowWidgets(width, context, Tweet tweetProvider) {
    final appUser = AppUser();
    return [
      Container(
        alignment: Alignment.centerLeft,
        child: TextButton(
          onPressed: () {},
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            // backgroundColor: MaterialStateColor.resolveWith((states) => Colors.red),
            minimumSize: MaterialStateProperty.all(Size.zero),
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            alignment: Alignment.centerLeft,
            visualDensity: VisualDensity(horizontal: -4, vertical: -4),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: FittedBox(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileDetailsScreen(
                            username: tweetProvider.user!.username!),
                      ));
                },
                child: SizedBox(
                  // width: 0.25 * width,
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    tweetProvider.user!.fullName!.length > 15
                        ? tweetProvider.user!.fullName!.substring(0, 15)
                        : tweetProvider.user!.fullName!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      ...tweetProvider.user!.isVerified ?? false
          ? tweetVerifiedIcon()
          : [Container()],
      Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: SizedBox(
          width: width * 0.2,
          child: Text(
            "@" + tweetProvider.user!.username!,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
                fontWeight: FontWeight.w400),
          ),
        ),
      ),
      Container(
        width: 3,
        height: 3,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[600],
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: FittedBox(
          child: Text(
            DateHelper.formatDateString(tweetProvider.createdAt!),
            style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                fontWeight: FontWeight.w400),
          ),
        ),
      ),
      Container(
        width: 3,
        height: 3,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[600],
        ),
      ),
      // tweet_edited
      //     ? Container(
      //         padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
      //         width: 18,
      //         child: IconButton(
      //           onPressed: () {},
      //           icon: Icon(
      //             Icons.edit,
      //             color: Colors.grey[800],
      //             size: 16,
      //           ),
      //           style: ButtonStyle(
      //               // overlayColor: MaterialStateColor.resolveWith(
      //               //     (states) => Colors.transparent),
      //               padding: MaterialStateProperty.all(EdgeInsets.zero),
      //               alignment: Alignment.centerRight),
      //         ),
      //       )
      //     : Container()
    ];
  }

  List<Widget> headerColumnWidgets(goToProfile, Tweet tweetProvider) {
    final appUser = AppUser();

    return [
      Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                SizedBox(
                  height: 30,
                  child: TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                      // backgroundColor: MaterialStateColor.resolveWith((states) => Colors.red),
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        child: GestureDetector(
                          onTap: goToProfile,
                          child: Text(
                            tweetProvider.user!.fullName!.length > 15
                                ? tweetProvider.user!.fullName!.substring(0, 15)
                                : tweetProvider.user!.fullName!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                ...tweetProvider.user!.isVerified!
                    ? tweetVerifiedIcon()
                    : [Container()],
              ],
            ),
            FittedBox(
              child: Text(
                "@" + tweetProvider.user!.username!,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400),
              ),
            ),
          ]),
      Container(
        alignment: Alignment.centerRight,
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  if (appUser.username != tweetProvider.user!.username!)
                    Container(
                      height: 35,
                      padding: !widget.stretchedMenu
                          ? EdgeInsets.fromLTRB(0, 0, 15, 0)
                          : EdgeInsets.zero,
                      child: FittedBox(
                        child: OutlinedButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(horizontal: 25)),
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) => tweetProvider.user!.isFollowed! ? Colors.white : Colors.black),
                          ),
                          onPressed: () {
                            setState(() {
                              TweetsServices.makeFollow(ref, tweetProvider);
                            });
                          },
                          child: Text(
                            !tweetProvider.user!.isFollowed!
                                ? "Follow"
                                : "Unfollow",
                            style: TextStyle(
                                color: !tweetProvider.user!.isFollowed!? Colors.white : Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  widget.stretchedMenu
                      ? TweetMenu(opentweetMenuModal: widget.opentweetMenuModal)
                      : Container()
                ],
              ),
            ),
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final tweetProvider = ref.watch(widget.tweet.provider);
    return SizedBox(
      height: widget.stretched ? 90 : 30,
      // width: MediaQuery.of(context).size.width - 190,
      child: widget.stretched
          ? Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: headerColumnWidgets(() {
                print("handle : " + tweetProvider.user!.username!);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileDetailsScreen(
                          username: tweetProvider.user!.username!),
                    ));
              }, tweetProvider),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: headerRowWidgets(
                  MediaQuery.of(context).size.width, context, tweetProvider),
            ),
    );
  }
}
