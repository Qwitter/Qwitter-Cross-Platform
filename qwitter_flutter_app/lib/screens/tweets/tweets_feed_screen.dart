import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_app_bar.dart';
import 'package:qwitter_flutter_app/Components/tweet_card.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_bottom_navigation.dart';
import 'package:qwitter_flutter_app/components/layout/sidebar/main_drawer.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_floating_button.dart';
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:qwitter_flutter_app/models/tweet.dart';
import 'package:qwitter_flutter_app/providers/for_you_tweets_provider.dart';
import 'package:qwitter_flutter_app/providers/timeline_tweets_provider.dart';
import 'package:qwitter_flutter_app/services/tweets_services.dart';

class TweetFeedScreen extends ConsumerStatefulWidget {
  const TweetFeedScreen({super.key});

  @override
  ConsumerState<TweetFeedScreen> createState() => _TweetFeedScreenState();
}

class _TweetFeedScreenState extends ConsumerState<TweetFeedScreen> {
  int page = 1;
  int pageForYou = 1;
  bool _isVisible = false;
  bool _isFetching = false;
  List<Tweet> tweets = [];
  List<Tweet> tweetsForYou = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController(),
      _scrollControllerForYou = ScrollController();
  // final ScrollController _scrollControllerForYou = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _scrollControllerForYou.addListener(_scrollListenerForYou);
    TweetsServices.getTimeline(page).then((list) {
      print(list.length);
      ref.read(timelineTweetsProvider.notifier).resetTimelineTweets(list);
    }).onError((error, stackTrace) {
      //print(error);
    });

    TweetsServices.getForYou(pageForYou).then((list) {
      ref.read(forYouTweetsProvider.notifier).resetForYouTweets(list);
    });
  }

  void _incrementPage() {
    setState(() {
      page++;
    });
  }

  void _incrementPageForYou() {
    setState(() {
      pageForYou++;
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

  // bool _scrollPressed = false;

  // void _scrollPressedFunc() {
  //   _scrollController.animateTo(0,
  //       curve: Curves.linear, duration: Duration(milliseconds: 500));

  //   setState(() {
  //     _scrollPressed = true;
  //     // //print(_scrollPressed);
  //   });
  // }

  void _scrollListener() {
    // print("${_scrollController.position.pixels} - ${_scrollController.position.maxScrollExtent}");
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Fetch new tweets when scrolled to the bottom
      setState(() {
        _isFetching = true;
      });
      // //print("Page: " + page.toString());

      // await Future.delayed(Duration(seconds: 10));

      _incrementPage();
      _fetchNewTweets(page);
    }
  }

  void _scrollListenerForYou() {
    // print("${_scrollControllerForYou.position.pixels} - ${_scrollControllerForYou.position.maxScrollExtent}");
    if (_scrollControllerForYou.position.pixels ==
        _scrollControllerForYou.position.maxScrollExtent) {
      // Fetch new tweets when scrolled to the bottom
      setState(() {
        _isFetching = true;
      });
      print("Page: " + page.toString());

      // await Future.delayed(Duration(seconds: 10));

      _incrementPageForYou();
      _fetchNewTweetsForYou(pageForYou);
    }
  }

  Future<void> _fetchNewTweets(page) async {
    final List<Tweet> newTweets = await TweetsServices.getTimeline(page);
    print(newTweets.length);
    ref.read(timelineTweetsProvider.notifier).setTimelineTweets(newTweets);
    setState(() {
      _isFetching = false;
    });
  }

  Future<void> _fetchNewTweetsForYou(page) async {
    final List<Tweet> newTweets = await TweetsServices.getForYou(page);
    print(newTweets.length);
    ref.read(forYouTweetsProvider.notifier).setForYouTweets(newTweets);
    setState(() {
      _isFetching = false;
    });
  }

  Future<void> _onRefresh() async {
    // Simulating a refresh action with a delay
    final List<Tweet> newTweets = await TweetsServices.getTimeline(1);
    print(newTweets.length);
    ref.read(timelineTweetsProvider.notifier).resetTimelineTweets(newTweets);
    setState(() {
      _isFetching = false;
    });
    print('Refreshed!');
    print("token : " + AppUser().token.toString());
  }

  Future<void> _onRefreshForYou() async {
    // Simulating a refresh action with a delay
    final List<Tweet> newTweets = await TweetsServices.getForYou(1);
    print(newTweets.length);
    ref.read(forYouTweetsProvider.notifier).resetForYouTweets(newTweets);
    setState(() {
      _isFetching = false;
    });
    print('Refreshed!');
    print("token : " + AppUser().token.toString());
  }

  @override
  Widget build(BuildContext context) {
    // ref.watch(timelineTweetsProvider.notifier).setTimelineTweets(tweets);
    tweets = ref.watch(timelineTweetsProvider);
    tweetsForYou = ref.watch(forYouTweetsProvider);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Stack(children: [
          Scaffold(
            key: _scaffoldKey,
            drawer: const MainDrawer(),
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(100),
              child: QwitterAppBar(
                autoImplyLeading: false,
                scaffoldKey: _scaffoldKey,
                bottomWidget: const TabBar(
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
            ),
            body: TabBarView(
              children: [
                Stack(
                  children: [
                    RefreshIndicator(
                      onRefresh: _onRefreshForYou,
                      color: Colors.blue,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          controller: _scrollControllerForYou,
                          itemBuilder: (ctx, index) {
                            return Container(
                              child: (index == tweetsForYou.length)
                                  ? SizedBox(
                                      height: 100,
                                      width: double.infinity,
                                      child: Center(
                                          child: _isFetching
                                              ? CircularProgressIndicator(
                                                  color: Colors.white,
                                                  backgroundColor: Colors.blue,
                                                )
                                              : Container()))
                                  : TweetCard(tweet: tweetsForYou[index]),
                            );
                          },
                          itemCount: tweetsForYou.length + 1,
                        ),
                      ),
                    )

                    // _scrollPressed
                    //     ? Container()
                    //     : TweetScrolUpButton(
                    //         scrollController: _scrollController,
                    //         scrollPressedFunc: () => _scrollPressedFunc(),
                    //       ),
                  ],
                ),
                RefreshIndicator(
                  onRefresh: _onRefresh,
                  color: Colors.blue,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
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
