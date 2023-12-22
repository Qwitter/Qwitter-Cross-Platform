
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qwitter_flutter_app/models/tweet.dart';

class ForYouTweetsProvider extends StateNotifier<List<Tweet>> {
  ForYouTweetsProvider() : super([]);

  void setForYouTweets(List<Tweet> tweets) {
    
    for (var tweet in tweets) {
      bool prevLoaded = state.contains(tweet);
      if (state.where((element) => element.id == tweet.id).isEmpty) {
        state = [...state, tweet];
      }
    }


  }
  void resetForYouTweets(List<Tweet> tweets) {
    state = tweets;
  }

  void removeTweet(Tweet tweet) {
    state = state.where((t) => t.id != tweet.id).toList();
  }
}

final forYouTweetsProvider =
    StateNotifierProvider<ForYouTweetsProvider, List<Tweet>>((ref) {
  return ForYouTweetsProvider();
});



