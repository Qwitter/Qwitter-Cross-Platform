import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:qwitter_flutter_app/models/tweet.dart';
import 'package:qwitter_flutter_app/screens/tweets/tweet_details.dart';

class TweetsServices {
  static String _baseUrl = 'http://qwitterback.cloudns.org:3000';

  static Future<http.Response> getTimelineResponse(int page) async {
    AppUser user = AppUser();

    final url =
        Uri.parse('$_baseUrl/api/v1/tweets?page=${page.toString()}&limit=10');

    //print(user.token);

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'authorization': 'Bearer ${user.token}',
    });

    return response;
  }

  static Future<http.Response> getTweetRepliesResponse(Tweet tweet) async {
    AppUser user = AppUser();

    final url = Uri.parse('$_baseUrl/api/v1/tweets/' + tweet.id! + "/replies");

    //print(user.token);

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'authorization': 'Bearer ${user.token}',
    });

    return response;
  }

  static Future<http.Response> likeTweetRequest(Tweet tweet) async {
    AppUser user = AppUser();

    final url = Uri.parse('$_baseUrl/api/v1/tweets/' + tweet.id! + "/like");

    //print(user.token);

    final response = await http.post(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'authorization': 'Bearer ${user.token}',
    });

    return response;
  }

  static Future<http.Response> unlikeTweetRequest(Tweet tweet) async {
    AppUser user = AppUser();

    final url = Uri.parse('$_baseUrl/api/v1/tweets/' + tweet.id! + "/like");

    //print(user.token);

    final response = await http.delete(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'authorization': 'Bearer ${user.token}',
    });

    return response;
  }

  static Future<List<Tweet>> getTimeline(int page) async {
    try {
      final response = await getTimelineResponse(page);

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        final List<dynamic> tweetList = jsonBody["tweets"] as List<dynamic>;
        List<Tweet> tweets =
            tweetList.map((tweet) => Tweet.fromJson(tweet)).toList();
        //print('${tweets.length} tweets fetched');
        return tweets;
      } else {
        //print('Failed to fetch tweets: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      //print('Error fetching tweets: $error');
      //print('StackTrace: $stackTrace');
      return [];
    }
  }

  static Future<List<Tweet>> getTweetReplies(Tweet tweet) async {
    try {
      final response = await getTweetRepliesResponse(tweet);

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        final List<dynamic> tweetList = jsonBody["replies"] as List<dynamic>;

        List<Tweet> tweets =
            tweetList.map((tweet) => Tweet.fromJson(tweet)).toList();
        //print('${tweets.length} replies fetched');
        return tweets;
      } else {
        //print('Failed to fetch tweets: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      //print('Error fetching tweets: $error');
      //print('StackTrace: $stackTrace');
      return [];
    }
  }

  static void makeRepost(ref, Tweet tweet) {
    ref.read(tweet.provider.notifier).toggleRetweet();
  }

  static void makeLike(ref, Tweet tweet) {
    try {
      final response =
          tweet.isLiked! ? unlikeTweetRequest(tweet) : likeTweetRequest(tweet);

      ref.read(tweet.provider.notifier).toggleLike();
    } catch (error) {
      //print('Error fetching tweets: $error');
      //print('StackTrace: $stackTrace');
      return;
    }
  }

  static void makeFollow(ref, Tweet tweet) {
    ref.read(tweet.provider.notifier).toggleFollow();
  }

  static void makeComment(context, Tweet tweet) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return TweetDetailsScreen(tweet: tweet);
    }));
  }

  static Future<List<Tweet>> getTweetsLikedByUser(
      String username, int page) async {
    AppUser appUser = AppUser();
    final url = Uri.parse(
        '$_baseUrl/api/v1/tweets/user/$username/like?page=${page.toString()}&limit=10');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'authorization': 'Bearer ${appUser.token}',
    });

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final List<dynamic> tweetList = jsonBody["tweets"] as List<dynamic>;

      List<Tweet> tweets =
          tweetList.map((tweet) => Tweet.fromJson(tweet)).toList();

      return tweets;
    } else {
      return [];
    }
  }

  static Future<List<Tweet>> getTweetsPostedByUser(
      String username, int page) async {
    AppUser appUser = AppUser();
    final url = Uri.parse(
        '$_baseUrl/api/v1/tweets/user/$username?page=${page.toString()}&limit=10');
    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'authorization': 'Bearer ${appUser.token}',
      });
      print(" token : ${appUser.token}");
      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        final List<dynamic> tweetList = jsonBody["tweets"] as List<dynamic>;

        List<Tweet> tweets = tweetList.map((tweet) {
          return Tweet.fromJson(tweet);
        }).toList();

        return tweets;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<List<Tweet>> getMediaSectionTweets(
      String username, int page) async {
    AppUser appUser = AppUser();
    final url = Uri.parse(
        '$_baseUrl/api/v1/tweets/user/$username/media?page=${page.toString()}&limit=10');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'authorization': 'Bearer ${appUser.token}',
    });

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final List<dynamic> tweetList = jsonBody["tweets"] as List<dynamic>;

      List<Tweet> tweets =
          tweetList.map((tweet) => Tweet.fromJson(tweet)).toList();

      return tweets;
    } else {
      return [];
    }
  }

  static Future<List<Tweet>> getRepliesSectionTweets(
      String username, int page) async {
    AppUser appUser = AppUser();
    final url = Uri.parse(
        '$_baseUrl/api/v1/tweets/user/$username/replies?page=${page.toString()}&limit=10');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'authorization': 'Bearer ${appUser.token}',
    });

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final List<dynamic> tweetList = jsonBody["tweets"] as List<dynamic>;

      List<Tweet> tweets =
          tweetList.map((tweet) => Tweet.fromJson(tweet)).toList();
      return tweets;
    } else {
      return [];
    }
  }
}
