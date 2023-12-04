import 'package:riverpod/riverpod.dart';

class TweetProgressNotifier extends StateNotifier<double> {
  TweetProgressNotifier() : super(0);

  double get tweetImages => state;

  void setTweetProgress(double progress) {
    state = progress;
  }
}

final tweetProgressProvider =
    StateNotifierProvider<TweetProgressNotifier, double>((ref) {
  return TweetProgressNotifier();
});
