import 'package:qwitter_flutter_app/models/message_data.dart';

class Conversation {
  Conversation({
    required this.id,
    required this.name,
    this.status,
    this.photo,
    // required this.lastMsg,
  });

  final String id;
  String name;
  String? status;
  String? photo;
  MessageData? lastMsg;

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      photo: json['photo'],
      // lastMsg: MessageData.fromJson(json['lastMessage']),
    );
  }
}
