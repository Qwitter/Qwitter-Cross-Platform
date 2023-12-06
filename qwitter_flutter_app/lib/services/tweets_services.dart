import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:qwitter_flutter_app/models/tweet.dart';
import 'package:qwitter_flutter_app/screens/tweets/tweet_details.dart';
import 'package:path_provider/path_provider.dart';

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

    final url = Uri.parse('$_baseUrl/api/v1/tweets/' +
        (tweet.repostToId ?? tweet.id!) +
        "/replies");

    print(user.token);

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'authorization': 'Bearer ${user.token}',
    });

    return response;
  }

  static Future<http.Response> likeTweetRequest(Tweet tweet) async {
    AppUser user = AppUser();

    final url = Uri.parse(
        '$_baseUrl/api/v1/tweets/' + (tweet.repostToId ?? tweet.id!) + "/like");

    print((tweet.repostToId ?? tweet.id!));

    final response = await http.post(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'authorization': 'Bearer ${user.token}',
    });

    return response;
  }

  static Future<http.Response> retweetRequest(Tweet tweet) async {
    AppUser user = AppUser();

    final url = Uri.parse('$_baseUrl/api/v1/tweets/');

    Future<void> uploadFiles(List<http.MultipartFile> files) async {
      var url = Uri.parse('YOUR_ENDPOINT_URL');

      var request = http.MultipartRequest('POST', url);
      request.files.addAll(files);

      try {
        var response = await request.send();
        if (response.statusCode == 200) {
          // Success, do something with the response
          print('Uploaded successfully!');
        } else {
          print('Failed to upload');
        }
      } catch (e) {
        print('Error: $e');
      }
    }

    List<http.MultipartFile> multipartFiles = []; // Your MultipartFile list
    await uploadFiles(multipartFiles);

    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'authorization': 'Bearer ${user.token}',
        },
        body: jsonEncode({
          "text": tweet.text,
          "repostToId": tweet.id,
          "source": "Android",
          "coordinates": "0,0",
          "retweetedId": tweet.id,
          "media": multipartFiles,
          "sensitive": "true"
        }));

    print(response.body);
    return response;
  }

  static Future<Map<String, dynamic>> replyToTweetRequest(
      String text, Tweet tweet) async {
    AppUser user = AppUser();

    final url = Uri.parse('$_baseUrl/api/v1/tweets/');

    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'authorization': 'Bearer ${user.token}',
        },
        body: jsonEncode({
          "text": text,
          "source": "Android",
          "coordinates": "0,0",
          "replyToTweetId": (tweet.repostToId ?? tweet.id!),
          "sensitive": "true"
        }));

    print(response.body);
    return jsonDecode(response.body);
  }

  static Future<http.Response> unlikeTweetRequest(Tweet tweet) async {
    AppUser user = AppUser();

    final url = Uri.parse(
        '$_baseUrl/api/v1/tweets/' + (tweet.repostToId ?? tweet.id!) + "/like");

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
        // print(tweetList.length);

        List<Tweet> tweets =
            tweetList.map((tweet) => Tweet.fromJson(tweet)).toList();

        // print(tweets.length);
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

        print("replies: ${tweetList.length}");
        print("Body: ${jsonBody["replies"]}");
        List<Tweet> tweets =
            tweetList.map((tweet) => Tweet.fromJson(tweet)).toList();
        //print('${tweets.length} replies fetched');
        return tweets;
      } else {
        print('Failed to fetch tweets: ${response.statusCode}');
        return [];
      }
    } catch (error, stackTrace) {
      print('Error fetching tweets: $error');
      print('StackTrace: $stackTrace');
      return [];
    }
  }

  static void makeRepost(ref, Tweet tweet) {
    try {
      final response = retweetRequest(tweet);

      ref.read(tweet.provider.notifier).toggleRetweet();
    } catch (error, stackTrace) {
      print('Error fetching tweets: $error');
      print('StackTrace: $stackTrace');
      return;
    }
    // ref.read(tweet.provider.notifier).toggleRetweet();
  }

  static void makeReply(ref, Tweet tweet, String text) {
    try {
      final response = replyToTweetRequest(text, tweet);

    } catch (error, stackTrace) {
      print('Error fetching tweets: $error');
      print('StackTrace: $stackTrace');
      return;
    }
  }

  static void makeLike(ref, Tweet tweet) {
    try {
      final response =
          tweet.isLiked! ? unlikeTweetRequest(tweet) : likeTweetRequest(tweet);

      ref.read(tweet.provider.notifier).toggleLike();
    } catch (error, stackTrace) {
      print('Error fetching tweets: $error');
      print('StackTrace: $stackTrace');
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
}
