import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_avatar.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_header.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_video.dart';
import 'package:qwitter_flutter_app/models/tweet.dart';
import 'package:qwitter_flutter_app/screens/tweets/tweet_details.dart';
import 'package:qwitter_flutter_app/services/tweets_services.dart';

class TweetMediaViewerScreen extends ConsumerStatefulWidget {
  final String imageUrl;
  final bool isImage;
  final String tag;
  final Tweet tweet;

  TweetMediaViewerScreen({
    Key? key,
    required this.imageUrl,
    required this.tag,
    this.isImage = true,
    required this.tweet,
  }) : super(key: key);

  @override
  ConsumerState<TweetMediaViewerScreen> createState() =>
      _TweetMediaViewerScreenState();
}

class _TweetMediaViewerScreenState
    extends ConsumerState<TweetMediaViewerScreen> {
  TextEditingController textEditingController = TextEditingController();

  final focusNode = FocusNode();

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
                        Navigator.pop(context);
                        setState(() {
                          TweetsServices.makeRepost(ref, tweetProvider);
                        });
                      },
                      icon: Icon(
                        Icons.repeat,
                        size: 25,
                        color: Colors.white,
                      ),
                      label: Text(
                        tweetProvider.isRetweeted! ? "Undo Repost" : "Repost",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          TweetsServices.makeRepost(ref, tweetProvider);
                        });
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

  @override
  Widget build(BuildContext context) {
    final tweetProvider = ref.watch(widget.tweet.provider);

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, tweetProvider);
        return true;
      },
      child: Scaffold(
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
                    // //print("Test Popup menu item");
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
                tag: widget.tag,
                child: widget.isImage
                    ? Image.network(widget.imageUrl)
                    : TweetVideo(
                        video: widget.imageUrl,
                        aspectRatio: 1,
                        autoPlay: true,
                        tweet: tweetProvider,
                        height: MediaQuery.of(context).size.width,
                        fullScreen: true,
                        tweetSection: [
                          Row(
                            children: [
                              TweetAvatar(
                                avatar:
                                    tweetProvider.user!.profilePicture!.path,
                                radius: 20,
                              ),
                              Expanded(
                                child: TweetHeader.stretched(
                                  tweetUserHandle:
                                      "@" + tweetProvider.user!.username!,
                                  tweetUserName:
                                      tweetProvider.user!.fullName!,
                                  tweetUserVerified: true,
                                  stretchedMenu: true,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Text(
                              tweetProvider.text!,
                              style: TextStyle(
                                  color:
                                      Theme.of(context).secondaryHeaderColor),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) {
                                            return TweetDetailsScreen(
                                              tweet: tweetProvider,
                                            );
                                          }),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.chat_bubble_outline,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                    Text(
                                      tweetProvider.repliesCount.toString(),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () =>
                                          _openRepostModal(tweetProvider),
                                      icon: Icon(
                                        Icons.repeat_outlined,
                                        color: tweetProvider.isRetweeted!
                                            ? Colors.green
                                            : Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                    Text(
                                      tweetProvider.retweetsCount.toString(),
                                      style: TextStyle(
                                          color: tweetProvider.isRetweeted!
                                              ? Colors.green
                                              : Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          TweetsServices.makeLike(
                                              ref, tweetProvider);
                                        });
                                      },
                                      icon: Icon(
                                        tweetProvider.isLiked!
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: tweetProvider.isLiked!
                                            ? Colors.pink
                                            : Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                    Text(
                                      tweetProvider.likesCount.toString(),
                                      style: TextStyle(
                                          color: tweetProvider.isLiked!
                                              ? Colors.pink
                                              : Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.share,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
              ),
            ),
            widget.isImage
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        TweetAvatar(
                            avatar: tweetProvider.user!.profilePicture!.path),
                        Expanded(
                            child: TweetHeader.stretched(
                          tweetUserHandle:
                              "@" + tweetProvider.user!.username!,
                          tweetUserName: tweetProvider.user!.fullName!,
                          tweetUserVerified: true,
                          stretchedMenu: false,
                          // stretched_menu: false,
                        )),
                      ],
                    ),
                  )
                : Container(),
            widget.isImage
                ? Positioned(
                    bottom: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        border: focusNode.hasFocus? Border(
                          top: BorderSide(
                            color: Colors.grey[800]!,
                          ),
                        ) : null,
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          focusNode.hasFocus
                              ? Container()
                              : Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                                  return TweetDetailsScreen(
                                                    tweet: tweetProvider,
                                                  );
                                                }),
                                              );
                                            },
                                            icon: Icon(
                                              Icons.chat_bubble_outline,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                          ),
                                          Text(
                                            tweetProvider.repliesCount
                                                .toString(),
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            onPressed: () =>
                                                _openRepostModal(tweetProvider),
                                            icon: Icon(
                                              Icons.repeat_outlined,
                                              color: tweetProvider.isRetweeted!
                                                  ? Colors.green
                                                  : Colors.white,
                                              size: 18,
                                            ),
                                          ),
                                          Text(
                                            tweetProvider.retweetsCount
                                                .toString(),
                                            style: TextStyle(
                                                color:
                                                    tweetProvider.isRetweeted!
                                                        ? Colors.green
                                                        : Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              setState(() {
                                                TweetsServices.makeLike(
                                                    ref, tweetProvider);
                                              });
                                            },
                                            icon: Icon(
                                              tweetProvider.isLiked!
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: tweetProvider.isLiked!
                                                  ? Colors.pink
                                                  : Colors.white,
                                              size: 18,
                                            ),
                                          ),
                                          Text(
                                            tweetProvider.likesCount.toString(),
                                            style: TextStyle(
                                                color: tweetProvider.isLiked!
                                                    ? Colors.pink
                                                    : Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.share,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                          focusNode.hasFocus
                              ? Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 20, 10, 0),
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      Text(
                                        "Replying to ",
                                        style:
                                            TextStyle(color: Colors.grey[500]),
                                      ),
                                      Text(
                                        "@" + tweetProvider.user!.username!,
                                        style: TextStyle(color: Colors.blue),
                                      )
                                    ],
                                  ),
                                )
                              : Container(),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: TextFormField(
                              focusNode: focusNode,
                              controller: textEditingController,
                              style: const TextStyle(
                                  color: Colors.white), // Text color
                              decoration: const InputDecoration(
                                hintText: "Post your reply",
                                labelStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize:
                                        14), // Text color// Placeholder text
                                hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16.0), // Placeholder color
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Colors.grey), // Bottom border color
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors
                                          .blue), // Bottom border color when focused
                                ),
                              ),
                            ),
                          ),
                          focusNode.hasFocus
                              ? Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: Row(
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              icon: const Icon(
                                                Icons.camera_alt_outlined,
                                                color: Colors.blue,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {},
                                              icon: const Icon(
                                                Icons.image_outlined,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          child: FilledButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateColor
                                                        .resolveWith((states) =>
                                                            Colors.blue)),
                                            child: Text("Reply"),
                                            onPressed: () {},
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : Container()
                        ],
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
