import 'dart:io';

import 'package:qwitter_flutter_app/models/tweet.dart';
import 'package:riverpod/riverpod.dart';

class ImageNotifier extends StateNotifier<Media?> {
  ImageNotifier() : super(null);

  Media? get tweetImages => state;

  void setImage(Media? images) {
    state = images;
  }
}

final imageProvider = StateNotifierProvider<ImageNotifier, Media?>(
  (ref) {
    return ImageNotifier();
  },
);
