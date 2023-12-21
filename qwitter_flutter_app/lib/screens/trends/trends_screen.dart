import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:qwitter_flutter_app/components/layout/qwitter_bottom_navigation.dart";
import "package:qwitter_flutter_app/components/layout/sidebar/main_drawer.dart";
import "package:qwitter_flutter_app/models/app_user.dart";
import "package:qwitter_flutter_app/models/trend.dart";
import "package:qwitter_flutter_app/screens/searching/search_screen.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';

import "package:qwitter_flutter_app/screens/searching/searching_user_screen.dart";

class TrendsScreen extends StatefulWidget {
  TrendsScreen({super.key});

  @override
  State<TrendsScreen> createState() => _TrendsScreenState();
}

class _TrendsScreenState extends State<TrendsScreen> {
  AppUser appUser = AppUser();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  List<Trend>? trendsList = null;

  @override
  initState() {
    super.initState();
    _fetchTrends().then((value) {
      setState(() {
        trendsList = value;
      });
    });
  }
    String formatNumber(int number) {
    return NumberFormat.compact(explicitSign: false).format(number);
  }

  Future<List<Trend>?> _fetchTrends() async {
    String _baseUrl = 'http://back.qwitter.cloudns.org:3000';

    Map<String, String> cookies = {
      'qwitter_jwt': 'Bearer ${appUser.getToken}',
    };

    final url = Uri.parse('$_baseUrl/api/v1/trends');

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      // 'authorization': 'Bearer ${appUser.token}',
      'Cookie': cookies.entries
          .map((entry) => '${entry.key}=${entry.value}')
          .join('; '),
    });
    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final List<dynamic> terndsList = jsonBody["trends"] as List<dynamic>;

      List<Trend> trends =
          terndsList.map((tweet) => Trend.fromJson(tweet)).toList();
      return trends;
    } else {
      print(
          "failed to fetch the trends list  status code:${response.statusCode} and the body:${response.body}");
      return [];
    }
  }

  Future<void> _onRefresh() async {
    _fetchTrends().then((value) {
      setState(() {
        trendsList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: MainDrawer(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(children: [
          GestureDetector(
            onTap: () {
              _scaffoldKey.currentState!.openDrawer();
            },
            child: CircleAvatar(
              radius: 13,
              backgroundImage: (appUser.profilePicture!.path.isEmpty
                  ? const AssetImage("assets/images/def.jpg")
                  : NetworkImage(appUser.profilePicture!.path)
                      as ImageProvider),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return SearchUserScreen();
                  }));
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll(Colors.grey.shade900),
                  overlayColor: MaterialStatePropertyAll(Colors.transparent),
                  alignment: Alignment.centerLeft,
                ),
                child: Text(
                  "Search Qwitter",
                  style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 15,
                      fontWeight: FontWeight.w400),
                )),
          ),
        ]),
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      bottomNavigationBar: QwitterBottomNavigationBar(),
      body: (trendsList != null)
          ? RefreshIndicator(
              onRefresh: _onRefresh,
              child: CustomScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverList.builder(
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return SearchScreen(
                                  query: "",
                                  hastag: trendsList![index].hashtag);
                            }));
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(left: 20,top: 10,bottom: 10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${index + 1}. Trending",
                                  style: TextStyle(color: Colors.grey.shade600, fontSize: 15,fontWeight: FontWeight.w900),
                                ),
                                Text(
                                  "${trendsList![index].hashtag.replaceFirst("#", "")}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  "${formatNumber(trendsList![index].count)} posts",
                                  style: TextStyle(
                                      color: Colors.grey.shade600, fontSize: 15),
                                ),
                              ],
                            ),
                          ));
                    },
                    itemCount: trendsList!.length,
                  )
                ],
              ),
            )
          : const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}
