import 'dart:async';

import 'package:flutter/services.dart';

import 'utils/enums.dart';

// ignore: avoid_classes_with_only_static_members
class YoutubePlayerMethodCall {
  static const MethodChannel _channel = MethodChannel('youtube_player');

  static Future<String> get platformVersion async {
    final String version =
        await _channel.invokeMethod('getPlatformVersion') as String;
    return version;
  }

  static Future<int> initSurface() async {
    final textureId = await _channel.invokeMethod("initSurface");
    print("${textureId.toString()}:::::::::::::::");
    return textureId as int;
  }

  static Future<bool> initPlayer(
      {required String audioLink, required String videoLink}) async {
    final readyToPlay = await _channel.invokeMethod(
      "initPlayer",
      {
        "audio": audioLink,
        "video": videoLink,
      },
    ) as bool;
    return readyToPlay;
  }

  static Future<void> dispose() async {
    await _channel.invokeMethod("dispose");
  }

  static Stream<Map<String, dynamic>> eventsFromPlatform(int textureId) {
    final event = EventChannel("youtube-player + $textureId")
        .receiveBroadcastStream()
        .map((event) => (event as Map)
            .map((key, value) => MapEntry(key as String, value as dynamic)));
    return event;
  }

  static Future<YoutubePlayerStatus> getPlayerStaus(
      ChangeYoutubePlayeStatus changeStatus) async {
    late final YoutubePlayerStatus youtubeStatus;
    switch (changeStatus) {
      case ChangeYoutubePlayeStatus.play:
        final status = await _channel.invokeMethod("play");
        if (status["status"] == "playing") {
          youtubeStatus = YoutubePlayerStatus.playing;
        }
        break;
      case ChangeYoutubePlayeStatus.pause:
        final status = await _channel.invokeMethod("pause");
        print(status);
        if (status["status"] == "paused") {
          youtubeStatus = YoutubePlayerStatus.paused;
        }
        break;
      default:
        final status = await _channel.invokeMethod("stop");
        if (status["status"] == "stopped") {
          youtubeStatus = YoutubePlayerStatus.stopped;
        }
    }
    return youtubeStatus;
  }

  static Future<void> seekTo(Duration duration) async {
    await _channel.invokeMethod(
      "seekTo",
      {
        "duration": duration.inMilliseconds,
      },
    );
  }

  static Future<int> position() async {
    return await _channel.invokeMethod("position") as int;
  }

  static Future<int> bufferedPosition() async {
    return await _channel.invokeMethod("bufferedPosition") as int;
  }

  ///////////////////
  static Future<void> doSomethingSilly(String link) async {
    await _channel.invokeMethod("doSomethingSilly", {
      "link": link,
    });
  }
}
