import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qwitter_flutter_app/Components/layout/qwitter_app_bar.dart';
import 'package:qwitter_flutter_app/Components/tweet_card.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_floating_button.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_scrollup_button.dart';
import 'package:qwitter_flutter_app/models/tweet.dart';
import 'package:qwitter_flutter_app/models/user.dart';
import 'package:qwitter_flutter_app/providers/timeline_tweets_provider.dart';
import 'package:qwitter_flutter_app/services/tweets_services.dart';

class TweetFeedScreen extends ConsumerStatefulWidget {
  const TweetFeedScreen({super.key});

  @override
  ConsumerState<TweetFeedScreen> createState() => _TweetFeedScreenState();
}

class _TweetFeedScreenState extends ConsumerState<TweetFeedScreen> {
  bool _isVisible = false;
  bool _isFetching = false;
  List<Tweet> tweets = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    TweetsServices.getTimeline().then((list) {
      ref.read(timelineTweetsProvider.notifier).setTimelineTweets(list);
    });
  }

  void _closeFloatingButton() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  void _toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  bool _scrollPressed = false;
  final ScrollController _scrollController = ScrollController();

  void _scrollPressedFunc() {
    _scrollController.animateTo(0,
        curve: Curves.linear, duration: Duration(milliseconds: 500));

    setState(() {
      _scrollPressed = true;
      print(_scrollPressed);
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Fetch new tweets when scrolled to the bottom
      setState(() {
        _isFetching = true;
      });

      // await Future.delayed(Duration(seconds: 10));
      _fetchNewTweets();
    }
  }

  Future<void> _fetchNewTweets() async {
    // Logic to fetch new tweets from the provider
    // Example: Call a function to fetch new tweets and update the tweet list
    final List<Tweet> newTweets = await TweetsServices.getTimeline();
    ref.read(timelineTweetsProvider.notifier).setTimelineTweets(newTweets);
    setState(() {
      _isFetching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ref.watch(timelineTweetsProvider.notifier).setTimelineTweets(tweets);
    tweets = ref.watch(timelineTweetsProvider);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Stack(children: [
          Scaffold(
            appBar: AppBar(
              title: const Text("X", style: TextStyle(color: Colors.white)),
              backgroundColor: Theme.of(context).primaryColor,
              elevation: Theme.of(context).appBarTheme.elevation,
              shape: Border(bottom: BorderSide(width: 0)),
              bottom: TabBar(
                indicatorColor: Colors.blue,
                unselectedLabelColor: Colors.grey[600],
                labelColor: Theme.of(context).secondaryHeaderColor,
                tabs: [
                  Tab(
                    child: Text(
                      "For you",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Following",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                Stack(
                  children: [
                    Container(
                      child:
                          ListView.builder(
                            controller: _scrollController,
                            itemBuilder: (ctx, index) {
                              return Container(
                                child: (index == tweets.length)
                                    ? Container(
                                        height: 100,
                                        width: double.infinity,
                                        child: Center(
                                            child: _isFetching
                                                ? CircularProgressIndicator(
                                                    color: Colors.white,
                                                    backgroundColor: Colors.blue,
                                                  )
                                                : Container()))
                                    : TweetCard(tweet: tweets[index]),
                              );
                            },
                            itemCount: tweets.length + 1,
                          ),
                      //     ListView.builder(
                      //   controller: _scrollController,
                      //   itemBuilder: (ctx, index) {
                      //     return Column(
                      //       children: [
                      //         TweetCard(
                      //           tweet: Tweet(
                      //               createdAt: '2021-09-01T00:00:00.000Z',
                      //               id: 1 + index,
                      //               hashtags: ["a", "b"],
                      //               isBookmarked: true,
                      //               isLiked: true,
                      //               isQuoted: false,
                      //               isRetweeted: true,
                      //               likesCount: 15,
                      //               media: [
                      //                 Media(
                      //                     "https://miro.medium.com/v2/resize:fit:1200/1*P_H_UpQahH0juwQpXWXnpQ.jpeg",
                      //                     "Image")
                      //               ],
                      //               mentions: [],
                      //               quoteToId: null,
                      //               quotesCount: 12,
                      //               repliesCount: 133,
                      //               replyToId: "1",
                      //               repostToId: null,
                      //               retweetUserName: "Abdallah",
                      //               retweetsCount: 12,
                      //               text:
                      //                   "Text for a retweet ${index.toString()}",
                      //               urls: [],
                      //               user: User(
                      //                   birthDate: "07",
                      //                   email: "abdallah@gmail.com",
                      //                   fullName: "Abdallah Ahmed",
                      //                   id: 1,
                      //                   isFollowed: true,
                      //                   password: "abdallah123",
                      //                   profilePicture: File(
                      //                       "https://pbs.twimg.com/profile_images/1723702722476613632/bzpNL81G_400x400.jpg"),
                      //                   username: "abdallah_aali",
                      //                   usernameSuggestions: [])),
                      //         ),
                      //         TweetCard(
                      //           tweet: Tweet(
                      //               createdAt: '2021-09-01T00:00:00.000Z',
                      //               id: 1 + index,
                      //               hashtags: ["a", "b"],
                      //               isBookmarked: true,
                      //               isLiked: true,
                      //               isQuoted: false,
                      //               isRetweeted: true,
                      //               likesCount: 15,
                      //               media: [
                      //                 Media(
                      //                     "https://miro.medium.com/v2/resize:fit:1200/1*P_H_UpQahH0juwQpXWXnpQ.jpeg",
                      //                     "Image"),
                      //                     Media(
                      //                     "https://miro.medium.com/v2/resize:fit:1200/1*P_H_UpQahH0juwQpXWXnpQ.jpeg",
                      //                     "Image")
                      //               ],
                      //               mentions: [],
                      //               quoteToId: null,
                      //               quotesCount: 12,
                      //               repliesCount: 133,
                      //               replyToId: "1",
                      //               repostToId: null,
                      //               retweetUserName: "Abdallah",
                      //               retweetsCount: 12,
                      //               text:
                      //                   "Text for a retweet ${index.toString()}",
                      //               urls: [],
                      //               user: User(
                      //                   birthDate: "07",
                      //                   email: "abdallah@gmail.com",
                      //                   fullName: "Abdallah Ahmed",
                      //                   id: 1,
                      //                   isFollowed: true,
                      //                   password: "abdallah123",
                      //                   profilePicture: File(
                      //                       "https://pbs.twimg.com/profile_images/1723702722476613632/bzpNL81G_400x400.jpg"),
                      //                   username: "abdallah_aali",
                      //                   usernameSuggestions: [])),
                      //         ),
                      //         TweetCard(
                      //                   tweet: Tweet(
                      //                       createdAt:
                      //                           '2021-09-01T00:00:00.000Z',
                      //                       id: 1 + index,
                      //                       hashtags: ["a", "b"],
                      //                       isBookmarked: true,
                      //                       isLiked: true,
                      //                       isQuoted: false,
                      //                       isRetweeted: true,
                      //                       likesCount: 15,
                      //                       media: [
                      //                         Media(
                      //                             "https://storage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4",
                      //                             "Video")
                      //                       ],
                      //                       mentions: [],
                      //                       quoteToId: null,
                      //                       quotesCount: 12,
                      //                       repliesCount: 133,
                      //                       replyToId:
                      //                           "1",
                      //                       repostToId: null,
                      //                       retweetUserName: "Abdallah",
                      //                       retweetsCount: 12,
                      //                       text:
                      //                           "Text for a retweet ${index.toString()}",
                      //                       urls: [],
                      //                       user: User(
                      //                           birthDate: "07",
                      //                           email: "abdallah@gmail.com",
                      //                           fullName: "Abdallah Ahmed",
                      //                           id: 1,
                      //                           isFollowed: true,
                      //                           password: "abdallah123",
                      //                           profilePicture: File(
                      //                               "https://pbs.twimg.com/profile_images/1723702722476613632/bzpNL81G_400x400.jpg"),
                      //                           username: "abdallah_aali",
                      //                           usernameSuggestions: [])),
                      //                 ),
                      //                 TweetCard(
                      //                   tweet: Tweet(
                      //                       createdAt:
                      //                           '2021-09-01T00:00:00.000Z',
                      //                       id: 1 + index,
                      //                       hashtags: ["a", "b"],
                      //                       isBookmarked: true,
                      //                       isLiked: true,
                      //                       isQuoted: false,
                      //                       isRetweeted: true,
                      //                       likesCount: 15,
                      //                       media: [
                      //                         Media(
                      //                             "https://miro.medium.com/v2/resize:fit:1200/1*P_H_UpQahH0juwQpXWXnpQ.jpeg",
                      //                             "Image"),
                      //                             Media(
                      //                             "https://miro.medium.com/v2/resize:fit:1200/1*P_H_UpQahH0juwQpXWXnpQ.jpeg",
                      //                             "Image"),
                      //                             Media(
                      //                             "https://miro.medium.com/v2/resize:fit:1200/1*P_H_UpQahH0juwQpXWXnpQ.jpeg",
                      //                             "Image")
                      //                       ],
                      //                       mentions: [],
                      //                       quoteToId: null,
                      //                       quotesCount: 12,
                      //                       repliesCount: 133,
                      //                       replyToId:
                      //                           "1",
                      //                       repostToId: null,
                      //                       retweetUserName: "Abdallah",
                      //                       retweetsCount: 12,
                      //                       text:
                      //                           "Text for a retweet ${index.toString()}",
                      //                       urls: [],
                      //                       user: User(
                      //                           birthDate: "07",
                      //                           email: "abdallah@gmail.com",
                      //                           fullName: "Abdallah Ahmed",
                      //                           id: 1,
                      //                           isFollowed: true,
                      //                           password: "abdallah123",
                      //                           profilePicture: File(
                      //                               "https://pbs.twimg.com/profile_images/1723702722476613632/bzpNL81G_400x400.jpg"),
                      //                           username: "abdallah_aali",
                      //                           usernameSuggestions: [])),
                      //                 )
                      //       ],
                      //     );
                      //   },
                      //   itemCount: 1,
                      // ),
                    ),
                    _scrollPressed
                        ? Container()
                        : TweetScrolUpButton(
                            scrollController: _scrollController,
                            scrollPressedFunc: () => _scrollPressedFunc(),
                          ),
                  ],
                ),
                Container(
                  child: ListView.builder(
                    itemBuilder: (ctx, index) {
                      // return Container(
                      //     child: TweetCard(
                      //   tweet_text:
                      //       "Hello in English, I'm trying to type some words to make my tweet looks good",
                      //   avatar_image: 'assets/images/user.jpg',
                      //   tweet_time: '2h',
                      //   tweet_user_name: 'Abdallah',
                      //   tweet_user_handle: '@abdallah_aali',
                      //   tweet_user_verified: true,
                      //   tweet_edited: true,
                      //   has_parent_tweet: true,
                      // )
                      //         .setTweetImages(
                      //           [],
                      //         )
                      //         .setTweetStats(
                      //           100,
                      //           205,
                      //           2365,
                      //         )
                      //         .setTweetParent(
                      //             'Abdallah',
                      //             '@abdallah_aali',
                      //             "بالعربي بقا نشوف التنصيص بتاع اللغة العربية ازاي بقا يا عم الحاج",
                      //             true,
                      //             false,
                      //             '2h',
                      //             [
                      //               'assets/images/tweet_img.jpg',
                      //               'assets/images/tweet_img_2.jpg',
                      //               'assets/images/tweet_img.jpg'
                      //             ],
                      //             'assets/images/user.jpg'));
                    },
                    itemCount: 10,
                  ),
                ),
              ],
            ),
          ),
          TweetFloatingButton(
              isVisible: _isVisible,
              closeFloatingButton: _closeFloatingButton,
              toggleVisibility: _toggleVisibility),
        ]),
      ),
    );
  }
}
