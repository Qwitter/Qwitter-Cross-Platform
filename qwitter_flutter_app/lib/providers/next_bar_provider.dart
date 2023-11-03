import 'package:riverpod/riverpod.dart';

class NextBarNotifier extends StateNotifier<void Function()?> {
  NextBarNotifier() : super(null);

  void Function()? get nextBarFunction => state;

  void setNextBarFunction(void Function()? function) {
    state = function;
  }
}

final nextBarProvider =
    StateNotifierProvider<NextBarNotifier, void Function()?>((ref) {
  return NextBarNotifier();
});
