import 'package:flutter/material.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_avatar.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_header.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_video.dart';

class TweetMediaViewerScreen extends StatelessWidget {
  final String imageUrl;
  final bool isImage;
  final String tag;

  const TweetMediaViewerScreen(
      {Key? key,
      required this.imageUrl,
      required this.tag,
      this.isImage = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: Theme.of(context).iconTheme,
        elevation: 1,
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
                  print("Test Popup menu item");
                },
                value: 1,
              ),
            ],
          )
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Hero(
              tag: tag,
              child: isImage
                  ? Image.asset(imageUrl)
                  : TweetVideo(
                      video: imageUrl,
                      aspect_ratio: 1,
                      auto_play: true,
                      height: MediaQuery.of(context).size.width,
                    ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                TweetAvatar(avatar: "assets/images/user.jpg"),
                Expanded(
                    child: TweetHeader.stretched(
                  tweet_user_handle: "abdallah_aali",
                  tweet_user_name: "Abdallah",
                  tweet_user_verified: true,
                  stretchedMenu: false,
                  // stretched_menu: false,
                )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
