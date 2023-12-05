import 'package:flutter/material.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/secondary_button.dart';
import 'package:qwitter_flutter_app/components/profile/edit_profile_button.dart';
import 'package:qwitter_flutter_app/components/profile/follow_button.dart';
import 'package:qwitter_flutter_app/components/profile/notifications_button.dart';
// import 'package:qwitter_flutter_app/components/tweet_card.dart';

class ProfileDetailsWidget extends StatefulWidget {
  const ProfileDetailsWidget({super.key});
  final bool _mainAppUser = false;
  final bool _isFollowed = true;
  final bool _isNotificationsEnabled = false;

  @override
  State<ProfileDetailsWidget> createState() => _ProfileDetailsWidgetState();
}

class _ProfileDetailsWidgetState extends State<ProfileDetailsWidget> {
  late ScrollController _scrollController;
  bool _scrollingView = false;
  double _imgRaduis = 35;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    setState(() {
      double newPosition = _scrollController.position.pixels;
      if (newPosition > 100) {
        _scrollingView = true;
      } else {
        _scrollingView = false;
      }
      if (newPosition / 5 <= 20) _imgRaduis = 35 - newPosition / 5;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 5,
      child: SafeArea(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: _scrollingView
                ? const Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Amr Magdy',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                      Text(
                        "0 posts",
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      )
                    ],
                  )
                : null,
            backgroundColor: Colors.transparent,
            flexibleSpace: _scrollingView
                ? Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 7, 7, 7),
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://th.bing.com/th/id/R.954112b1d86c17e04f32710a9dfa624b?rik=%2bujOnc84tNbuEQ&riu=http%3a%2f%2f3.bp.blogspot.com%2f-OuRPhqkSc60%2fU2dbPYEHx1I%2fAAAAAAAAFq8%2fvOU3zTMXzH8%2fs1600%2f1500x500-Nature-Twitter-Header28.jpg&ehk=EwDVaeRMKrCyrHOksN8rJ5QGW8qzTtgbTZ9OqW9sSRM%3d&risl=&pid=ImgRaw&r=0',
                        ),
                        fit: BoxFit.cover,
                        opacity: 0.17,
                      ),
                    ),
                  )
                : null,
            leading: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.arrow_back,
              ),
              padding: const EdgeInsets.all(0),
              color: Colors.white,
              style: ButtonStyle(
                iconSize: const MaterialStatePropertyAll(25),
                backgroundColor: MaterialStatePropertyAll(
                  const Color.fromARGB(255, 7, 7, 7).withOpacity(0.5),
                ),
                shape: const MaterialStatePropertyAll(
                  CircleBorder(
                    eccentricity: 0,
                  ),
                ),
              ),
            ),
            actions: [
              if (!widget._mainAppUser && !widget._isFollowed && _scrollingView)
                Container(
                    margin: EdgeInsets.only(right: 20),
                    child: SecondaryButton(text: "Follow",onPressed: (){},)),
              if (widget._mainAppUser ||
                  (!widget._mainAppUser && widget._isFollowed) ||
                  (!widget._mainAppUser &&
                      !widget._isFollowed &&
                      !_scrollingView))
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          iconSize: const MaterialStatePropertyAll(25),
                          backgroundColor: MaterialStatePropertyAll(
                            Color.fromARGB(255, 7, 7, 7).withOpacity(0.5),
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
                      margin:
                          const EdgeInsets.only(top: 10, right: 10, left: 10),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.more_vert_outlined),
                        color: Colors.white,
                        padding: const EdgeInsets.all(0),
                        style: ButtonStyle(
                          iconSize: const MaterialStatePropertyAll(24),
                          backgroundColor: MaterialStatePropertyAll(
                            const Color.fromARGB(255, 7, 7, 7).withOpacity(0.5),
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
                )
            ],
            
          ),

          // backgroundColor: Colors.transparent,
          
          body: SingleChildScrollView(
            controller: _scrollController,
            // clipBehavior: Clip.none,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Image.network(
                      'https://th.bing.com/th/id/R.954112b1d86c17e04f32710a9dfa624b?rik=%2bujOnc84tNbuEQ&riu=http%3a%2f%2f3.bp.blogspot.com%2f-OuRPhqkSc60%2fU2dbPYEHx1I%2fAAAAAAAAFq8%2fvOU3zTMXzH8%2fs1600%2f1500x500-Nature-Twitter-Header28.jpg&ehk=EwDVaeRMKrCyrHOksN8rJ5QGW8qzTtgbTZ9OqW9sSRM%3d&risl=&pid=ImgRaw&r=0',
                      fit: BoxFit.cover,
                      height: 140,
                    ),
                    Positioned(
                      top: 100,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: _imgRaduis + 5,
                          child: CircleAvatar(
                            radius: _imgRaduis,
                            backgroundImage: const NetworkImage(
                              'https://hips.hearstapps.com/digitalspyuk.cdnds.net/17/13/1490989105-twitter1.jpg?resize=480:*',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 150,
                      right: 20,
                      child: Row(
                        children: [
                          if (widget._mainAppUser) EditProfileButton(),
                          if (!widget._mainAppUser && widget._isFollowed)
                            NotificationsButton(
                                isNotificationsEnabled:
                                    widget._isNotificationsEnabled),
                          if (!widget._mainAppUser)
                            FollowButton(isFollowed: widget._isFollowed)

                          // if(widget._isFollowed)
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 45,
                ),
                Container(
                  margin: const EdgeInsets.only(
                    left: 20,
                  ),
                  child: const Text(
                    'Amr Magdy',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
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
                    '@AmrMagdy551267',
                    style: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        left: 20,
                      ),
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
                        'joined December 2022',
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
                  margin:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () {},
                        style: const ButtonStyle(
                            overlayColor:
                                MaterialStatePropertyAll(Colors.transparent)),
                        child: Row(
                          children: [
                            const Text(
                              '111',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              ' Following',
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
                            overlayColor:
                                MaterialStatePropertyAll(Colors.transparent),
                            padding: MaterialStatePropertyAll(EdgeInsets.zero)),
                        child: Row(
                          children: [
                            const Text(
                              '111',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
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
                
                TabBar(
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
                      text: 'Highlights',
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
                  overlayColor:
                      const MaterialStatePropertyAll(Colors.transparent),
                ),
                SizedBox(
                  height: 720,
                  child: TabBarView(
                    children: [
                    SingleChildScrollView(child: Column(children: [Text("data"),SizedBox(height: 2000,),Text("data")]),),
                    Container(height: 1000,color: Colors.blueAccent,),
                    Container(height: 1000,color: Colors.red,),
                    Container(height: 1000,color: Colors.green,),
                    Container(height: 1000,color: Colors.pink,),
                  ]),
                ),

              ],
            ),
            

          ),
        ),
      ),
    );
  }
}
