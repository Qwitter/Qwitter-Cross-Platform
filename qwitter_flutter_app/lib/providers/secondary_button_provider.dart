import 'package:flutter/cupertino.dart';
import 'package:riverpod/riverpod.dart';

class SecondaryButtonNotifier
    extends StateNotifier<void Function(BuildContext)?> {
  SecondaryButtonNotifier() : super(null);

  void Function(BuildContext)? get secondaryButtonFunction => state;

  void setSecondaryButtonFunction(void Function(BuildContext)? function) {
    state = function;
  }
}

final secondaryButtonProvider = StateNotifierProvider<SecondaryButtonNotifier,
    void Function(BuildContext)?>((ref) {
  return SecondaryButtonNotifier();
});
