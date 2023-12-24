import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:qwitter_flutter_app/models/message_data.dart';
import 'package:qwitter_flutter_app/models/reply.dart';
import 'package:qwitter_flutter_app/models/user.dart';

class ReplyNotifer extends StateNotifier<Reply?> {
  ReplyNotifer() : super(null);

  void set(Reply? reply) {
    state = reply;
  }
}

final replyProvider = StateNotifierProvider<ReplyNotifer, Reply?>((ref) {
  return ReplyNotifer();
});
