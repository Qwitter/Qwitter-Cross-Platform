
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qwitter_flutter_app/models/tweet.dart';

class TimelineTweetsProvider extends StateNotifier<List<Tweet>> {
  TimelineTweetsProvider() : super([]);

  void setTimelineTweets(List<Tweet> tweets) {
    for (var tweet in tweets) {
      // bool prevLoaded = state.contains(tweet);
      if (true) {
        state = [...state, tweet];
      }
    }
  }
}

final timelineTweetsProvider =
    StateNotifierProvider<TimelineTweetsProvider, List<Tweet>>((ref) {
  return TimelineTweetsProvider();
});



