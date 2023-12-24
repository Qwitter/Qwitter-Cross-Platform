import 'package:qwitter_flutter_app/models/tweet.dart';
import 'package:qwitter_flutter_app/models/user.dart';
import 'package:qwitter_flutter_app/utils/date_humanizer.dart';
import 'package:qwitter_flutter_app/utils/enums.dart';

class QwitterNotification{
  // final String id;
  final NotificationType? type;
  final User? user;
  final String? tweetText;
  final Tweet? tweet;
  final String? date;

  QwitterNotification({
    // required this.id,
    required this.type,
    this.user,
    this.tweetText,
    this.tweet,
    this.date,
  });

  static NotificationType getType(Map<String, dynamic> json){
    NotificationType type;
    if(json['type'] == 'follow'){
      type = NotificationType.follow_type;
    }else if(json['type'] == 'like'){
      type = NotificationType.like_type;
    }else if(json['type'] == 'login'){
      type = NotificationType.login_type;
    }else if(json['type'] == 'retweet'){
      type = NotificationType.retweet_type;
    }else if(json['type'] == 'reply'){
      type = NotificationType.reply_type;
    }else{
      type = NotificationType.login_type;
    }

    return type;
  }


  static User? getUser(Map<String, dynamic> json){
    User? user;
    if(json['type'] == 'follow'){
      user = User.fromJson(json['follower']);
    }else if(json['type'] == 'like'){
      user = User.fromJson(json['like']['liker']);
    }else if(json['type'] == 'retweet'){
      user = User.fromJson(json['retweet']['author']);
    }else{
      user = null;
    }

    return user;
  }

  static String? getTweetText(Map<String, dynamic> json){
    String tweetText;
    if(json['type'] == 'like'){
      tweetText = json['like']['text'].toString();
    }else if(json['type'] == 'retweet'){
      tweetText = json['retweet']['retweetedTweet']['text'].toString();
    }else{
      tweetText = "";
    }

    return tweetText;
  }

  static Tweet? getTweet(Map<String, dynamic> json){
    if (json['type'] == 'reply') {
      return Tweet.fromJson(json['reply']);
    } else {
      return null;
    }
  }
  factory QwitterNotification.fromJson(Map<String, dynamic> json) {
    return QwitterNotification(
      // id: json['_id'] as String,
      type: QwitterNotification.getType(json),
      user: QwitterNotification.getUser(json),
      tweetText: QwitterNotification.getTweetText(json),
      tweet: getTweet(json),
      date: json['createdAt'] as String,

    );
  }
  

}