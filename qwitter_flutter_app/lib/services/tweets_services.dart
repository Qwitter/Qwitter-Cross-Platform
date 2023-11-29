import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qwitter_flutter_app/models/tweet.dart';
import 'package:qwitter_flutter_app/screens/tweets/tweet_details.dart';

class TweetsServices {
  static String _baseUrl = 'http://192.168.1.10:3001';

  static Future<List<Tweet>> getTimeline() async {
    final url = Uri.parse('$_baseUrl/api/v1/timeline');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> tweetList =
          jsonDecode(response.body) as List<dynamic>;

      // Mapping the JSON data to List<Tweet>
      List<Tweet> tweets =
          tweetList.map((tweet) => Tweet.fromJson(tweet)).toList();

      return tweets;
    } else {
      throw Exception('Error fetching tweets');
    }
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
