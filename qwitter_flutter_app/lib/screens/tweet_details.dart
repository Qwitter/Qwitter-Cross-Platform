import 'package:flutter/material.dart';
import 'package:qwitter_flutter_app/Components/layout/qwitter_app_bar.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_avatar.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_body.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_header.dart';
import 'package:qwitter_flutter_app/components/tweet_card.dart';

class TweetDetailsScreen extends StatefulWidget {
  const TweetDetailsScreen({super.key});

  @override
  State<TweetDetailsScreen> createState() => _TweetDetailsScreenState();
}

class _TweetDetailsScreenState extends State<TweetDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Post",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: Theme.of(context).iconTheme,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Container(
          // alignment: Alignment.topLeft,
          alignment: Alignment.center,
          child: Column(children: [
            Row(
              children: [
                const TweetAvatar(avatar: "assets/images/user.jpg"),
                Expanded(
                  child: TweetHeader.stretched(
                    tweet_user_handle: "@abdallah_aali",
                    tweet_user_name: "Abdallah",
                    tweet_user_verified: true,
                  ),
                ),
              ],
            ),
            TweetBody(
              tweet_text:
                  "Hello in English, I'm trying to type some words to make my tweet looks good",
              tweet_imgs: [
                'assets/images/tweet_img.jpg',
                'assets/images/tweet_img_2.jpg',
                'assets/images/tweet_img.jpg'
              ],
              sub_tweet_avatar: "",
              sub_tweet_edited: false,
              sub_tweet_imgs: [],
              sub_tweet_text: "",
              sub_tweet_time: "",
              sub_tweet_user_handle: "",
              sub_tweet_user_name: "",
              sub_tweet_user_verified: true,
              has_parent_tweet: false,
              stretched: true,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(15, 20, 15, 0),
              child: Row(
                children: [
                  Text(
                    "01:12",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: 3,
                    height: 3,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "02 Nov 23",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: 3,
                    height: 3,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text("45K"),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Views",
                    style: TextStyle(color: Colors.grey[600]),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey[900]!, width: 1),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey[900]!, width: 1),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 10 + 10 * ("41".length).toDouble(),
                          child: TextButton(
                            onPressed: () {},
                            child: Text("41"),
                            style: ButtonStyle(
                              alignment: Alignment.center,
                              // overlayColor: MaterialStateProperty.all(Colors.transparent),
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.zero),
                            ),
                          ),
                        ),
                        Text(
                          "Reposts",
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 16),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 10 + 10 * ("41".length).toDouble(),
                          child: TextButton(
                            onPressed: () {},
                            child: Text("41"),
                            style: ButtonStyle(
                              alignment: Alignment.center,
                              // overlayColor: MaterialStateProperty.all(Colors.transparent),
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.zero),
                            ),
                          ),
                        ),
                        Text(
                          "Quotes",
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 16),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 10 + 10 * ("41".length).toDouble(),
                          child: TextButton(
                            onPressed: () {},
                            child: Text("41"),
                            style: ButtonStyle(
                              alignment: Alignment.center,
                              // overlayColor: MaterialStateProperty.all(Colors.transparent),
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.zero),
                            ),
                          ),
                        ),
                        Text(
                          "Likes",
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 16),
                        ),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey[900]!, width: 1),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 10 + 10 * ("41".length).toDouble(),
                          child: TextButton(
                            onPressed: () {},
                            child: Text("41"),
                            style: ButtonStyle(
                              alignment: Alignment.center,
                              // overlayColor: MaterialStateProperty.all(Colors.transparent),
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.zero),
                            ),
                          ),
                        ),
                        Text(
                          "Bookmarks",
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 16),
                        )
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(color: Colors.grey[900]!, width: 1)),
                    ),
                    child: Row(children: [
                      Expanded(
                        child: IconButton(
                          icon: Icon(
                            Icons.chat_bubble_outline,
                            color: Colors.grey[600],
                            size: 20,
                          ),
                          onPressed: () {},
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          icon: Icon(
                            Icons.repeat_outlined,
                            color: Colors.grey[600],
                            size: 22,
                          ),
                          onPressed: () {},
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          icon: Icon(
                            Icons.favorite_border,
                            color: Colors.grey[600],
                            size: 22,
                          ),
                          onPressed: () {},
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          icon: Icon(
                            Icons.bookmark_outline,
                            color: Colors.grey[600],
                            size: 22,
                          ),
                          onPressed: () {},
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          icon: Icon(
                            Icons.share_outlined,
                            color: Colors.grey[600],
                            size: 22,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
            TweetCard(
              tweet_text:
                  "Hello in English, I'm trying to type some words to make my tweet looks good",
              avatar_image: "assets/images/user.jpg",
              tweet_edited: true,
              tweet_time: "23 Oct",
              tweet_user_handle: "@abdallah_aali",
              tweet_user_name: "Abdallah",
              tweet_user_verified: true,
              has_parent_tweet: false,
            )
                .setTweetStats(
              10,
              20,
              30,
            )
                .setTweetImages([
              'assets/images/tweet_img.jpg',
              'assets/images/tweet_img_2.jpg',
              'assets/images/tweet_img.jpg'
            ]),
          ]),
        ),
      ),
    );
  }
}
