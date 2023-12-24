import 'package:flutter/cupertino.dart';
import 'package:riverpod/riverpod.dart';

class NextBarNotifier extends StateNotifier<void Function(BuildContext)?> {
  NextBarNotifier() : super(null);

  void Function(BuildContext)? get nextBarFunction => state;

  void setNextBarFunction(void Function(BuildContext)? function) {
    state = function;
  }
}

final nextBarProvider =
    StateNotifierProvider<NextBarNotifier, void Function(BuildContext)?>((ref) {
  return NextBarNotifier();
});
final sendMessageProvider =
    StateNotifierProvider.autoDispose<NextBarNotifier, void Function(BuildContext)?>((ref) {
  return NextBarNotifier();
});