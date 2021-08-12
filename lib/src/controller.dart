import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:youtube_player/src/method_calls.dart';

import 'utils/enums.dart';
import 'utils/life_cycle.dart';

class _YoutubeControllerValue extends Equatable {
  final Duration position;
  final Size? size;
  final YoutubePlayerStatus? youtubePlayerStatus;
  final bool buffering;
  final int? percentageBuffered;
  final Duration bufferedPosition;
  final Duration duration;

  const _YoutubeControllerValue({
    this.position = const Duration(),
    this.size,
    this.youtubePlayerStatus = YoutubePlayerStatus.notInitialized,
    this.percentageBuffered,
    this.buffering = false,
    this.duration = const Duration(),
    this.bufferedPosition = const Duration(),
  });

  double get aspectRatio {
    if (size != null) {
      return size!.width / size!.height;
    } else {
      return 16 / 9;
    }
  }

  _YoutubeControllerValue copywidth({
    Duration? position,
    Size? size,
    YoutubePlayerStatus? youtubePlayerStatus,
    bool? buffering,
    int? percentageBuffered,
    Duration? duration,
    Duration? bufferedPosition,
  }) {
    return _YoutubeControllerValue(
      buffering: buffering ?? this.buffering,
      duration: duration ?? this.duration,
      percentageBuffered: percentageBuffered ?? this.percentageBuffered,
      position: position ?? this.position,
      size: size ?? this.size,
      youtubePlayerStatus: youtubePlayerStatus ?? this.youtubePlayerStatus,
      bufferedPosition: bufferedPosition ?? this.bufferedPosition,
    );
  }

  @override
  List<Object?> get props => [
        position,
        size,
        youtubePlayerStatus,
        buffering,
        percentageBuffered,
        duration,
        bufferedPosition,
      ];
}

class YoutubePlayerController extends ValueNotifier<_YoutubeControllerValue> {
  YoutubePlayerController.links(
      {required String audioLink, required String videoLink})
      : _audioLink = audioLink,
        _videoLink = videoLink,
        super(const _YoutubeControllerValue());
  YoutubePlayerController.link(
      {required String youtubeLink, String quality = "144p"})
      : _youtubeLink = youtubeLink,
        _quality = quality,
        super(const _YoutubeControllerValue());

  bool _isDisposed = false;
  int? _textureId;
  int? get textureId => _textureId;
  String? _youtubeLink;
  late final String _audioLink;
  late final String _videoLink;
  String? _quality;

  // ignore: cancel_subscriptions, use_late_for_private_fields_and_variables
  StreamSubscription<Map<String, dynamic>>? _eventSubscription;

  // ignore: use_late_for_private_fields_and_variables, avoid_init_to_null
  Timer? _timer = null;
  Timer? _bTimer;

  YoutubePlayerAppLifeCycleObserver? _appLifeCycleObserver;

  Completer? _readyToPlayInit;

