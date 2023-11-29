import 'package:flutter/material.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Bookmarks",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          PopupMenuButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            offset: Offset(0, 40),
            color: Colors.grey[900],
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text(
                  "Clear all bookmarks",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  // //print("Test Popup menu item");
                },
                value: 1,
              ),
            ],
          )
        ],
        iconTheme: Theme.of(context).iconTheme,
        elevation: 1,
      ),
      body: ListView.builder(
        itemBuilder: (ctx, index) {
          return Container();
          // return Container(
          //   child: 
          //   TweetCard(
          //     tweet_text:
          //         "Hello in English, I'm trying to type some words to make my tweet looks good",
          //     avatar_image: 'assets/images/user.jpg',
          //     tweet_time: '2h',
          //     tweet_user_name: 'Abdallah',
          //     tweet_user_handle: '@abdallah_aali',
          //     tweet_user_verified: true,
          //     tweet_edited: true,
          //     has_parent_tweet: true,
          //   )
          //       .setTweetImages(
          //         [],
          //       )
          //       .setTweetStats(
          //         100,
          //         205,
          //         2365,
          //       )
          //       .setTweetParent(
          //           'Abdallah',
          //           '@abdallah_aali',
          //           "بالعربي بقا نشوف التنصيص بتاع اللغة العربية ازاي بقا يا عم الحاج",
          //           true,
          //           false,
          //           '2h',
          //           [
          //             'assets/images/tweet_img.jpg',
          //             'assets/images/tweet_img_2.jpg',
          //             'assets/images/tweet_img.jpg'
          //           ],
          //           'assets/images/user.jpg'),
          // );
        },
        itemCount: 10,
      ),
    );
  }
}
