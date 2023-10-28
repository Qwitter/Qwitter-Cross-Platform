import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class TweetVideo extends StatefulWidget {
  final String video;
  final double aspect_ratio;
  final double height;
  final bool auto_play;

  TweetVideo(
      {required this.video,
      required this.aspect_ratio,
      required this.height,
      this.auto_play = false});

  @override
  State<TweetVideo> createState() => _TweetVideoState();
}

class _TweetVideoState extends State<TweetVideo> {
  late VideoPlayerController _videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;
  late String _remainingTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _videoPlayerController = VideoPlayerController.asset(widget.video,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));
    _initializeVideoPlayerFuture =
        _videoPlayerController.initialize().then((_) {
      if (widget.auto_play) {
        _videoPlayerController.play();
      }
      // _videoPlayerController.play();
      _videoPlayerController.setLooping(true);

      Duration totalDuration = _videoPlayerController.value.duration;
      setState(() {
        _remainingTime =
            '${totalDuration.inMinutes}:${(totalDuration.inSeconds % 60).toString().padLeft(2, '0')}';
      });

      _videoPlayerController.addListener(() {
        if (_videoPlayerController.value.duration != null &&
            _videoPlayerController.value.position != null) {
          Duration remaining = _videoPlayerController.value.duration -
              _videoPlayerController.value.position;
          setState(() {
            _remainingTime =
                '${remaining.inMinutes}:${(remaining.inSeconds % 60).toString().padLeft(2, '0')}';
          });
        }
      });
    });

    _remainingTime = '';
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
  }

  String _getRemainingTime() {
    if (_videoPlayerController.value.duration == null ||
        _videoPlayerController.value.position == null) {
      return '';
    }
    Duration remaining = _videoPlayerController.value.duration -
        _videoPlayerController.value.position;
    return '${remaining.inMinutes}:${(remaining.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Stack(
            children: [
              Container(
                width: double.infinity,
                height: widget.height,
                child: AspectRatio(
                  aspectRatio: widget.aspect_ratio,
                  child: VideoPlayer(_videoPlayerController),
                ),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    _remainingTime,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
