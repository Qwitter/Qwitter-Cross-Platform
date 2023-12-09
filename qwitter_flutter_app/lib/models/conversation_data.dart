import 'package:qwitter_flutter_app/models/message_data.dart';

class Conversation {
  Conversation({
    required this.id,
    required this.name,
    required this.status,
    required this.lastMsg,
    this.imgPath,
  });

  final String id;
  String name;
  String? status;
  String? imgPath;
  MessageData? lastMsg;

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      lastMsg: MessageData.fromJson(json['lastMessage']),
    );
  }
}
