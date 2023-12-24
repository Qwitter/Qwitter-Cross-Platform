import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_avatar.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_header.dart';
import 'package:qwitter_flutter_app/models/tweet.dart';
import 'package:qwitter_flutter_app/utils/date_humanizer.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class MessagingVideo extends StatefulWidget {
  final String video;
  final double height;
  final bool autoPlay;
  final bool fullScreen;

  MessagingVideo({
    required this.video,
    required this.height,
    this.autoPlay = false,
    this.fullScreen = false,
  });

  @override
  State<MessagingVideo> createState() => _TweetVideoState();
}

class _TweetVideoState extends State<MessagingVideo> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  late Future<void> _initializeVideoPlayerFuture;
  late String _remainingTime;
  double _sliderValue = 0.0;
  double _sliderMaxValue = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("vid:" + widget.video);
    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.video),
      videoPlayerOptions: VideoPlayerOptions(
        mixWithOthers: true,
      ),
    );

    _initializeVideoPlayerFuture =
        _videoPlayerController.initialize().then((_) {
      print("autoPlay:" + widget.autoPlay.toString());
      print("vid DS:" + _videoPlayerController.dataSource.toString());

      if (widget.autoPlay) {
        _videoPlayerController.play();
      }
      // _videoPlayerController.play();
      _videoPlayerController.setLooping(true);
      _videoPlayerController.setVolume(0.0);

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
          print("rem: " + remaining.inSeconds.toString());
          setState(() {
            _sliderMaxValue =
                _videoPlayerController.value.duration.inSeconds.toDouble();
            _remainingTime =
                '${remaining.inMinutes}:${(remaining.inSeconds % 60).toString().padLeft(2, '0')}';
          });
        }
        double duration =
            _videoPlayerController.value.duration.inSeconds.toDouble();
        double position =
            _videoPlayerController.value.position.inSeconds.toDouble();
        setState(() {
          _sliderValue = duration == 0 ? 0 : position / duration;
        });
      });
    }).onError((error, stackTrace) {
      print("error: " + error.toString());
      print("stackTrace: " + stackTrace.toString());
    });
    // _videoPlayerController.addListener(() {

    // });

    _remainingTime = '00:00';

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: widget.autoPlay,
      looping: true,
      allowFullScreen: true,
      allowMuting: true,
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
      deviceOrientationsOnEnterFullScreen: [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ],
      fullScreenByDefault: widget.fullScreen,
      aspectRatio: _videoPlayerController.value.aspectRatio,
      placeholder: Container(
        color: Colors.black,
      ),
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.white,
        handleColor: Colors.blue,
        bufferedColor: Colors.grey,
        backgroundColor: Colors.black,
      ),
      showControls: false, // Display Chewie's default controls
      // customControls: Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: ElevatedButton(
      //         onPressed: () {
      //           // Your action
      //         },
      //         child: Text('Custom Button'),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
    _chewieController.dispose();
  }

  @override
  void didPush() {
    if (mounted) {
      _videoPlayerController.pause(); // Pause video when navigating away
    }
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

  void _toggleVideoPlayback() {
    setState(() {
      if (_videoPlayerController.value.isPlaying) {
        _videoPlayerController.pause();
      } else {
        _videoPlayerController.play();
      }
    });
  }

  void _onVideoDrag(double value) {
    final Duration position = _videoPlayerController.value.duration * value;
    _videoPlayerController.seekTo(position);
    setState(() {
      _sliderValue = value;
    });
  }

  void _toggleMute() {
    if (_videoPlayerController.value.volume == 0.0) {
      // Unmute the video
      _videoPlayerController.setVolume(1.0);
    } else {
      // Mute the video
      _videoPlayerController.setVolume(0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(
        "stats: aspect" + _videoPlayerController.value.aspectRatio.toString());
    print("stats: width" + MediaQuery.of(context).size.width.toString());
    print("stats: height" +
        (MediaQuery.of(context).size.width /
                _videoPlayerController.value.aspectRatio)
            .toString());
    if (widget.video.isNotEmpty && _videoPlayerController != null) {
      return FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              child: Stack(
                children: [
                  !widget.fullScreen
                      ? Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                          child: VisibilityDetector(
                            key: Key(widget.video),
                            onVisibilityChanged: (visibilityInfo) {
                              if (visibilityInfo.visibleFraction < 1.0) {
                                _videoPlayerController.pause();
                              } else if (widget.autoPlay) {
                                _videoPlayerController.play();
                              } else {
                                _videoPlayerController.pause();
                              }
                            },
                            child: Container(
                              // width: double.infinity,
                              height: widget.height,
                              child: AspectRatio(
                                aspectRatio: _videoPlayerController.value.aspectRatio,
                                child: VideoPlayer(_videoPlayerController),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          child: Column(
                          children: [
                            Expanded(
                              child: widget.fullScreen
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              _videoPlayerController
                                                  .value.aspectRatio,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: VideoPlayer(
                                              _videoPlayerController),
                                        )
                                      ],
                                    )
                                  : SizedBox(
                                      width: double.infinity,
                                      child:
                                          VideoPlayer(_videoPlayerController),
                                    ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.15,
                            ),
                          ],
                        )),
                  widget.fullScreen
                      ? Positioned(
                          bottom: 10,
                          left: 0,
                          right: 0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: _toggleVideoPlayback,
                                      child: Container(
                                        child: Center(
                                          child: Icon(
                                            _videoPlayerController
                                                    .value.isPlaying
                                                ? Icons.pause
                                                : Icons.play_arrow,
                                            size: 25,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onHorizontalDragUpdate: (details) {
                                          final double dragPosition = details
                                                  .localPosition.dx /
                                              MediaQuery.of(context).size.width;
                                          _onVideoDrag(dragPosition);
                                        },
                                        child: SliderTheme(
                                          data: SliderThemeData(
                                            trackHeight: 1,
                                            thumbShape: RoundSliderThumbShape(
                                                enabledThumbRadius: 5),
                                            overlayShape:
                                                RoundSliderOverlayShape(
                                                    overlayRadius: 0),
                                            trackShape:
                                                RoundedRectSliderTrackShape(),
                                            allowedInteraction:
                                                SliderInteraction.slideOnly,
                                          ),
                                          child: Slider(
                                            min: 0,
                                            max: 1,
                                            value: _sliderValue,
                                            onChanged: _onVideoDrag,
                                            onChangeEnd: _onVideoDrag,
                                            activeColor: Colors.white,
                                            thumbColor: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        _videoPlayerController.value.volume ==
                                                0.0
                                            ? Icons.volume_off
                                            : Icons.volume_up,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      onPressed: _toggleMute,
                                    ),
                                    Text(
                                      _remainingTime,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  !widget.fullScreen
                      ? Positioned(
                          bottom: 10,
                          right: 10,
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                            ),
                            child: Text(
                              _remainingTime,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        )
                      : Positioned(
                          child: Container(),
                          bottom: 10,
                          right: 10,
                        ),
                  !widget.fullScreen
                      ? Positioned(
                          bottom: 10,
                          left: 10,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _toggleMute();
                              });
                            },
                            child: Container(
                              padding:
                                  EdgeInsets.all(8), // Adjust padding as needed
                              decoration: BoxDecoration(
                                shape:
                                    BoxShape.circle, // Shape of the background
                                color: Colors.black
                                    .withOpacity(0.5), // Background color
                              ),

                              child: Icon(
                                _videoPlayerController.value.volume == 0.0
                                    ? Icons.volume_off // Muted icon
                                    : Icons.volume_up, // Unmuted icon
                                color: Colors.white,
                                // background:
                                size: 15,
                              ),
                            ),
                          ),
                        )
                      : Positioned(
                          child: Container(),
                          bottom: 10,
                          right: 10,
                        ),
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
    } else {
      return Container(
        // You can provide a placeholder or message here
        child: Text('No valid video URL available'),
      );
    }
  }
}

