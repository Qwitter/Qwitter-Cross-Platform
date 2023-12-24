import 'package:qwitter_flutter_app/models/tweet.dart';

class Reply {
  Reply({this.replyId, this.replyText, this.replyName, this.replyMedia});
  String? replyId;
  String? replyText;
  String? replyName;
  Media? replyMedia;
}
