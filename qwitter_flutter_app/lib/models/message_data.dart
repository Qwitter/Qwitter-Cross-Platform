import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:qwitter_flutter_app/models/tweet.dart';

class MessageData {
  const MessageData({
    required this.id,
    required this.date,
    required this.text,
    required this.name,
    required this.profileImageUrl,
    required this.media,
    required this.byMe,
  });
  final String id;
  final DateTime date;
  final String text;
  final String name;
  final String? profileImageUrl;
  final Media? media;
  final bool byMe;
  factory MessageData.fromJson(Map<String, dynamic> json) {
    AppUser user = AppUser();
    final list = List<Media>.from(
      json['entities']['media'].map(
        (media) => Media(media['value'] as String, media['type'] as String),
      ),
    );
    print(list.isNotEmpty ? list.first.value : 'no media');
    var d = MessageData(
        id: json['id'],
        text: json['text'],
        name: json['userName'],
        profileImageUrl: json['profileImageUrl'],
        date: DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").parseUTC(json['date']),
        media: list.isNotEmpty ? list.first : null,
        byMe: (json['userName'] as String == user.username));
    return d;
  }
  @override
  bool operator ==(Object other) {
    return other is MessageData && other.id == id;
  }

  int get hashCode => id.hashCode;
}
