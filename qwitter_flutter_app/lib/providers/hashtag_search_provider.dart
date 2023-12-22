import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:qwitter_flutter_app/models/message_data.dart';
import 'package:qwitter_flutter_app/models/user.dart';

class HashtagSearchNotifier extends StateNotifier<List<String>> {
  HashtagSearchNotifier() : super([]);

  List<String> get hastags => state;

  void remove() {
    state = [];
  }

  void setHastags(List<String> hastags) {
    state = hastags;
  }
}

final hastagSearchProvider =
    StateNotifierProvider<HashtagSearchNotifier, List<String>>((ref) {
  return HashtagSearchNotifier();
});
