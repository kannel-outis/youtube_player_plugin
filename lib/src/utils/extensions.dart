import 'enums.dart';

extension QualityToString on YoutubePlayerVideoQuality {
  String get qualityToString {
    switch (this) {
      case YoutubePlayerVideoQuality.quality_1080p:
        return "1080p";
      case YoutubePlayerVideoQuality.quality_720p:
        return "720p";
      case YoutubePlayerVideoQuality.quality_480p:
        return "480p";
      case YoutubePlayerVideoQuality.quality_240p:
        return "240p";
      default:
        return "144p";
    }
  }
}
