import 'dart:convert';

import 'package:qwitter_flutter_app/models/user.dart';

class Media {
  final String value;
  final String type;

  Media(this.value, this.type);
}


class Tweet{
  int id;
  String? createdAt;
  User? user;
  int? repliesCount;
  int? retweetsCount;
  int? likesCount;
  int? quotesCount;
  String? text;
  String? replyToId;
  String? repostToId;
  String? quoteToId;
  List<String>? hashtags;
  List<String>? mentions;
  List<String>? urls;
  List<Media>? media;

  Tweet({
    required this.id,
    required this.createdAt,
    required this.user,
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
  });
  
  factory Tweet.fromJson(Map<String, dynamic> json) {
    User user = User.fromJson(json['user']);
    Tweet tweet = Tweet(
      id: int.parse(json['id']),
      createdAt: json['createdAt'],
      user: user,
      repliesCount: json['replyCount'],
      retweetsCount: json['retweetCount'],
      likesCount: json['likesCount'],
      quotesCount: json['qouteCount'],
      text: json['text'],
      replyToId: json['replyToTweetId'].toString(),
      repostToId: json['retweetedId'].toString(),
      quoteToId: json['qouteTweetedId'].toString(),
      hashtags: json['entities']['hashtags'].map<String>((hashtag) => hashtag['value'].toString()).toList(),
      mentions: json['entities']['mentions'].map<String>((mention) => mention['mentionedUsername'].toString()).toList(),
      urls: json['entities']['urls'].map<String>((url) => url['value'].toString()).toList(),
      // media: json['entities']['media'].map<String, String>((media) => MapEntry(media['value'], media['type'])),
      media: List<Media>.from(json['entities']['media'].map((media) => Media(media['value'] as String, media['type'] as String)))
    );

    return tweet; 
  }


}
