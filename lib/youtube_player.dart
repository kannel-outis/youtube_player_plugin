import 'dart:async';

import 'package:flutter/services.dart';

class YoutubePlayer {
  static const MethodChannel _channel = const MethodChannel('youtube_player');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<int> initState(
      {required double width, required double height}) async {
    final textureId = await _channel.invokeMethod("init", {
      "width": width,
      "height": height,
    });
    print(textureId.toString() + ":::::::::::::::");
    return textureId;
  }

  static Future<void> initPlayer(
      {required String audioLink, required String videoLink}) async {
    _channel.invokeMethod(
      "initPlayer",
      {
        "audio": audioLink,
        "video": videoLink,
      },
    );
  }

  static Future<void> dispose() async {
    await _channel.invokeMethod("dispose");
  }
}
