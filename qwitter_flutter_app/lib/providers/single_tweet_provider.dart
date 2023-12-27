import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qwitter_flutter_app/models/tweet.dart';
import 'package:qwitter_flutter_app/utils/enums.dart';

class SingleTweetProvider extends StateNotifier<Tweet> {
  SingleTweetProvider(Tweet tweetInstance) : super(tweetInstance);

  void setTweet(Tweet tweet) {
    state = tweet;
  }

  void toggleLike() {
    Tweet tweet = state;
    tweet.likesCount = tweet.likesCount! + (tweet.isLiked! == false ? 1 : -1);
    tweet.isLiked = !tweet.isLiked!;
    state = tweet;
  }

  void toggleRetweet() {
    Tweet tweet = state;
    tweet.retweetsCount =
        tweet.retweetsCount! + (tweet.currentUserRetweetId == null ? 1 : -1);
    tweet.isRetweeted = (tweet.currentUserRetweetId != null);
    state = tweet;
  }

  void toggleFollow() {
    Tweet tweet = state;
    tweet.user!.isFollowed = !tweet.user!.isFollowed!;
    state = tweet;
  }

  void resetReplies(List<Tweet> replies) {
    state.replies = [...replies];
  }

  void setReplies(List<Tweet> replies) {
    // Tweet tweet = state;
    for (var reply in replies) {
      if (state.replies.where((element) => element.id == reply.id).isEmpty) {
        // tweet.replies = [...tweet.replies, reply];
        state.replies = state.replies.where((element) => element.id != reply.id).toList();
      }
    }
    
  }

  void removeTweet(Tweet tweet) {
    state.replies = state.replies.where((t) => t.id != tweet.id).toList();
  }

  void undoRetweetEffect(Tweet tweet) {
    state.currentUserRetweetId = null;
    state.retweetsCount = state.retweetsCount! - 1;
  }

  void increamentReplies() {
    state.repliesCount = state.repliesCount ?? 0 + 1;
  }
}
