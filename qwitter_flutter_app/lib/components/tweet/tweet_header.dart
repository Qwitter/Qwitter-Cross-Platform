// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:qwitter_flutter_app/components/profile/profile_details_screen.dart';
import 'package:qwitter_flutter_app/utils/date_humanizer.dart';

class TweetHeader extends StatelessWidget {
  final String tweetUserHandle;
  final String tweetUserName;
  final bool tweetUserVerified;
  final String tweetTime;
  final bool followed;
  final bool stretched;
  final bool stretchedMenu;

  const TweetHeader({
    Key? key,
    required this.tweetUserHandle,
    required this.tweetUserName,
    required this.tweetUserVerified,
    this.tweetTime = "",
    this.followed = false,
    this.stretched = false,
    this.stretchedMenu = false,
    // required this.tweet_edited,
  }) : super(key: key);

  const TweetHeader.stretched({
    Key? key,
    required this.tweetUserHandle,
    required this.tweetUserName,
    required this.tweetUserVerified,
    this.stretchedMenu = true,
    this.tweetTime = "",
    this.followed = false,
  })  : stretched = true,
        super(key: key);

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

  List<Widget> headerRowWidgets(width, context) {
    return [
      TextButton(
        onPressed: () {},
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          // backgroundColor: MaterialStateColor.resolveWith((states) => Colors.red),
          padding: MaterialStateProperty.all(EdgeInsets.zero),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: FittedBox(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProfileDetailsScreen(username: tweetUserHandle),
                    ));
              },
              child: Text(
                tweetUserName.length > 15
                    ? tweetUserName.substring(0, 15)
                    : tweetUserName,
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
      ...tweetUserVerified ? tweetVerifiedIcon() : [Container()],
      Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: SizedBox(
          width: width * 0.15,
          child: Text(
            "@" + tweetUserHandle,
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
            DateHelper.formatDateString(tweetTime),
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

  List<Widget> headerColumnWidgets(goToProfile) {
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
                            tweetUserName.length > 15
                                ? tweetUserName.substring(0, 15)
                                : tweetUserName,
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
                ...tweetUserVerified ? tweetVerifiedIcon() : [Container()],
              ],
            ),
            FittedBox(
              child: Text(
                "@" + tweetUserHandle,
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
                  Container(
                    height: 35,
                    padding: !stretchedMenu
                        ? EdgeInsets.fromLTRB(0, 0, 15, 0)
                        : EdgeInsets.zero,
                    child: OutlinedButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(horizontal: 25)),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "Follow",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  stretchedMenu
                      ? Container(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                child: IconButton(
                                  style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.zero),
                                      alignment: Alignment.center),
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.more_vert,
                                    color: Colors.grey[600],
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
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
    return SizedBox(
      height: stretched ? 90 : 30,
      child: stretched
          ? Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: headerColumnWidgets((){
                print("handle : " + tweetUserHandle);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProfileDetailsScreen(username: tweetUserHandle),
                    ));
              }),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children:
                  headerRowWidgets(MediaQuery.of(context).size.width, context),
            ),
    );
  }
}
