import 'dart:convert';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/secondary_button.dart';
import 'package:qwitter_flutter_app/components/profile/edit_profile_button.dart';
import 'package:qwitter_flutter_app/components/profile/follow_button.dart';
import 'package:qwitter_flutter_app/components/profile/notifications_button.dart';
import 'package:qwitter_flutter_app/components/tweet_card.dart';
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:qwitter_flutter_app/models/tweet.dart';
import 'package:qwitter_flutter_app/models/user.dart';
import 'package:qwitter_flutter_app/providers/profile_tweets_provider.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:http/http.dart' as http;
import 'package:qwitter_flutter_app/services/tweets_services.dart';
import 'side_drop_down_menu.dart';

class ProfileDetailsScreen extends ConsumerStatefulWidget {
  const ProfileDetailsScreen({super.key, required this.username});
  final String username;
  final bool _mainAppUser = true;
  final bool _isFollowed = true;
  final bool _isNotificationsEnabled = true;

  @override
  ConsumerState<ProfileDetailsScreen> createState() =>
      _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends ConsumerState<ProfileDetailsScreen>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late TabController _tabController;
  bool _scrollingView = false;
  double _imgRaduis = 35;
  late User user;
  final AppUser appUser = AppUser();
  List<int> pages = [1, 1, 1, 1];
  // late ScrollController _postedTweetsScrollController;
  // late ScrollController _likedTweetsScrollController;
  // late ScrollController _repliedTweetsScrollController;
  // late ScrollController _mediaTweetsScrollController;
  // double _postedTweetsScrollOffset=0;
  // double _likedTweetsScrollOffset=0;
  // double _repliedTweetsScrollOffset=0;
  // double _mediaTweetsScrollOffset=0;

  @override
  void initState() {
    super.initState();
    // _postedTweetsScrollController = ScrollController();
    // _likedTweetsScrollController = ScrollController();
    // _mediaTweetsScrollController = ScrollController();
    // _repliedTweetsScrollController = ScrollController();

    _scrollController = ScrollController();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
    _scrollController.addListener(_scrollListener);
    _tabController.addListener(_changeTab);
    //
    TweetsServices.getTweetsPostedByUser(widget.username, pages[0])
        .then((list) {
      ref.read(profileTweetsProvider.notifier).updatePostedTweets(list);
      print(list);
      pages[0]++;
    });
  }

  void _changeTab() {
    print("changing tabs");
    _fetchNewTweets(_tabController.index, pages[_tabController.index]);
    pages[_tabController.index]++;
    print(pages[_tabController.index]);
    
  }

