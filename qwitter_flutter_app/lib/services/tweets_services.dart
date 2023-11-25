import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:qwitter_flutter_app/models/tweet.dart';

class TweetsServices {
  static String _baseUrl = 'http://192.168.1.7:3001';

  static Future<dynamic> getTimeline() async {
  final url = Uri.parse('$_baseUrl/api/v1/timeline');

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List<dynamic> tweetList = jsonDecode(response.body) as List<dynamic>;

    // Mapping the JSON data to List<Tweet>
    List<Tweet> tweets = tweetList.map((tweet) => Tweet.fromJson(tweet)).toList();


    print(tweets[0].user!.username);
    return tweets;
  } else {
    throw Exception('Error fetching tweets');
  }
}
}