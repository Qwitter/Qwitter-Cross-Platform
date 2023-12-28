import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/primary_button.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_avatar.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_body.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_header.dart';
import 'package:qwitter_flutter_app/components/tweet_card.dart';
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:qwitter_flutter_app/models/tweet.dart';
import 'package:qwitter_flutter_app/providers/for_you_tweets_provider.dart';
import 'package:qwitter_flutter_app/providers/timeline_tweets_provider.dart';
import 'package:qwitter_flutter_app/screens/tweets/add_tweet_screen.dart';
import 'package:qwitter_flutter_app/screens/tweets/likers_screen.dart';
import 'package:qwitter_flutter_app/screens/tweets/retweeters_screen.dart';
import 'package:qwitter_flutter_app/screens/tweets/tweet_media_viewer_screen.dart';
import 'package:qwitter_flutter_app/screens/tweets/tweets_feed_screen.dart';
import 'package:qwitter_flutter_app/services/tweets_services.dart';
import 'package:qwitter_flutter_app/utils/date_humanizer.dart';

class TweetDetailsScreen extends ConsumerStatefulWidget {
  final Tweet tweet;
  final pushMediaViewerFunc;

  const TweetDetailsScreen(
      {super.key, required this.tweet, this.pushMediaViewerFunc});

  @override
  ConsumerState<TweetDetailsScreen> createState() => _TweetDetailsScreenState();
}

class _TweetDetailsScreenState extends ConsumerState<TweetDetailsScreen> {
  late GlobalKey firstTweetKey;
  late GlobalKey secondTweetKey;
  TextEditingController textEditingController = TextEditingController();
  final focusNode = FocusNode();
  VoidCallback? buttonFunction;
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
  void initState() {
    super.initState();
    firstTweetKey = GlobalKey();
    secondTweetKey = GlobalKey();
    print("Token : " + AppUser().token.toString());
    TweetsServices.getTweetReplies(widget.tweet).then((replies) {
      print("reppp: " + replies.length.toString());
      setState(() {
        ref.read(widget.tweet.provider.notifier).resetReplies(replies);
      });
    }).onError((error, stackTrace) {
      //print(error);
    });
  }

  void _makeRepost(tweetProvider) {
    setState(() {
      // ref.read(tweetProvider.provider.notifier).toggleRetweet();
      String retweeted_id = TweetsServices.makeRepost(ref, tweetProvider);
      tweetProvider.currentUserRetweetId = retweeted_id;
      tweetProvider.retweetsCount = tweetProvider.retweetsCount! + 1;
      TweetsServices.getTimeline(1).then((tweets) =>
          ref.read(timelineTweetsProvider.notifier).setTimelineTweets(tweets));
      TweetsServices.getForYou(1).then((tweets) =>
          ref.read(forYouTweetsProvider.notifier).setForYouTweets(tweets));
    });
  }

