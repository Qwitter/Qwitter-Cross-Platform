import 'package:qwitter_flutter_app/models/tweet.dart';
import 'package:riverpod/riverpod.dart';

class ProfileTweets {
  List<Tweet>? postedTweets;
  List<Tweet>? likedTweets;
  List<Tweet>? repliedTweets;
  List<Tweet>? mediaTweets;

  ProfileTweets(this.postedTweets, this.likedTweets, this.mediaTweets,
      this.repliedTweets);

  ProfileTweets.copy(ProfileTweets object) {
    postedTweets = object.postedTweets;
    likedTweets = object.likedTweets;
    repliedTweets = object.repliedTweets;
    mediaTweets = object.mediaTweets;
  }
}

class ProfileTweetsNotifier extends StateNotifier<ProfileTweets> {
  ProfileTweetsNotifier() : super(ProfileTweets(null, null, null, null));

  void reset() {
    state = ProfileTweets(null, null, null, null);
  }

  void updatePostedTweets(List<Tweet> tweets) {
    ProfileTweets currState = state;
    if (currState.postedTweets == null) {
      currState.postedTweets = tweets;
    } else {
      currState.postedTweets?.addAll(tweets);
    }
    state = currState;

  }

  void updateLikedTweets(List<Tweet> tweets) {
    ProfileTweets currState = state;
    if (currState.likedTweets == null) {
      currState.likedTweets = tweets;
    } else {
      currState.likedTweets?.addAll(tweets);
    }
    state = currState;

  }

  void updateRepliedTweets(List<Tweet> tweets) {
    ProfileTweets currState = state;
    if (currState.repliedTweets == null) {
      currState.repliedTweets = tweets;
    } else {
      currState.repliedTweets?.addAll(tweets);
    }
    state = currState;

  }

  void updateMediaTweets(List<Tweet> tweets) {
    ProfileTweets currState = state;
    if (currState.mediaTweets == null) {
      currState.mediaTweets = tweets;
    } else {
      currState.mediaTweets?.addAll(tweets);
    }
    state = currState;

  }
}

final profileTweetsProvider =
    StateNotifierProvider<ProfileTweetsNotifier, ProfileTweets>(
        (ref) => ProfileTweetsNotifier());
