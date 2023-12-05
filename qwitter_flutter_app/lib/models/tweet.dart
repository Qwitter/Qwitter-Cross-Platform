
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
  String? source;
  String? coordinates;
  String? retweetUserName;
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
    required this.retweetUserName,
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
    User user = User.fromJson(json['author']);
    Tweet tweet = Tweet(
      id: json['id'],
      createdAt: json['createdAt'],
      user: user,
      source: json['source'],
      coordinates: json['coordinates'],
      retweetUserName: json['userName'],
      repliesCount: json['replyCount'],
      retweetsCount: json['retweetCount'],
      likesCount: json['likesCount'],
      quotesCount: json['qouteCount'],
      text: json['text'],
      replyToId: json['replyToTweetId'],
      repostToId: json['retweetedId'],
      quoteToId: json['qouteTweetedId'],
      hashtags: json['entities'] != null ? json['entities']['hashtags']
          .map<String>((hashtag) => hashtag['value'].toString())
          .toList() : [],
      mentions: json['entities'] != null ? json['entities']['mentions']
          .map<String>((mention) => mention['mentionedUsername'].toString())
          .toList() : [],
      urls: json['entities'] != null ? json['entities']['urls']
          .map<String>((url) => url['value'].toString())
          .toList() : [],
      // media: json['entities']['media'].map<String, String>((media) => MapEntry(media['value'], media['type'])),
      media: List<Media>.from(json['entities'] != null ? json['entities']['media'].map(
          (media) => Media(media['url'] as String, media['type'] as String)) : []),
      isLiked: json["liked"],
      isRetweeted: false,
      isQuoted: false,
      isBookmarked: false,
    );

    // //print(tweet.id);
    return tweet;
  }

  
}
