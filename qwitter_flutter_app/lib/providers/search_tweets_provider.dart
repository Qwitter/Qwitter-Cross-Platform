import 'package:qwitter_flutter_app/models/tweet.dart';
import 'package:riverpod/riverpod.dart';

class SearchTweetsNotifier extends StateNotifier<List<Tweet>?> {
  SearchTweetsNotifier() : super(null);

  void reset() {
    state = null;
    print("search results reset done successfully");
  }

  void updateSearchTweets(List<Tweet> tweets) {
    if (state != null) {
      for (var tweet in tweets) {
        state = [...state!, tweet];
      }
    }else{
      state=tweets;
    }
  }
}

final searchTweetsProvider =
    StateNotifierProvider<SearchTweetsNotifier, List<Tweet>?>(
        (ref) => SearchTweetsNotifier());
