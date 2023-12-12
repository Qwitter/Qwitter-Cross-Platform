import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:qwitter_flutter_app/models/message_data.dart';
import 'package:qwitter_flutter_app/models/user.dart';

class UserProfileSearchNotifier extends StateNotifier<List<User>> {
  UserProfileSearchNotifier() : super([]);

  List<User> get users => state;

  void remove() {
    state = [];
  }

  void setUsers(List<User> users) {
    state = users;
  }
}

final userSearchProfileProvider =
    StateNotifierProvider<UserProfileSearchNotifier, List<User>>((ref) {
  return UserProfileSearchNotifier();
});
