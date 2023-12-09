import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:qwitter_flutter_app/models/message_data.dart';
import 'package:qwitter_flutter_app/models/user.dart';

class UserSearchNotifier extends StateNotifier<List<User>> {
  UserSearchNotifier() : super([]);

  void deleteHistory() {
    state = [];
  }

  void addUser(User user) {
    state = [...state, user];
  }

  void removeUser(User user) {
    for (var v in state) print(v.username);
    state = List.from(state)
      ..removeWhere((data) => data.username == user.username);
    for (var v in state) print(v.username);
  }

  bool contain(User user) {
    return state.contains(user);
  }

  void initData(List<User> users) {
    deleteHistory();
    AppUser myUser = AppUser();
    for (var user in users) {
      if (user.username != myUser.username) {
        state = [...state, user];
      }
    }
    print(state);
  }
}

final userSearchProvider =
    StateNotifierProvider<UserSearchNotifier, List<User>>((ref) {
  return UserSearchNotifier();
});
final selectedUserProvider =
    StateNotifierProvider<UserSearchNotifier, List<User>>((ref) {
  return UserSearchNotifier();
});
