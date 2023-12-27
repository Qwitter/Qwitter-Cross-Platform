import 'dart:io';

import 'package:riverpod/riverpod.dart';

class TweetImagesNotifier extends StateNotifier<List<File>?> {
  TweetImagesNotifier() : super(null);

  List<File>? get tweetImages => state;

  void setTweetImages(List<File> images) {
    state = images;
  }

  void clearTweetImages() {
    state = null;
  }
}

final tweetImagesProvider =
    StateNotifierProvider<TweetImagesNotifier, List<File>?>((ref) {
  return TweetImagesNotifier();
});
