class MessageData {
  const MessageData(
      {required this.text, required this.date, required this.byMe});
  final String text;
  final DateTime date;
  final bool byMe;
  factory MessageData.fromJson(Map<String, dynamic> json) {
    return MessageData(
      text: json['text'],
      date: DateTime.now(),
      byMe: true,
    );
  }
}
