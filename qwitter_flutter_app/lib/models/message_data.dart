import 'package:intl/intl.dart';
import 'package:path/path.dart';

class MessageData {
  const MessageData({
    required this.id,
    required this.date,
    required this.text,
    required this.name,
  });
  final String id;
  final DateTime date;
  final String text;
  final String name;
  factory MessageData.fromJson(Map<String, dynamic> json) {
    var d = MessageData(
      id: json['id'],
      text: json['text'],
      name: json['userName'],
      date: DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").parseUTC(json['date']),
    );
    return d;
  }
  @override
  bool operator ==(Object other) {
    return other is MessageData && other.id == id;
  }

  int get hashCode => id.hashCode;
}