  void _openRepostModal() {
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
                        if (widget.tweet.currentUserRetweetId != null) {
                          TweetsServices.deleteRetweet(
                              ref, context, widget.tweet);
                          setState(() {
                            ref
                                .read(timelineTweetsProvider.notifier)
                                .removeTweet(widget.tweet);
                            ref
                                .read(forYouTweetsProvider.notifier)
                                .removeTweet(widget.tweet);
                          });
                        } else {
                          Navigator.pop(context);
                          _makeRepost(widget.tweet);
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
                        setState(() {
                          TweetsServices.makeRepost(ref, widget.tweet);
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

  void _makeFollow(tweetProvider) {
    setState(() {
      TweetsServices.makeFollow(ref, tweetProvider);
    });
  }

  Future<void> _onRefresh() async {
    // Simulating a refresh action with a delay
    final List<Tweet> newTweets =
        await TweetsServices.getTweetReplies(widget.tweet);
    setState(() {
      print(newTweets.length);
      ref.read(widget.tweet.provider.notifier).resetReplies(newTweets);
      print('Refreshed!');
      print("token : " + AppUser().token.toString());
    });
  }

  int getInitialVerticalDistance() {
    final RenderBox? firstBox =
        firstTweetKey.currentContext?.findRenderObject() as RenderBox?;
    final Offset? firstTweetPosition =
        firstBox != null ? firstBox.localToGlobal(Offset.zero) : null;

    final double verticalDistance = firstTweetPosition?.dy ?? 0;
    return verticalDistance.toInt();
  }

  int calculateVerticalDistance() {
    final RenderBox? firstBox =
        firstTweetKey.currentContext?.findRenderObject() as RenderBox?;
    final RenderBox? secondBox =
        secondTweetKey.currentContext?.findRenderObject() as RenderBox?;

    final Offset? firstTweetPosition =
        firstBox != null ? firstBox.localToGlobal(Offset.zero) : null;
    final Offset? secondTweetPosition =
        secondBox != null ? secondBox.localToGlobal(Offset.zero) : null;

    if (firstTweetPosition == null || secondTweetPosition == null) {
      return 0; // Handle case where one or both positions are unavailable
    }

    final double verticalDistance =
        (secondTweetPosition.dy - firstTweetPosition.dy).abs();
    return verticalDistance.toInt();
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
                            onPressed: () {
                              Navigator.pop(context);
                              setState(() {
                                TweetsServices.deleteTweet(
                                    ref, context, tweetProvider);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TweetFeedScreen()));
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

  Widget build(BuildContext context) {
    final tweetProvider = ref.watch(widget.tweet.provider);
    final lineHeight = calculateVerticalDistance().toDouble();
    textEditingController.addListener(() {
      if (textEditingController.text.isEmpty) {
        setState(() {
          buttonFunction = null;
        });
      } else {
        setState(() {
          buttonFunction = () {
            TweetsServices.makeReply(
                    ref, tweetProvider, textEditingController.text)
                .then((tweet) {
              final t = Tweet.fromJson(tweet['tweet']);
              tweetProvider.replies = [t, ...tweetProvider.replies];
              ref.read(tweetProvider.provider.notifier).setReplies([t]);
              // tweetProvider.repliesCount = tweetProvider.repliesCount ?? 0 +  1;
            });

            textEditingController.text = "";
          };
        });
      }
    });
    print(tweetProvider.id);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, tweetProvider);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:
              Theme.of(context).appBarTheme.copyWith().backgroundColor,
          title: const Text(
            "Post",
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: Theme.of(context).iconTheme,
          elevation: 1,
        ),
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: Container(
            height: MediaQuery.of(context).size.height - 100,
            child: Stack(
              children: [
                ListView.builder(
                  itemBuilder: (ctx, index) {
                    print("replies" + tweetProvider.replies.toString());
                    if (tweetProvider.replyToId != null &&
                        tweetProvider.repliedToTweet != null) {
                      print("object");
                      print(tweetProvider.repliedToTweet!.text);
                    }
                    return index == 0
                        ? Column(
                            children: [
                              tweetProvider.replyToId != null
                                  ? tweetProvider.repliedToTweet != null
                                      ? Container(
                                          key: firstTweetKey,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          // alignment: Alignment.topLeft,
                                          alignment: Alignment.center,
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  TweetAvatar(
                                                    avatar: tweetProvider
                                                        .repliedToTweet!
                                                        .user!
                                                        .profilePicture!
                                                        .path,
                                                    username: tweetProvider
                                                        .repliedToTweet!
                                                        .user!
                                                        .username!,
                                                  ),
                                                  Expanded(
                                                    child:
                                                        TweetHeader.stretched(
                                                      tweet: tweetProvider
                                                          .repliedToTweet!,
                                                      opentweetMenuModal: () {
                                                        _opentweetMenuModal(
                                                            tweetProvider
                                                                .repliedToTweet!);
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            20, 0, 0, 0),
                                                    child: Container(
                                                      width: 3,
                                                      height: lineHeight > 100.0
                                                          ? lineHeight - 100.0
                                                          : lineHeight,
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              20, 0, 0, 0),
                                                      child: TweetBody(
                                                        tweet: widget.tweet
                                                            .repliedToTweet!,
                                                        pushMediaViewerFunc:
                                                            pushMediaViewer,
                                                        stretched: true,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: EdgeInsets.fromLTRB(
                                              20, 10, 20, 0),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.fromLTRB(
                                                20, 10, 20, 10),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              color: Colors.blueGrey[900],
                                            ),
                                            child: Text(
                                              "The original tweet was deleted",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        )
                                  : SizedBox(),
                              SizedBox(
                                height: tweetProvider.replyToId != null &&
                                        tweetProvider.repliedToTweet != null
                                    ? 20
                                    : 0,
                              ),
                              Container(
                                key: secondTweetKey,
                                // alignment: Alignment.topLeft,
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        TweetAvatar(
                                          avatar: widget
                                              .tweet.user!.profilePicture!.path,
                                          username:
                                              widget.tweet.user!.username!,
                                        ),
                                        Expanded(
                                          child: TweetHeader.stretched(
                                            tweet: tweetProvider,
                                            opentweetMenuModal: () {
                                              _opentweetMenuModal(
                                                  tweetProvider);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    TweetBody(
                                      tweet: widget.tweet,
                                      pushMediaViewerFunc: pushMediaViewer,
                                      stretched: true,
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.fromLTRB(15, 20, 15, 0),
                                      child: Row(
                                        children: [
                                          Text(
                                            DateHelper.extractTime(
                                                tweetProvider.createdAt!),
                                            style: TextStyle(
                                                color: Colors.grey[600]),
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
                                            DateHelper.extractFullDate(
                                                tweetProvider.createdAt!),
                                            style: TextStyle(
                                                color: Colors.grey[600]),
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
                                            "45K",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "Views",
                                            style: TextStyle(
                                                color: Colors.grey[600]),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey[900]!,
                                              width: 1),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                top: BorderSide(
                                                    color: Colors.grey[900]!,
                                                    width: 1),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 10 +
                                                      10 *
                                                          (tweetProvider
                                                                  .retweetsCount
                                                                  .toString()
                                                                  .length)
                                                              .toDouble(),
                                                  child: TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              RetweetersScreen(
                                                                  tweetId: tweetProvider
                                                                          .repostToId ??
                                                                      tweetProvider
                                                                          .id!),
                                                        ),
                                                      );
                                                    },
                                                    child: Text(
                                                      tweetProvider
                                                          .retweetsCount
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    style: ButtonStyle(
                                                      alignment:
                                                          Alignment.center,
                                                      // overlayColor: MaterialStateProperty.all(Colors.transparent),
                                                      padding:
                                                          MaterialStateProperty
                                                              .all(EdgeInsets
                                                                  .zero),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  "Reposts",
                                                  style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 16),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Container(
                                                  width: 10 +
                                                      10 *
                                                          ("41".length)
                                                              .toDouble(),
                                                  child: TextButton(
                                                    onPressed: () {},
                                                    child: Text(
                                                      "41",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    style: ButtonStyle(
                                                      alignment:
                                                          Alignment.center,
                                                      // overlayColor: MaterialStateProperty.all(Colors.transparent),
                                                      padding:
                                                          MaterialStateProperty
                                                              .all(EdgeInsets
                                                                  .zero),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  "Quotes",
                                                  style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 16),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Container(
                                                  width: 10 +
                                                      10 *
                                                          (tweetProvider
                                                                  .likesCount
                                                                  .toString()
                                                                  .length)
                                                              .toDouble(),
                                                  child: TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              LikersScreen(
                                                                  tweetId: tweetProvider
                                                                          .repostToId ??
                                                                      tweetProvider
                                                                          .id!),
                                                        ),
                                                      );
                                                    },
                                                    child: Text(
                                                      tweetProvider.likesCount
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    style: ButtonStyle(
                                                      alignment:
                                                          Alignment.center,
                                                      // overlayColor: MaterialStateProperty.all(Colors.transparent),
                                                      padding:
                                                          MaterialStateProperty
                                                              .all(EdgeInsets
                                                                  .zero),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  "Likes",
                                                  style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 16),
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
                                                top: BorderSide(
                                                    color: Colors.grey[900]!,
                                                    width: 1),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 10 +
                                                      10 *
                                                          ("41".length)
                                                              .toDouble(),
                                                  child: TextButton(
                                                    onPressed: () {},
                                                    child: Text(
                                                      "41",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    style: ButtonStyle(
                                                      alignment:
                                                          Alignment.center,
                                                      // overlayColor: MaterialStateProperty.all(Colors.transparent),
                                                      padding:
                                                          MaterialStateProperty
                                                              .all(EdgeInsets
                                                                  .zero),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  "Bookmarks",
                                                  style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 16),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                  top: BorderSide(
                                                      color: Colors.grey[900]!,
                                                      width: 1)),
                                            ),
                                            child: Row(children: [
                                              Expanded(
                                                child: IconButton(
                                                  icon: Icon(
                                                    Icons.chat_bubble_outline,
                                                    color: Colors.grey[600],
                                                    size: 20,
                                                  ),
                                                  onPressed: () {
                                                    FocusScope.of(context)
                                                        .requestFocus(
                                                            focusNode);
                                                  },
                                                ),
                                              ),
                                              Expanded(
                                                child: IconButton(
                                                  icon: Icon(
                                                    Icons.repeat_outlined,
                                                    color: tweetProvider
                                                                .currentUserRetweetId !=
                                                            null
                                                        ? Colors.green
                                                        : Colors.grey[600],
                                                    size: 22,
                                                  ),
                                                  onPressed: _openRepostModal,
                                                ),
                                              ),
                                              Expanded(
                                                child: IconButton(
                                                  icon: Icon(
                                                    tweetProvider.isLiked!
                                                        ? Icons.favorite
                                                        : Icons.favorite_border,
                                                    color:
                                                        tweetProvider.isLiked!
                                                            ? Colors.pink
                                                            : Colors.grey[600],
                                                    size: 22,
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      TweetsServices.makeLike(
                                                          ref, widget.tweet);
                                                    });
                                                  },
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
                                  ],
                                ),
                              ),
                            ],
                          )
                        : index == tweetProvider.replies.length + 1
                            ? SizedBox(
                                height: focusNode.hasFocus ? 150 : 80,
                              )
                            : TweetCard(
                                tweet: tweetProvider.replies[index - 1],
                                removeReply: () {
                                  Navigator.pop(context);
                                  setState(() {
                                    TweetsServices.deleteTweet(
                                        ref, context, tweetProvider);
                                    ref
                                        .read(tweetProvider.provider.notifier)
                                        .removeTweet(tweetProvider);
                                  });
                                });
                  },
                  itemCount: tweetProvider.replies.length + 2,
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border(
                        top: BorderSide(
                          color: Colors.grey[800]!,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        focusNode.hasFocus
                            ? Container(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Text(
                                      "Replying to ",
                                      style: TextStyle(color: Colors.grey[500]),
                                    ),
                                    Text(
                                      "@" + widget.tweet.user!.username!,
                                      style: TextStyle(color: Colors.blue),
                                    )
                                  ],
                                ),
                              )
                            : Container(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                    color: Colors.grey), // Bottom border color
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
                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Row(
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              focusNode.unfocus();
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddTweetScreen(
                                                    replyToTweetId:
                                                        widget.tweet.id!,
                                                    tweetText:
                                                        textEditingController
                                                            .text,
                                                  ),
                                                ),
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.camera_alt_outlined,
                                              color: Colors.blue,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              print(
                                                  "tweetID:  ${widget.tweet.id}");

                                              print(
                                                  "text:  ${textEditingController.text}");
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddTweetScreen(
                                                    replyToTweetId:
                                                        widget.tweet.id!,
                                                    tweetText:
                                                        textEditingController
                                                            .text,
                                                  ),
                                                ),
                                              );
                                            },
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
                                        child: PrimaryButton(
                                          buttonSize: Size(90, 30),
                                          onPressed: buttonFunction,
                                          text: 'Reply',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class TweetsConnectorPainter extends CustomPainter {
//   final int y1, y2;
//   TweetsConnectorPainter({required this.y1, required this.y2});

//   @override
//   void paint(Canvas canvas, Size size) {
//     print("y1");
//     print(y1.toDouble());
//     print("y2");
//     print(y2.toDouble());
//     final paint = Paint()
//       ..color = Colors.grey // Set the line color
//       ..strokeWidth = 2; // Set the line thickness

//     final startPoint = Offset(30, -20); // Set the starting point of the line
//     final endPoint = Offset(
//         30, (y2).toDouble()); // Set the ending point of the line

//     canvas.drawLine(startPoint, endPoint, paint); // Draw the line
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }
