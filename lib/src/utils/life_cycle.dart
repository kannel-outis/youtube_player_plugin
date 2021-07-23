import 'package:flutter/material.dart';
import 'package:youtube_player/src/controller.dart';
import 'package:youtube_player/youtube_player.dart';

class YoutubePlayerAppLifeCycleObserver extends WidgetsBindingObserver {
  YoutubePlayerAppLifeCycleObserver(this._controller);

  bool _wasPlayingBeforePause = false;
  final YoutubePlayerController _controller;

  void initialize() {
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        _wasPlayingBeforePause = _controller.value.youtubePlayerStatus ==
            YoutubePlayerStatus.playing;
        _controller.pause();
        break;
      case AppLifecycleState.resumed:
        if (_wasPlayingBeforePause) {
          _controller.play();
        }
        break;
      default:
    }
  }

  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
  }
}