import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:youtube_player/src/method_calls.dart';

import 'utils/enums.dart';
import 'utils/life_cycle.dart';

class _YoutubeControllerValue extends Equatable {
  final Duration? position;
  final Size? size;
  final YoutubePlayerStatus? youtubePlayerStatus;
  final bool buffering;
  final int? percentageBuffered;
  final Duration duration;

  const _YoutubeControllerValue({
    this.position,
    this.size,
    this.youtubePlayerStatus = YoutubePlayerStatus.notInitialized,
    this.percentageBuffered,
    this.buffering = false,
    this.duration = const Duration(),
  });

  double get aspectRatio {
    if (size != null) {
      return size!.width / size!.height;
    } else {
      return 1.0;
    }
  }

  _YoutubeControllerValue copywidth({
    Duration? position,
    Size? size,
    YoutubePlayerStatus? youtubePlayerStatus,
    bool? buffering,
    int? percentageBuffered,
    Duration? duration,
  }) {
    return _YoutubeControllerValue(
      buffering: buffering ?? this.buffering,
      duration: duration ?? this.duration,
      percentageBuffered: percentageBuffered ?? this.percentageBuffered,
      position: position ?? this.position,
      size: size ?? this.size,
      youtubePlayerStatus: youtubePlayerStatus ?? this.youtubePlayerStatus,
    );
  }

  @override
  List<Object?> get props => [
        position,
        size,
        youtubePlayerStatus,
        buffering,
        percentageBuffered,
        duration
      ];
}

class YoutubePlayerController extends ValueNotifier<_YoutubeControllerValue> {
  // YoutubePlayerController(_YoutubeControllerValue value) : super(value);

  YoutubePlayerController.links(
      {required String audioLink, required String videoLink})
      : _audioLink = audioLink,
        _videoLink = videoLink,
        super(const _YoutubeControllerValue());

  bool _isDisposed = false;
  int? _textureId;
  int? get textureId => _textureId;
  late final String _audioLink;
  late final String _videoLink;
  StreamSubscription<Map<String, dynamic>>? _eventSubscription;
  // Timer? _timer;
  late final YoutubePlayerAppLifeCycleObserver _appLifeCycleObserver;
  final Completer _readyToPlayInit = Completer();

  Future<void> initController() async {
    _appLifeCycleObserver = YoutubePlayerAppLifeCycleObserver(this);
    _textureId = await YoutubePlayerMethodCall.initSurface();
    await YoutubePlayerMethodCall.initPlayer(
        audioLink: _audioLink, videoLink: _videoLink);
    _eventSubscription =
        YoutubePlayerMethodCall.eventsFromPlatform(_textureId!).listen((event) {
      if (event['playerReady'] != null && event['playerReady'] == true) {
        value = value.copywidth(
            duration: Duration(milliseconds: event['duration'] as int));
        _readyToPlayInit.complete(null);
      }
      if (event["width"] != null && event["height"] != null) {
        value = value.copywidth(
          size: Size(
            (event["width"] as int).toDouble(),
            (event["height"] as int).toDouble(),
          ),
        );
      }

      switch (event['statusEvent']['playerStatus']) {
        case "state_ended":
          value = value.copywidth(
              youtubePlayerStatus: YoutubePlayerStatus.ended, buffering: false);
          break;
        case "state_idle":
          value = value.copywidth(
              youtubePlayerStatus: YoutubePlayerStatus.idle, buffering: false);
          break;
        case "state_buffering":
          value = value.copywidth(
              buffering: true,
              percentageBuffered: event["percentageBuffered"] as int);
          break;
      }
      if (value.youtubePlayerStatus == YoutubePlayerStatus.playing) {
        value = value.copywidth(buffering: false);
      }
    });
  }

  Future<void> play() async {
    if (!_readyToPlayInit.isCompleted && _isDisposed) return;
    final status = await YoutubePlayerMethodCall.getPlayerStaus(
        ChangeYoutubePlayeStatus.play);
    value = value.copywidth(youtubePlayerStatus: status);
  }

  Future<void> pause() async {
    if (!_readyToPlayInit.isCompleted && _isDisposed) return;
    final status = await YoutubePlayerMethodCall.getPlayerStaus(
        ChangeYoutubePlayeStatus.pause);
    value = value.copywidth(youtubePlayerStatus: status);
  }

  Future<void> stop() async {
    if (!_readyToPlayInit.isCompleted && _isDisposed) return;
    final status = await YoutubePlayerMethodCall.getPlayerStaus(
        ChangeYoutubePlayeStatus.stop);
    value = value.copywidth(youtubePlayerStatus: status);
  }

  Future<Duration> get position async {
    final position = await YoutubePlayerMethodCall.position();
    return Duration(milliseconds: position);
  }

  @override
  void dispose() {
    YoutubePlayerMethodCall.dispose();
    _appLifeCycleObserver.dispose();
    _eventSubscription!.cancel();
    _isDisposed = true;
    super.dispose();
  }
}
