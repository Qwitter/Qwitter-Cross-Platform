import 'package:flutter/cupertino.dart';
import 'package:riverpod/riverpod.dart';

class LoginButtonNotifier extends StateNotifier<void Function(BuildContext)?> {
  LoginButtonNotifier() : super(null);

  void Function(BuildContext)? get loginButtonFunction => state;

  void setLoginButtonFunction(void Function(BuildContext)? function) {
    state = function;
  }
}

final loginButtonProvider =
    StateNotifierProvider<LoginButtonNotifier, void Function(BuildContext)?>(
        (ref) {
  return LoginButtonNotifier();
});
