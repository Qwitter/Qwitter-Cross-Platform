import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qwitter_flutter_app/components/profile/follow_button.dart';
import 'package:qwitter_flutter_app/components/profile/profile_card.dart';
import 'package:qwitter_flutter_app/components/tweet_card.dart';
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:qwitter_flutter_app/models/tweet.dart';
import 'package:qwitter_flutter_app/models/user.dart';
import 'package:qwitter_flutter_app/providers/search_tweets_provider.dart';
import 'package:qwitter_flutter_app/screens/searching/searching_user_screen.dart';
import 'package:qwitter_flutter_app/services/tweets_services.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key, required this.hastag, required this.query});
  final String query;
  final String hastag;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _SearchScreenState();
  }
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late int page;
  late ScrollController _scrollController;
  List<User>? _usersList = null;
  @override
  void initState() {
    page = 1;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(searchTweetsProvider.notifier).reset();
      TweetsServices.getSearchTweets(widget.query, widget.hastag, page)
          .then((tweets) {
        ref.read(searchTweetsProvider.notifier).updateSearchTweets(tweets);
      });
      searchUser(widget.query).then((value) {
        setState(() {
        _usersList = value;
        });
      });
      page++;
    });
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchTweets(page);
      page++;
    }
    print(page);
  }

  Future<bool> _onPop() async {
    ref.read(searchTweetsProvider.notifier).reset();
    return true;
  }

  Future<void> _fetchTweets(int page) async {
    List<Tweet> newTweets =
        await TweetsServices.getSearchTweets(widget.query, widget.hastag, page);
    ref.read(searchTweetsProvider.notifier).updateSearchTweets(newTweets);
  }

  Future<List<User>> searchUser(String data) async {
    final url = Uri.parse(
        'http://back.qwitter.cloudns.org:3000/api/v1/user/search?q=$data');

    final Map<String, String> cookies = {
      'qwitter_jwt': 'Bearer ${AppUser().getToken}',
    };
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Cookie': cookies.entries
          .map((entry) => '${entry.key}=${entry.value}')
          .join('; '),
    });

    if (response.statusCode == 200) {
      List<dynamic> result = jsonDecode(response.body)['users'];
      List<User> users = result.map((user) => User.fromJson(user)).toList();
      return users;
    } else {
      return [];
    }
  }

  Future<void> _toggleFollowState(User user) async {
    String _baseUrl = 'http://back.qwitter.cloudns.org:3000';
    Uri url = Uri.parse('$_baseUrl/api/v1/user/follow/${user.username}');
    AppUser appUser = AppUser();

    final Map<String, String> cookies = {
      'qwitter_jwt': 'Bearer ${appUser.getToken}',
    };
    if (user.isFollowed == false) {
      http.Response response = await http.post(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'authorization': 'Bearer ${appUser.token}',
        'Cookie': cookies.entries
            .map((entry) => '${entry.key}=${entry.value}')
            .join('; '),
      });

      if (response.statusCode == 200) {
        print("follow done successfully");
        setState(() {
          user.isFollowed = true;
        });
      } else {
        print(
            "an error occured when trying to follow ${user.username} and the status code : ${response.statusCode}");
      }
    } else {
      http.Response response = await http.delete(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'authorization': 'Bearer ${appUser.token}',
        'Cookie': cookies.entries
            .map((entry) => '${entry.key}=${entry.value}')
            .join('; '),
      });

      if (response.statusCode == 200) {
        print("unfollow done");
        setState(() {
          user.isFollowed = false;
        });
      } else {
        print(
            "an error occured when trying to unfollow ${user.username} and the status code : ${response.statusCode}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Tweet>? tweets = ref.watch(searchTweetsProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                ref.read(searchTweetsProvider.notifier).reset();
                Navigator.of(context).pop();
              },
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.tune,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.more_vert_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ],
            title: Container(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SearchUserScreen()));
                },
                style: ButtonStyle(
                  alignment: Alignment.bottomLeft,
                  backgroundColor:
                      MaterialStatePropertyAll(Colors.grey.shade800),
                  foregroundColor:
                      MaterialStatePropertyAll(Colors.grey.shade300),
                  overlayColor:
                      const MaterialStatePropertyAll(Colors.transparent),
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
                child: Text(
                  widget.query.isEmpty ? widget.hastag : widget.query,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
            bottom: TabBar(
              tabs: const [
                Tab(
                  text: 'Top',
                ),
                Tab(
                  text: 'People',
                ),
              ],
              // dividerHeight: 0.3,
              dividerColor: Colors.grey.shade600,
              labelStyle:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              indicatorColor: Colors.blue,
              indicatorSize: TabBarIndicatorSize.tab,
              overlayColor: const MaterialStatePropertyAll(Colors.transparent),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey.shade500,
              isScrollable: false,
              tabAlignment: TabAlignment.fill,
              labelPadding: const EdgeInsets.symmetric(horizontal: 23),
              indicatorPadding: const EdgeInsets.symmetric(horizontal: 10),
            ),
          ),
          body: TabBarView(
            children: [
              (tweets != null)
                  ? WillPopScope(
                      onWillPop: _onPop,
                      child: CustomScrollView(
                          controller: _scrollController,
                          slivers: [
                            SliverList.builder(
                              itemBuilder: (context, index) {
                                return TweetCard(
                                  tweet: tweets[index],
                                );
                              },
                              itemCount: tweets.length,
                            )
                          ]),
                    )
                  : const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(),
                      ),
                    ),
              (_usersList != null)
                  ? CustomScrollView(
                      slivers: [
                        SliverList.builder(
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.all(15),
                              child: Column(children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 21,
                                      backgroundImage: (_usersList![index]
                                              .profilePicture!
                                              .path
                                              .isEmpty
                                          ? const AssetImage(
                                              "assets/images/def.jpg")
                                          : NetworkImage(_usersList![index]
                                              .profilePicture!
                                              .path) as ImageProvider),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,

                                      children: [
                                        Text(
                                          "${_usersList![index].fullName}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          "@${_usersList![index].username}",
                                          style: TextStyle(
                                              color: Colors.grey.shade500,
                                              fontSize: 15,
                                              height: 1,
                                              fontWeight: FontWeight.w400),
                                        )
                                      ],
                                    ),
                                    Spacer(),

                                    if(_usersList![index].username!=AppUser().username)
                                    FollowButton(
                                        isFollowed:
                                            _usersList![index].isFollowed!,
                                        onTap: () async {_toggleFollowState(_usersList![index]);}),
                                  ],
                                )
                              ]),
                            );
                          },
                          itemCount: _usersList!.length,
                        )
                      ],
                    )
                  : const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(),
                      ),
                    ),
            ],
          )),
    );
  }
}
