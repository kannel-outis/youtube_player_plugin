import 'package:flutter/material.dart';

class YoutubePlayerColors {
  final Color? bufferedColor;
  final Color? progressColor;
  final Color? barColor;
  final Color? thumbColor;
  final Color? iconsColor;
  final Color? positionTextColor;
  final Color? durationTextColor;

  const YoutubePlayerColors({
    this.bufferedColor,
    this.progressColor,
    this.barColor,
    this.thumbColor,
    this.iconsColor,
    this.positionTextColor,
    this.durationTextColor,
  });

  const YoutubePlayerColors.auto({
    this.bufferedColor = Colors.white,
    this.progressColor = Colors.red,
    this.thumbColor = Colors.red,
    this.iconsColor = Colors.white,
    this.barColor = Colors.white,
    this.positionTextColor = Colors.white,
    this.durationTextColor = Colors.white,
  });
}
