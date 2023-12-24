import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_avatar.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_header.dart';
import 'package:qwitter_flutter_app/models/tweet.dart';
import 'package:qwitter_flutter_app/screens/messaging/messaging_video.dart';
import 'package:qwitter_flutter_app/utils/date_humanizer.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class MessagingVideoScreen extends StatelessWidget {
  MessagingVideoScreen({super.key, required this.video});
  final String video;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBar(automaticallyImplyLeading: true),
      ),
      body: Center(
        child: Container(
          color: Colors.black,
          child: MessagingVideo(
              autoPlay: true, fullScreen: true, height: 1000, video: video),
        ),
      ),
    );
  }
}
