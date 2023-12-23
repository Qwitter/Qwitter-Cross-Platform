
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qwitter_flutter_app/models/tweet.dart';

class TimelineTweetsProvider extends StateNotifier<List<Tweet>> {
  TimelineTweetsProvider() : super([]);

  void setTimelineTweets(List<Tweet> tweets) {
    for (var tweet in tweets) {
      bool prevLoaded = state.contains(tweet);
      if (state.where((element) => element.id == tweet.id).isEmpty) {
        state = [...state, tweet];
      }
    }
  }
  void resetTimelineTweets(List<Tweet> tweets) {
    state = tweets;
  }

  void removeTweet(Tweet tweet) {
    state = state.where((t) => t.id != tweet.id).toList();
  }

  void removeRetweet(Tweet tweet) {
    state = state.where((t) => t.id != tweet.currentUserRetweetId).toList();
  }


}

final timelineTweetsProvider =
    StateNotifierProvider<TimelineTweetsProvider, List<Tweet>>((ref) {
  return TimelineTweetsProvider();
});



