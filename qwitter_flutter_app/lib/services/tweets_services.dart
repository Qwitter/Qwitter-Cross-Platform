import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:qwitter_flutter_app/models/tweet.dart';
import 'package:qwitter_flutter_app/providers/for_you_tweets_provider.dart';
import 'package:qwitter_flutter_app/providers/timeline_tweets_provider.dart';
import 'package:qwitter_flutter_app/screens/tweets/tweet_details.dart';
import 'package:path_provider/path_provider.dart';

class TweetsServices {
  static String _baseUrl = 'http://back.qwitter.cloudns.org:3000';
  static AppUser user = AppUser();
  static Map<String, String> cookies = {
    'qwitter_jwt': 'Bearer ${user.getToken}',
  };

  static Future<http.Response> getTimelineResponse(int page) async {
    user.getUserData();
    cookies = {
      'qwitter_jwt': 'Bearer ${user.getToken}',
    };
    final url =
        Uri.parse('$_baseUrl/api/v1/tweets?page=${page.toString()}&limit=10');

    //print(user.token);

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      // 'authorization': 'Bearer ${user.token}',
      'Cookie': cookies.entries
          .map((entry) => '${entry.key}=${entry.value}')
          .join('; '),
    });

    return response;
  }

  static Future<http.Response> getForYouResponse(int page) async {
    user.getUserData();
    cookies = {
      'qwitter_jwt': 'Bearer ${user.getToken}',
    };
    final url =
        Uri.parse('$_baseUrl/api/v1/timeline?page=${page.toString()}&limit=10');

    //print(user.token);

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      // 'authorization': 'Bearer ${user.token}',
      'Cookie': cookies.entries
          .map((entry) => '${entry.key}=${entry.value}')
          .join('; '),
    });

    return response;
  }

  static Future<http.Response> getTweetRepliesResponse(Tweet tweet) async {
    user.getUserData();
    cookies = {
      'qwitter_jwt': 'Bearer ${user.getToken}',
    };
    final url = Uri.parse('$_baseUrl/api/v1/tweets/' +
        (tweet.repostToId ?? tweet.id!) +
        "/replies");

    print(user.token);

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      // 'authorization': 'Bearer ${user.token}',
      'Cookie': cookies.entries
          .map((entry) => '${entry.key}=${entry.value}')
          .join('; '),
    });

    return response;
  }

  static Future<http.Response> deleteTweetResponse(Tweet tweet) async {
    user.getUserData();
    cookies = {
      'qwitter_jwt': 'Bearer ${user.getToken}',
    };
    final url = Uri.parse('$_baseUrl/api/v1/tweets/${tweet.id!}');

    print(user.token);

    final response = await http.delete(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Cookie': cookies.entries
          .map((entry) => '${entry.key}=${entry.value}')
          .join('; '),
    });

    return response;
  }

    static Future<http.Response> deleteRetweetResponse(Tweet tweet) async {
    user.getUserData();
    cookies = {
      'qwitter_jwt': 'Bearer ${user.getToken}',
    };
    final url = Uri.parse('$_baseUrl/api/v1/tweets/${tweet.currentUserRetweetId!}');

    print(user.token);

    final response = await http.delete(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Cookie': cookies.entries
          .map((entry) => '${entry.key}=${entry.value}')
          .join('; '),
    });

    return response;
  }

  static Future<http.Response> followTweetUser(String id) async {
    user.getUserData();
    cookies = {
      'qwitter_jwt': 'Bearer ${user.getToken}',
    };
    final url = Uri.parse('$_baseUrl/api/v1/user/follow/${id}');

    print(user.token);

    final response = await http.post(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Cookie': cookies.entries
          .map((entry) => '${entry.key}=${entry.value}')
          .join('; '),
    });

    return response;
  }

    static Future<http.Response> unfollowTweetUser(String id) async {
    user.getUserData();
    cookies = {
      'qwitter_jwt': 'Bearer ${user.getToken}',
    };
    final url = Uri.parse('$_baseUrl/api/v1/user/follow/${id}');

    print(user.token);

    final response = await http.delete(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Cookie': cookies.entries
          .map((entry) => '${entry.key}=${entry.value}')
          .join('; '),
    });

    return response;
  }

  static Future<http.Response> likeTweetRequest(Tweet tweet) async {
    user.getUserData();
    cookies = {
      'qwitter_jwt': 'Bearer ${user.getToken}',
    };
    final url = Uri.parse(
        '$_baseUrl/api/v1/tweets/' + (tweet.repostToId ?? tweet.id!) + "/like");

    print((tweet.repostToId ?? tweet.id!));

    final response = await http.post(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      // 'authorization': 'Bearer ${user.token}',
      'Cookie': cookies.entries
          .map((entry) => '${entry.key}=${entry.value}')
          .join('; '),
    });

    return response;
  }

  static Future<http.Response> retweetRequest(Tweet tweet) async {
    user.getUserData();
    cookies = {
      'qwitter_jwt': 'Bearer ${user.getToken}',
    };
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
          // 'authorization': 'Bearer ${user.token}',
          'Cookie': cookies.entries
              .map((entry) => '${entry.key}=${entry.value}')
              .join('; '),
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
    user.getUserData();
    cookies = {
      'qwitter_jwt': 'Bearer ${user.getToken}',
    };
    final url = Uri.parse('$_baseUrl/api/v1/tweets/');

    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          // 'authorization': 'Bearer ${user.token}',
          'Cookie': cookies.entries
              .map((entry) => '${entry.key}=${entry.value}')
              .join('; '),
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
    user.getUserData();
    cookies = {
      'qwitter_jwt': 'Bearer ${user.getToken}',
    };
    final url = Uri.parse(
        '$_baseUrl/api/v1/tweets/' + (tweet.repostToId ?? tweet.id!) + "/like");

    //print(user.token);

    final response = await http.delete(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      // 'authorization': 'Bearer ${user.token}',
      'Cookie': cookies.entries
          .map((entry) => '${entry.key}=${entry.value}')
          .join('; '),
    });

    return response;
  }

  static Future<List<Tweet>> getTimeline(int page) async {
    try {
      final response = await getTimelineResponse(page);
      print('${page} page fetched');
      print("scode: " + response.statusCode.toString());
      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        final List<dynamic> tweetList = jsonBody["tweets"] as List<dynamic>;

        print('List ${tweetList}');
        List<Tweet> tweets =
            tweetList.map((tweet) => Tweet.fromJson(tweet)).toList();


        print('${tweets.length} - ${tweetList.length} tweets fetched');


        return tweets;
      } else {
        //print('Failed to fetch tweets: ${response.statusCode}');
        return [];
      }
    } catch (error, stackTrace) {
      print('Error fetching tweets: $error');
      print('StackTrace: $stackTrace');
      return [];
    }
  }


  static Future<List<Tweet>> getForYou(int page) async {
    try {
      final response = await getForYouResponse(page);
      print('${page} page fetched');
      print("scode: " + response.statusCode.toString());
      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        final List<dynamic> tweetList = jsonBody["tweets"] as List<dynamic>;

        print('List ${tweetList}');
        List<Tweet> tweets =
            tweetList.map((tweet) => Tweet.fromJson(tweet)).toList();


        print('${tweets.length} - ${tweetList.length} tweets fetched');


        return tweets;
      } else {
        //print('Failed to fetch tweets: ${response.statusCode}');
        return [];
      }
    } catch (error, stackTrace) {
      print('Error fetching tweets: $error');
      print('StackTrace: $stackTrace');
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

  static String makeRepost(ref, Tweet tweet) {
    try {
      String retweeted_id = "";
      final response = retweetRequest(tweet).then((response){
        final responseBody = jsonDecode(response.body);
        print(responseBody['tweet']);
        retweeted_id = responseBody['tweet']['id'];
        ref.read(timelineTweetsProvider.notifier).setTimelineTweets([Tweet.fromJson(responseBody['tweet'])]);
        ref.read(forYouTweetsProvider.notifier).setForYouTweets([Tweet.fromJson(responseBody['tweet'])]);
      });

      ref.read(tweet.provider.notifier).toggleRetweet();
      return retweeted_id;
    } catch (error, stackTrace) {
      print('Error fetching tweets: $error');
      print('StackTrace: $stackTrace');
      return "";
    }
    // ref.read(tweet.provider.notifier).toggleRetweet();
  }

  static Future<Map<String, dynamic>> makeReply(ref, Tweet tweet, String text) async {
    try {
      final response = await replyToTweetRequest(text, tweet);
      return response;
    } catch (error, stackTrace) {
      print('Error fetching tweets: $error');
      print('StackTrace: $stackTrace');
      return {};
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
    try {
      if(tweet.user!.isFollowed!){
        final response = unfollowTweetUser(tweet.user!.username!);
      }else{
        final response = followTweetUser(tweet.user!.username!);
      }
      print(tweet.user!.isFollowed!);

      ref.read(tweet.provider.notifier).toggleFollow();
    } catch (error, stackTrace) {
      print('Error fetching tweets: $error');
      print('StackTrace: $stackTrace');
      return;
    }
    // ref.read(tweet.provider.notifier).toggleFollow();
  }


  static void makeComment(context, Tweet tweet) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return TweetDetailsScreen(tweet: tweet);
    }));
  }


  static void deleteTweet(ref, context, Tweet tweet) {
    try {
      final response = deleteTweetResponse(tweet);
      ref.read(timelineTweetsProvider.notifier).removeTweet(tweet);
      Navigator.pop(context);
    } catch (error, stackTrace) {
      print('Error deleting tweets: $error');
      print('StackTrace: $stackTrace');
      return;
    }
  }

  static void deleteRetweet(ref, context, Tweet tweet) {
    try {
      final response = deleteRetweetResponse(tweet);
      ref.read(tweet.provider.notifier).undoRetweetEffect(tweet);
      ref.read(timelineTweetsProvider.notifier).removeRetweet(tweet);
      ref.read(forYouTweetsProvider.notifier).removeRetweet(tweet);
      Navigator.pop(context);
    } catch (error, stackTrace) {
      print('Error deleting tweets: $error');
      print('StackTrace: $stackTrace');
      return;
    }
  }

  static Future<List<Tweet>> getTweetsLikedByUser(
      String username, int page) async {
    AppUser appUser = AppUser();
    final url = Uri.parse(
        '$_baseUrl/api/v1/tweets/user/$username/like?page=${page.toString()}&limit=10');
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
        // 'authorization': 'Bearer ${appUser.token}',
        'Cookie': cookies.entries
            .map((entry) => '${entry.key}=${entry.value}')
            .join('; '),
      });
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
      // 'authorization': 'Bearer ${appUser.token}',
      'Cookie': cookies.entries
          .map((entry) => '${entry.key}=${entry.value}')
          .join('; '),
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
      // 'authorization': 'Bearer ${appUser.token}',
      'Cookie': cookies.entries
          .map((entry) => '${entry.key}=${entry.value}')
          .join('; '),
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

  static Future<List<Tweet>> getSearchTweets(String query,String hashtag,int page) async{
    final url = Uri.parse(
        '$_baseUrl/api/v1/tweets?page=${page.toString()}&limit=10${query.isEmpty==false?"&q=$query":""}${hashtag.isEmpty==false?"&hashtag=${hashtag.replaceFirst("#", "%23")}":""}');
    print(url);
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
      final List<dynamic> tweetList = jsonBody["tweets"] as List<dynamic>;
      List<Tweet> tweets =
          tweetList.map((tweet) => Tweet.fromJson(tweet)).toList();
      
      for(var t in tweets){
        print("tweeeeeet: $t");
      }
      return tweets;
    } else {
      
      print("failed to fetch the search tweets status code:${response.statusCode} and the body:${response.body}");
      return [];
    }
  }
  
}