  Future<void> initController() async {
    _appLifeCycleObserver = YoutubePlayerAppLifeCycleObserver(this)
      ..initialize();
    _textureId = await YoutubePlayerMethodCall.initSurface();
    if (_youtubeLink != null) {
      await YoutubePlayerMethodCall.initPlayer(
              youtubeLink: _youtubeLink, quality: _quality)
          .then((_) {
        if (_ == true) {}
      });
    } else {
      await YoutubePlayerMethodCall.initPlayer(
              audioLink: _audioLink, videoLink: _videoLink, quality: _quality)
          .then((_) {
        if (_ == true) {}
      });
    }

    _eventSubscription =
        YoutubePlayerMethodCall.eventsFromPlatform(_textureId!).listen((event) {
      _readyToPlayInit = Completer();

      if (event.containsKey("playerReady") && event['playerReady'] == true) {
        value = value.copywidth(
            duration: Duration(milliseconds: event['duration'] as int),
            youtubePlayerStatus: YoutubePlayerStatus.initialized);
        _bTimer = Timer.periodic(const Duration(milliseconds: 500), _bTicker);
        _readyToPlayInit!.complete(null);
      }
      if (event["width"] != null && event["height"] != null) {
        value = value.copywidth(
          size: Size(
            (event["width"] as int).toDouble(),
            (event["height"] as int).toDouble(),
          ),
        );
      }
      if (event.containsKey("statusEvent")) {
        switch (event['statusEvent']['playerStatus']) {
          case "state_ended":
            value = value.copywidth(
                youtubePlayerStatus: YoutubePlayerStatus.ended,
                buffering: false);
            _timer?.cancel();
            _bTimer?.cancel();
            // _bTimer?.cancel();
            break;
          case "state_idle":
            value = value.copywidth(
                youtubePlayerStatus: YoutubePlayerStatus.idle,
                buffering: false);
            break;
          case "state_buffering":
            value = value.copywidth(
                buffering: true,
                youtubePlayerStatus: YoutubePlayerStatus.bufferring);
            break;
          case "state_ready":
            value = value.copywidth(
                youtubePlayerStatus: YoutubePlayerStatus.initialized,
                buffering: false);
            break;
        }
      }

      if (value.youtubePlayerStatus == YoutubePlayerStatus.playing) {
        value = value.copywidth(buffering: false);
      }
    });
  }

  Future<void> _bTicker(Timer timer) async {
    if (_isDisposed) {
      _bTimer?.cancel();
      return;
    }
    final _bPosition = await bufferedPosition;
    if (_bPosition == value.duration) _bTimer?.cancel();
    value = value.copywidth(bufferedPosition: _bPosition);
  }

  YoutubePlayerStatus? _status;

  Future<void> play() async {
    if (!_readyToPlayInit!.isCompleted && _isDisposed) return;
    _status = await YoutubePlayerMethodCall.getPlayerStaus(
        ChangeYoutubePlayeStatus.play);
    _timer = Timer.periodic(const Duration(milliseconds: 300), _ticker);
  }

  Future<void> _ticker(Timer timer) async {
    if (_isDisposed) {
      _timer?.cancel();
      return;
    }
    final _position = await position();
    // final _bPosition = await bufferedPosition;
    value = value.copywidth(
      youtubePlayerStatus: _status,
      position: _position,
      // bufferedPosition: _bPosition,
    );
  }

  Future<void> pause() async {
    if (!_readyToPlayInit!.isCompleted && _isDisposed) return;
    _status = await YoutubePlayerMethodCall.getPlayerStaus(
        ChangeYoutubePlayeStatus.pause);
    value = value.copywidth(youtubePlayerStatus: _status);
    if (_timer != null) _timer!.cancel();
  }

  Future<void> stop() async {
    if (!_readyToPlayInit!.isCompleted && _isDisposed) return;
    _status = await YoutubePlayerMethodCall.getPlayerStaus(
        ChangeYoutubePlayeStatus.stop);
    value = value.copywidth(youtubePlayerStatus: _status);
    _timer!.cancel();
    _bTimer?.cancel();
  }

  Future<Duration> position() async {
    final position = await YoutubePlayerMethodCall.position();
    return Duration(milliseconds: position);
  }

  Future<Duration> get bufferedPosition async {
    final bPosition = await YoutubePlayerMethodCall.bufferedPosition();
    return Duration(milliseconds: bPosition);
  }

  Future<void> seekTo(Duration duration) async {
    if (duration < const Duration()) {
      value = value.copywidth(position: const Duration());
      await YoutubePlayerMethodCall.seekTo(const Duration());
    } else if (duration > value.duration) {
      value = value.copywidth(position: value.duration);
      await YoutubePlayerMethodCall.seekTo(value.duration);
    }
    value = value.copywidth(position: duration);
    await YoutubePlayerMethodCall.seekTo(duration);
  }

  @override
  void dispose() {
    YoutubePlayerMethodCall.dispose();
    _appLifeCycleObserver!.dispose();
    _eventSubscription!.cancel();
    _bTimer?.cancel();
    _timer?.cancel();
    _isDisposed = true;
    super.dispose();
  }
}