  Future<User?> _getUserData() async {
    /////// if(user.username==appUser.username) no need to request the data
    String _baseUrl = 'http://qwitterback.cloudns.org:3000';
    Uri url = Uri.parse('$_baseUrl/api/v1/user/${widget.username}');
    http.Response response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'authorization': 'Bearer ${appUser.token}',
    });

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      return User.fromJson(jsonBody);
    }
    return null;
  }

  Future<void> _fetchNewTweets(int tabIndex, int page) async {
    List<Tweet> newTweets;
    if (tabIndex == 0) {
      newTweets =
          await TweetsServices.getTweetsPostedByUser(user.username!, page);
      ref.read(profileTweetsProvider.notifier).updatePostedTweets(newTweets);
    } else if (tabIndex == 1) {
      newTweets =
          await TweetsServices.getRepliesSectionTweets(user.username!, page);
      ref.read(profileTweetsProvider.notifier).updateRepliedTweets(newTweets);
    } else if (tabIndex == 2) {
      newTweets =
          await TweetsServices.getMediaSectionTweets(user.username!, page);
      ref.read(profileTweetsProvider.notifier).updateMediaTweets(newTweets);
    } else if (tabIndex == 3) {
      newTweets =
          await TweetsServices.getTweetsLikedByUser(user.username!, page);
      ref.read(profileTweetsProvider.notifier).updateLikedTweets(newTweets);
    }
  }

  @override
  void dispose() {
    // _postedTweetsScrollController.dispose();
    // _likedTweetsScrollController.dispose();
    // _mediaTweetsScrollController.dispose();
    // _repliedTweetsScrollController.dispose();
    ref.read(profileTweetsProvider.notifier).reset();
    _scrollController.removeListener(_scrollListener);
    _tabController.removeListener(_changeTab);
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    setState(() {
      double newPosition = _scrollController.position.pixels;
      // if(_tabController.index==0) _postedTweetsScrollOffset=newPosition;
      // if(_tabController.index==1) _repliedTweetsScrollOffset=newPosition;
      // if(_tabController.index==2) _mediaTweetsScrollOffset=newPosition;
      // if(_tabController.index==3) _likedTweetsScrollOffset=newPosition;

      if (newPosition > 80) {
        _scrollingView = true;
      } else {
        _scrollingView = false;
      }
      if (newPosition / 5 <= 20) _imgRaduis = 35 - newPosition / 5;
    });

    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      print("max scroll");
      // _scrollController.position.jumpTo(value)
    }
  }

  void _openSideDropDown() {
    showDialog(
        context: context,
        builder: (context) => SideDropDownMenu(),
        useSafeArea: true,
        barrierColor: Colors.transparent);
  }

  void _toggleFollowState() {}

  @override
  Widget build(BuildContext context) {
    ProfileTweets profileTweets = ref.watch(profileTweetsProvider);

    return FutureBuilder(
      future: _getUserData(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const LinearProgressIndicator(
            //// need more work
            color: Colors.white,
            backgroundColor: Colors.blue,
          );
        } else {
          user = snapshot.data!;
          return SafeArea(
            child: Scaffold(
              body: NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder: (
                  BuildContext context,
                  bool innerBoxIsScrolled,
                ) {
                  return [
                    SliverStack(
                      insetOnOverlap: false,
                      children: [
                        SliverAppBar(
                          pinned: true,
                          leading: IconButton(
                            onPressed: () {
                              ////////////////////////////////////////////
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                            ),
                            padding: const EdgeInsets.all(0),
                            color: Colors.white,
                            style: ButtonStyle(
                              iconSize: const MaterialStatePropertyAll(25),
                              backgroundColor: MaterialStatePropertyAll(
                                const Color.fromARGB(255, 7, 7, 7)
                                    .withOpacity(0.5),
                              ),
                              shape: const MaterialStatePropertyAll(
                                CircleBorder(
                                  eccentricity: 0,
                                ),
                              ),
                            ),
                          ),
                          title: _scrollingView
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${user.fullName}",
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 24),
                                    ),
                                    Text(
                                      "0 posts", //////// need more work
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 17),
                                    )
                                  ],
                                )
                              : null,
                          actions: [
                            if (user.username != appUser.username &&
                                user.isFollowed == false &&
                                _scrollingView)
                              Container(
                                margin: const EdgeInsets.only(right: 20),
                                child: SecondaryButton(
                                  text: "Follow",
                                  onPressed: _toggleFollowState,
                                ),
                              ),
                            if (user.username == appUser.username ||
                                (user.username != appUser.username &&
                                    widget._isFollowed) ||
                                (!widget._mainAppUser &&
                                    !widget._isFollowed &&
                                    !_scrollingView))
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.search_rounded),
                                      color: Colors.white,
                                      padding: const EdgeInsets.all(0),
                                      style: ButtonStyle(
                                        iconSize:
                                            const MaterialStatePropertyAll(25),
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                          Color.fromARGB(255, 7, 7, 7)
                                              .withOpacity(0.5),
                                        ),
                                        shape: const MaterialStatePropertyAll(
                                          CircleBorder(
                                            eccentricity: 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 10, right: 10, left: 10),
                                    child: IconButton(
                                      onPressed: () {
                                        _openSideDropDown();
                                      },
                                      icon:
                                          const Icon(Icons.more_vert_outlined),
                                      color: Colors.white,
                                      padding: const EdgeInsets.all(0),
                                      style: ButtonStyle(
                                        iconSize:
                                            const MaterialStatePropertyAll(24),
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                          const Color.fromARGB(255, 7, 7, 7)
                                              .withOpacity(0.5),
                                        ),
                                        shape: const MaterialStatePropertyAll(
                                          CircleBorder(
                                            eccentricity: 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                          expandedHeight: 140,
                          flexibleSpace: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 7, 7, 7),
                              image: DecorationImage(
                                image: const NetworkImage(
                                  'https://th.bing.com/th/id/R.954112b1d86c17e04f32710a9dfa624b?rik=%2bujOnc84tNbuEQ&riu=http%3a%2f%2f3.bp.blogspot.com%2f-OuRPhqkSc60%2fU2dbPYEHx1I%2fAAAAAAAAFq8%2fvOU3zTMXzH8%2fs1600%2f1500x500-Nature-Twitter-Header28.jpg&ehk=EwDVaeRMKrCyrHOksN8rJ5QGW8qzTtgbTZ9OqW9sSRM%3d&risl=&pid=ImgRaw&r=0',
                                ),
                                fit: BoxFit.cover,
                                opacity: _scrollingView ? 0.17 : 1.0,
                              ),
                            ),
                          ),
                        ),
                        if (_scrollingView == false)
                          SliverPositioned(
                            left: 0,
                            top: 100,
                            child: GestureDetector(
                              onTap: () {
                                print(2);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: _imgRaduis + 5,
                                  child: CircleAvatar(
                                    radius: _imgRaduis,
                                    backgroundImage: (user
                                            .profilePicture!.path.isEmpty
                                        ? const AssetImage(
                                            "assets/images/def.jpg")
                                        : NetworkImage(user.profilePicture!.path
                                                    .startsWith("http")
                                                ? user.profilePicture!.path
                                                : "http://" +
                                                    user.profilePicture!.path)
                                            as ImageProvider),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 10, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // SizedBox(width: 15,),
                                // TextButton(
                                //     onPressed: () {print(2);},
                                //     style: const ButtonStyle(
                                //         padding: MaterialStatePropertyAll(EdgeInsets.all(0)),
                                //         overlayColor: MaterialStatePropertyAll(Colors.transparent),
                                //         splashFactory: NoSplash.splashFactory,

                                //         foregroundColor:
                                //             MaterialStatePropertyAll(
                                //                 Colors.transparent),backgroundColor: MaterialStatePropertyAll(Colors.transparent)),
                                //     child: Text("  ",style: TextStyle(fontSize: 0,),)),
                                //     Spacer(),
                                if (user.username == appUser.username)
                                  EditProfileButton(),
                                if (user.username != appUser.username &&
                                    user.isFollowed == true)
                                  NotificationsButton(
                                      isNotificationsEnabled:
                                          widget._isNotificationsEnabled),
                                if (user.username != appUser.username)
                                  FollowButton(isFollowed: widget._isFollowed)
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 20,
                            ),
                            child: Text(
                              '${user.fullName}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 20,
                            ),
                            child: Text(
                              '@${user.username}',
                              style: TextStyle(
                                color: Colors.grey.shade800,
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                height: 1,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          if (user.description != null && ////// need testing
                              user.description!.isEmpty == false)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                    left: 20,
                                    bottom: 10,
                                  ),
                                  child: Text(
                                    '${user.description}', ////////////////////
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          if (user.url != null && user.url!.isEmpty == false)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 20, bottom: 10),
                                  child: Icon(
                                    Icons.link,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                    left: 10,
                                  ),
                                  child: Text(
                                    'joined ${user.url}', ////////////////////
                                    style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 20, bottom: 10),
                                child: Icon(
                                  Icons.calendar_month_outlined,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                  left: 10,
                                ),
                                child: Text(
                                  'joined ${user.createdAt}', ////////////////////
                                  style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                  left: 20,
                                ),
                                child: Icon(
                                  BootstrapIcons.balloon,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                  left: 10,
                                ),
                                child: Text(
                                  'Born ${user.birthDate}', ////////////////////
                                  style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 15),
                            child: Row(
                              children: [
                                TextButton(
                                  onPressed: () {},
                                  style: const ButtonStyle(
                                      overlayColor: MaterialStatePropertyAll(
                                          Colors.transparent)),
                                  child: Row(
                                    children: [
                                      Text(
                                        '${user.followingCount}',

                                        ///need more work
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Following",
                                        style: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  style: const ButtonStyle(
                                      overlayColor: MaterialStatePropertyAll(
                                          Colors.transparent),
                                      padding: MaterialStatePropertyAll(
                                          EdgeInsets.zero)),
                                  child: Row(
                                    children: [
                                      Text(
                                        '${user.followersCount}',
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        ' Followers',
                                        style: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverPinnedHeader(
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white),
                        child: TabBar(
                          controller: _tabController,
                          isScrollable: true,
                          dividerColor: Colors.grey.shade100,
                          unselectedLabelStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w600),
                          labelStyle: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                          tabs: const [
                            Tab(
                              text: 'Posts',
                            ),
                            Tab(
                              text: 'Replies',
                            ),
                            Tab(
                              text: 'Media',
                            ),
                            Tab(
                              text: 'Likes',
                            ),
                          ],
                          indicatorColor: Colors.blue,
                          labelColor: Colors.black,
                          overlayColor: const MaterialStatePropertyAll(
                              Colors.transparent),
                        ),
                      ),
                    ),

                    // SliverList(delegate: SliverChildBuilderDelegate((context, index) => ,))
                  ];
                },
                body: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification.metrics.pixels ==
                        notification.metrics.maxScrollExtent) {
                      _fetchNewTweets(
                          _tabController.index, pages[_tabController.index]);
                      pages[_tabController.index]++;
                    }
                    return true;
                  },
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      profileTweets.postedTweets != null
                          ? ListView.builder(
                              itemBuilder: (context, index) {
                                return TweetCard(
                                    tweet: profileTweets.postedTweets![index]);
                              },
                              itemCount: profileTweets.postedTweets!.length,
                            )
                          : const Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(),
                              ),
                            ),
                      profileTweets.repliedTweets != null
                          ? ListView.builder(
                              itemBuilder: (context, index) {
                                return TweetCard(
                                    tweet: profileTweets.repliedTweets![index]);
                              },
                              itemCount: profileTweets.repliedTweets!.length,
                            )
                          : const Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(),
                              ),
                            ),
                      profileTweets.mediaTweets != null
                          ? ListView.builder(
                              itemBuilder: (context, index) {
                                return TweetCard(
                                    tweet: profileTweets.mediaTweets![index]);
                              },
                              itemCount: profileTweets.mediaTweets!.length,
                            )
                          : const Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(),
                              ),
                            ),
                      profileTweets.likedTweets != null
                          ? ListView.builder(
                              itemBuilder: (context, index) {
                                return TweetCard(
                                    tweet: profileTweets.likedTweets![index]);
                              },
                              itemCount: profileTweets.likedTweets!.length,
                            )
                          : const Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(),
                              ),
                            ),
                      
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
