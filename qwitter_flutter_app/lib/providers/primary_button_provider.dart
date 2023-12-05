import 'package:flutter/cupertino.dart';
import 'package:riverpod/riverpod.dart';

class PrimaryButtonNotifier
    extends StateNotifier<void Function(BuildContext)?> {
  PrimaryButtonNotifier() : super(null);

  void Function(BuildContext)? get primaryButtonFunction => state;

  void setPrimaryButtonFunction(void Function(BuildContext)? function) {
    state = function;
  }
}

final primaryButtonProvider =
    StateNotifierProvider<PrimaryButtonNotifier, void Function(BuildContext)?>(
        (ref) {
  return PrimaryButtonNotifier();
});
