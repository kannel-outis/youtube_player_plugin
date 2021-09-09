import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:youtube_player/src/method_calls.dart';
import 'package:youtube_player/youtube_player.dart';

import 'utils/enums.dart';
import 'utils/extensions.dart';
import 'utils/life_cycle.dart';

//ignore_for_file: use_late_for_private_fields_and_variables, avoid_init_to_null, cancel_subscriptions
class _YoutubeControllerValue extends Equatable {
  final Duration position;
  final Size? size;
  final YoutubePlayerStatus? youtubePlayerStatus;
  final bool buffering;
  final int? percentageBuffered;
  final Duration bufferedPosition;
  final Duration duration;
  final YoutubePlayerVideoQuality quality;

  const _YoutubeControllerValue(
      {this.position = const Duration(),
      this.size,
      this.youtubePlayerStatus = YoutubePlayerStatus.notInitialized,
      this.percentageBuffered,
      this.buffering = false,
      this.duration = const Duration(),
      this.bufferedPosition = const Duration(),
      this.quality = YoutubePlayerVideoQuality.auto});

  double get aspectRatio {
    if (size != null) {
      return size!.width / size!.height;
    } else {
      // return 16 / 7.4;
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
    YoutubePlayerVideoQuality? quality,
  }) {
    return _YoutubeControllerValue(
      buffering: buffering ?? this.buffering,
      duration: duration ?? this.duration,
      percentageBuffered: percentageBuffered ?? this.percentageBuffered,
      position: position ?? this.position,
      size: size ?? this.size,
      youtubePlayerStatus: youtubePlayerStatus ?? this.youtubePlayerStatus,
      bufferedPosition: bufferedPosition ?? this.bufferedPosition,
      quality: quality ?? this.quality,
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
      {required String audioLink,
      required String videoLink,
      required YoutubePlayerVideoQuality quality})
      : _audioLink = audioLink,
        _videoLink = videoLink,
        _quality = quality.qualityToString,
        super(const _YoutubeControllerValue());
  YoutubePlayerController.link(
      {required String youtubeLink, required YoutubePlayerVideoQuality quality})
      : _youtubeLink = youtubeLink,
        _quality = quality.qualityToString,
        super(const _YoutubeControllerValue());

  bool get isDisposed => _isDisposed;
  bool get isInitialized =>
      value.youtubePlayerStatus == YoutubePlayerStatus.initialized;
  bool get videoEnded => value.youtubePlayerStatus == YoutubePlayerStatus.ended;
  bool _isDisposed = false;
  int? _textureId;
  int? get textureId => _textureId;
  String? get youtubeLink => _youtubeLink;
  String? _youtubeLink;
  late final String _audioLink;
  late final String _videoLink;
  late final String _quality;

  StreamSubscription<Map<String, dynamic>>? _eventSubscription;

  Timer? _timer = null;
  Timer? _bTimer;

  YoutubePlayerAppLifeCycleObserver? _appLifeCycleObserver;

  Completer? _readyToPlayInit;

  bool _showController = false;

  bool get controlVisible => _showController;

  set showControl(bool toggle) {
    _showController = toggle;
  }

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
        final quality = event["quality"] as String;

        value = value.copywidth(
            duration: Duration(milliseconds: event['duration'] as int),
            youtubePlayerStatus: YoutubePlayerStatus.initialized,
            quality: quality.stringToQuality);
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
    _timer = Timer.periodic(const Duration(milliseconds: 500), _ticker);
  }

  Future<void> _ticker(Timer timer) async {
    if (_isDisposed) {
      _timer?.cancel();
      return;
    }
    final _position = await position();
    // final _bPosition = await bufferedPosition;
    if (value.youtubePlayerStatus == YoutubePlayerStatus.ended) {
      _status = YoutubePlayerStatus.ended;
      _timer?.cancel();
    }
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

  Future<void> videoQualityChange(
      {String? audioLink,
      String? videoLink,
      String? youtubeLink,
      required YoutubePlayerVideoQuality quality}) async {
    await YoutubePlayerMethodCall.videoQualityChange(
        audioLink: audioLink,
        quality: quality.qualityToString,
        videoLink: videoLink,
        youtubeLink: youtubeLink);
  }

  String? get videoId {
    if (_youtubeLink != null) {
      final regex = RegExp(
          r'.*(?:(?:youtu\.be\/|v\/|vi\/|u\/\w\/|embed\/)|(?:(?:watch)?\?v(?:i)?=|\&v(?:i)?=))([^#\&\?]*).*');
      return regex.firstMatch(_youtubeLink!)?.group(1);
    }
    return null;
  }

  @override
  void dispose() {
    _appLifeCycleObserver!.dispose();
    _eventSubscription!.cancel();
    _bTimer?.cancel();
    _timer?.cancel();
    YoutubePlayerMethodCall.dispose();
    _isDisposed = true;
    super.dispose();
  }
}
