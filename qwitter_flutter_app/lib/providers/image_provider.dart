import 'dart:io';

import 'package:riverpod/riverpod.dart';

class ImageNotifier extends StateNotifier<File?> {
  ImageNotifier() : super(null);

  File? get tweetImages => state;

  void setImage(File? images) {
    state = images;
  }
}

final imageProvider = StateNotifierProvider<ImageNotifier, File?>(
  (ref) {
    return ImageNotifier();
  },
);
