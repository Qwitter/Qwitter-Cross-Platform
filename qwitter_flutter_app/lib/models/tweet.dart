import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qwitter_flutter_app/models/user.dart';
import 'package:qwitter_flutter_app/providers/single_tweet_provider.dart';

class Media {
  final String value;
  final String type;

  Media(this.value, this.type);
}

class Tweet {
  String? id;
  String? createdAt;
  User? user;
  User? retweetUser;
  User? replyUser;
  String? source;
  String? coordinates;
  int? repliesCount;
  int? retweetsCount;
  int? likesCount;
  int? quotesCount;
  bool? isLiked;
  bool? isRetweeted;
  bool? isQuoted;
  bool? isBookmarked;
  String? text;
  String? replyToId;
  String? repostToId;
  String? quoteToId;
  List<String>? hashtags;
  List<String>? mentions;
  List<String>? urls;
  List<Media>? media;
  List<Tweet> replies = [];
  late final StateNotifierProvider<SingleTweetProvider, Tweet> provider;

  Tweet({
    required this.id,
    required this.createdAt,
    required this.user,
    required this.retweetUser,
    required this.replyUser,
    required this.source,
    required this.coordinates,
    required this.repliesCount,
    required this.retweetsCount,
    required this.likesCount,
    required this.quotesCount,
    required this.text,
    required this.replyToId,
    required this.repostToId,
    required this.quoteToId,
    required this.hashtags,
    required this.mentions,
    required this.urls,
    required this.media,
    required this.isLiked,
    required this.isRetweeted,
    required this.isQuoted,
    required this.isBookmarked,
  }) {
    provider = StateNotifierProvider((ref) => SingleTweetProvider(this));
  }

  factory Tweet.fromJson(Map<String, dynamic> json) {
    User user = User.fromJson(json['retweetedId'] != null
        ? json["retweetedTweet"]['author']
        : json['author']);
    Tweet tweet = Tweet(
      id: json['retweetedId'] != null
          ? json["retweetedTweet"]['id']
          : json['id'],
      createdAt: json['createdAt'],
      user: user,
      retweetUser:
          json['retweetedId'] != null && json.containsKey('retweetedTweet')
              ? User.fromJson(json["retweetedTweet"]['author'])
              : null,
      replyUser:
          json['replyToTweetId'] != null && json.containsKey('replyToTweet')
              ? User.fromJson(json["replyToTweet"]['author'])
              : null,
      source: json['retweetedId'] != null
          ? json["retweetedTweet"]["source"]
          : json['source'],
      coordinates: json['retweetedId'] != null
          ? json["retweetedTweet"]["coordinates"]
          : json['coordinates'],
      repliesCount: json['retweetedId'] != null
          ? json["retweetedTweet"]["replyCount"]
          : json['replyCount'],
      retweetsCount: json['retweetedId'] != null
          ? json["retweetedTweet"]["retweetCount"]
          : json['retweetCount'],
      likesCount: json['retweetedId'] != null
          ? json["retweetedTweet"]["likesCount"]
          : json['likesCount'],
      quotesCount: json['retweetedId'] != null
          ? json["retweetedTweet"]["qouteCount"]
          : json['qouteCount'],
      text: json['retweetedId'] != null
          ? json["retweetedTweet"]['text']
          : json['text'],
      replyToId: json['replyToTweetId'],
      repostToId: json['retweetedId'],
      quoteToId: json['qouteTweetedId'],
      hashtags: json['retweetedId'] != null
          ? json['retweetedTweet']['entities'] != null
              ? json['retweetedTweet']['entities']['hashtags']
                  .map<String>((hashtag) => hashtag['value'].toString())
                  .toList()
              : []
          : json['entities'] != null
              ? json['entities']['hashtags']
                  .map<String>((hashtag) => hashtag['value'].toString())
                  .toList()
              : [],
      mentions: json['retweetedId'] != null
          ? json['retweetedTweet']['entities'] != null
              ? json['retweetedTweet']['entities']['mentions']
                  .map<String>(
                      (hashtag) => hashtag['mentionedUsername'].toString())
                  .toList()
              : []
          : json['entities'] != null
              ? json['entities']['mentions']
                  .map<String>(
                      (mention) => mention['mentionedUsername'].toString())
                  .toList()
              : [],
      urls: json['retweetedId'] != null
          ? json['retweetedTweet']['entities'] != null
              ? json['retweetedTweet']['entities']['urls']
                  .map<String>((hashtag) => hashtag['value'].toString())
                  .toList()
              : []
          : json['entities'] != null
              ? json['entities']['urls']
                  .map<String>((url) => url['value'].toString())
                  .toList()
              : [],
      // media: json['entities']['media'].map<String, String>((media) => MapEntry(media['value'], media['type'])),
      media: json['retweetedId'] != null
          ? List<Media>.from(json['retweetedTweet']['entities'] != null
              ? json['retweetedTweet']['entities']['media'].map((media) =>
                  Media(media['value'] as String, media['type'] as String))
              : [])
          : List<Media>.from(json['entities'] != null
              ? json['entities']['media'].map((media) =>
                  Media(media['value'] as String, media['type'] as String))
              : []),
      isLiked: json["liked"],
      isRetweeted: json['isRetweeted'],
      isQuoted: false,
      isBookmarked: false,

    );

    // //print(tweet.id);
    return tweet;
  }


  
}
