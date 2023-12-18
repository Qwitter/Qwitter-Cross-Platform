import 'package:qwitter_flutter_app/models/message_data.dart';
import 'package:qwitter_flutter_app/models/user.dart';

class Conversation {
  Conversation({
    required this.id,
    required this.isGroup,
    required this.name,
    this.status,
    this.photo,
    required this.lastMsg,
    required this.users,
  });
  final String id;
  final bool isGroup;
  String name;
  String? status;
  String? photo;
  MessageData? lastMsg;
  List<User> users;

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      isGroup: json['isGroup'],
      name: json['name'],
      status: json['status'],
      photo: json['photo'],
      lastMsg: json['lastMessage'] != null
          ? MessageData.fromJson(json['lastMessage'])
          : null,
      users: (json['users'] as List<dynamic>)
          .map((jsonUser) => User.fromJson(jsonUser))
          .toList(),
    );
  }
}
