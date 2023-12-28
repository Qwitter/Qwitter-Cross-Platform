import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:qwitter_flutter_app/models/tweet.dart';

class MessageData {
  const MessageData({
    required this.isMessage,
    required this.isReply,
    required this.id,
    required this.date,
    required this.text,
    required this.name,
    required this.profileImageUrl,
    required this.media,
    required this.byMe,
    required this.reply,
  });

  final bool isMessage;
  final bool isReply;
  final String id;
  final DateTime date;
  final String text;
  final String name;
  final String? profileImageUrl;
  final Media? media;
  final bool byMe;
  final MessageData? reply;
  factory MessageData.fromJson(Map<String, dynamic> json,
      {bool isReply = false, bool? parentByMe}) {
    // log(json.toString());
    // print(json.toString());
    // print(json['text']);
    print(json['replyToMessage'] == null ? "null" : "notnull");
    if (json['replyToMessage'] != null)
      log('this is not a null' +
          json['text'] +
          json['replyToMessaage'].toString());
    AppUser user = AppUser();
    final list = isReply
        ? []
        : List<Media>.from(
            json['entities']['media'].map(
              (media) =>
                  Media(media['value'] as String, media['type'] as String),
            ),
          );
    // print(
    var d = MessageData(
      isMessage: json['isMessage'] ?? false,
      isReply: isReply,
      id: json['id'],
      text: json['text'],
      name: json['userName'],
      profileImageUrl: json['profileImageUrl'],
      date: DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ")
          .parseUTC(json['date'])
          .add(DateTime.now().timeZoneOffset),
      media: list.isNotEmpty ? list.first : null,
      byMe: isReply && parentByMe != null
          ? parentByMe!
          : (json['userName'] as String == user.username),
      reply: isReply || json['replyToMessage'] == null
          ? null
          : MessageData.fromJson(
              json['replyToMessage'],
              isReply: true,
              parentByMe: (json['userName'] as String == user.username),
            ),
    );

    return d;
  }
  @override
  bool operator ==(Object other) {
    return other is MessageData && other.id == id;
  }

  int get hashCode => id.hashCode;
}
