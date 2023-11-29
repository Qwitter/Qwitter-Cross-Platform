import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:qwitter_flutter_app/models/tweet.dart';
import 'package:qwitter_flutter_app/screens/tweets/tweet_details.dart';

class TweetsServices {
  static String _baseUrl = 'http://qwitterback.cloudns.org:3000/';

  static Future<http.Response> getTimelineResponse() async {
    AppUser user = AppUser();

    final url = Uri.parse('$_baseUrl/api/v1/tweets');

    print(user.token);
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'authorization': 'Bearer ${user.token}',
    });

    return response;
  }

  static Future<List<Tweet>> getTimeline() async {
    getTimelineResponse().then((response) {
      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        print(jsonBody);
        List<Tweet> tweets = [];
        // final List<dynamic> tweetList =
        //     jsonDecode(response.body) as List<dynamic>;

        // // Mapping the JSON data to List<Tweet>
        // List<Tweet> tweets =
        //     tweetList.map((tweet) => Tweet.fromJson(tweet)).toList();

        return tweets;
      } else {
        print(response.statusCode.toString());
      }
    }).onError((error, stackTrace) {
      print(error.toString());
      print(stackTrace.toString());
      return [];
    });

    return [];
  }

  static void makeRepost(ref, Tweet tweet) {
    ref.read(tweet.provider.notifier).toggleRetweet();
  }

  static void makeLike(ref, Tweet tweet) {
    ref.read(tweet.provider.notifier).toggleLike();
  }

  static void makeFollow(ref, Tweet tweet) {
    ref.read(tweet.provider.notifier).toggleFollow();
  }

  static void makeComment(context, Tweet tweet) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return TweetDetailsScreen(tweet: tweet);
    }));
  }
}
