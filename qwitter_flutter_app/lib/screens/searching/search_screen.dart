import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qwitter_flutter_app/components/tweet_card.dart';
import 'package:qwitter_flutter_app/components/user_card.dart';
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:qwitter_flutter_app/models/tweet.dart';
import 'package:qwitter_flutter_app/screens/searching/searching_user_screen.dart';
import 'package:qwitter_flutter_app/services/tweets_services.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.hastag, required this.query});
  final String query;
  final String hastag;

  @override
  State<SearchScreen> createState() {
    return _SearchScreenState();
  }
}

class _SearchScreenState extends State<SearchScreen> {
  late int page;
  late ScrollController _scrollController;
  List? _usersList = null;
  List<Tweet>? _tweets = null;

  @override
  void initState() {
    page = 1;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      TweetsServices.getSearchTweets(widget.query, widget.hastag, page)
          .then((tweets) {
        setState(() {
          _tweets = tweets;
        });
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

  Future<void> _fetchTweets(int page) async {
    TweetsServices.getSearchTweets(widget.query, widget.hastag, page)
        .then((tweets) {
      setState(() {
        if (_tweets != null) {
          _tweets!.addAll(tweets);
        } else {
          _tweets = tweets;
        }
      });
    });
  }

  Future<List<dynamic>> searchUser(String data) async {
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
      List<dynamic> users = jsonDecode(response.body)['users'];

      return users;
    } else {
      return [];
    }
  }



  @override
  Widget build(BuildContext context) {

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
              (_tweets != null)
                  ? CustomScrollView(controller: _scrollController, slivers: [
                      SliverList.builder(
                        itemBuilder: (context, index) {
                          return TweetCard(
                            tweet: _tweets![index],
                          );
                        },
                        itemCount: _tweets!.length,
                      )
                    ])
                  : const Center(
                  child: SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      //// need more work
                      color: Colors.white,
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ),
              ( _usersList != null)
                  ? CustomScrollView(
                      slivers: [
                        SliverList.builder(
                          itemBuilder: (context, index) {
                            return Container(
                                padding: EdgeInsets.only(left: 15, right: 15),
                                child: UserCard(
                                  isFollowed: _usersList![index]
                                          ["isFollowing"] ??
                                      false,
                                  userData: _usersList![index],
                                ));
                          },
                          itemCount: _usersList!.length,
                        )
                      ],
                    )
                  : const Center(
                  child: SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      //// need more work
                      color: Colors.white,
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ),
            ],
          )),
    );
  }
}
