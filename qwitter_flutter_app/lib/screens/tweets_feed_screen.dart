import 'package:flutter/material.dart';
import 'package:qwitter_flutter_app/Components/layout/qwitter_app_bar.dart';
import 'package:qwitter_flutter_app/Components/tweet_card.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_floating_button.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_scrollup_button.dart';

class TweetFeedScreen extends StatefulWidget {
  const TweetFeedScreen({super.key});

  @override
  State<TweetFeedScreen> createState() => _TweetFeedScreenState();
}

class _TweetFeedScreenState extends State<TweetFeedScreen> {
  bool _isVisible = false;

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

  @override
  Widget build(BuildContext context) {
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
                      child: ListView.builder(
                        controller: _scrollController,
                        itemBuilder: (ctx, index) {
                          return Container(
                              child: TweetCard(
                            tweet_text:
                                "Hello in English, I'm trying to type some words to make my tweet looks good",
                            avatar_image: 'assets/images/user.jpg',
                            tweet_time: '2h',
                            tweet_user_name: 'Abdallah',
                            tweet_user_handle: '@abdallah_aali',
                            tweet_user_verified: true,
                            tweet_edited: true,
                            has_parent_tweet: true,
                          )
                                  .setTweetImages(
                                    [],
                                  )
                                  .setTweetStats(
                                    100,
                                    205,
                                    2365,
                                  )
                                  .setTweetParent(
                                      'Abdallah',
                                      '@abdallah_aali',
                                      "بالعربي بقا نشوف التنصيص بتاع اللغة العربية ازاي بقا يا عم الحاج",
                                      true,
                                      false,
                                      '2h',
                                      [
                                        'assets/images/tweet_img.jpg',
                                        'assets/images/tweet_img_2.jpg',
                                        'assets/images/tweet_img.jpg'
                                      ],
                                      'assets/images/user.jpg'));
                        },
                        itemCount: 10,
                      ),
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
                      return Container(
                          child: TweetCard(
                        tweet_text:
                            "Hello in English, I'm trying to type some words to make my tweet looks good",
                        avatar_image: 'assets/images/user.jpg',
                        tweet_time: '2h',
                        tweet_user_name: 'Abdallah',
                        tweet_user_handle: '@abdallah_aali',
                        tweet_user_verified: true,
                        tweet_edited: true,
                        has_parent_tweet: true,
                      )
                              .setTweetImages(
                                [],
                              )
                              .setTweetStats(
                                100,
                                205,
                                2365,
                              )
                              .setTweetParent(
                                  'Abdallah',
                                  '@abdallah_aali',
                                  "بالعربي بقا نشوف التنصيص بتاع اللغة العربية ازاي بقا يا عم الحاج",
                                  true,
                                  false,
                                  '2h',
                                  [
                                    'assets/images/tweet_img.jpg',
                                    'assets/images/tweet_img_2.jpg',
                                    'assets/images/tweet_img.jpg'
                                  ],
                                  'assets/images/user.jpg'));
                    },
                    itemCount: 10,
                  ),
                ),
              ],
            ),
          ),
          TweetFloatingButton(isVisible: _isVisible, closeFloatingButton: _closeFloatingButton, toggleVisibility: _toggleVisibility),
        ]),
      ),
    );
  }
}
