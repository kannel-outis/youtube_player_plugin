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
      case YoutubePlayerVideoQuality.quality_144p:
        return "144p";
      default:
        return "Auto";
    }
  }
}

extension StringToQuality on String {
  YoutubePlayerVideoQuality get stringToQuality {
    switch (this) {
      case "1080p":
        return YoutubePlayerVideoQuality.quality_1080p;
      case "720p":
        return YoutubePlayerVideoQuality.quality_720p;
      case "480p":
        return YoutubePlayerVideoQuality.quality_480p;
      case "240p":
        return YoutubePlayerVideoQuality.quality_240p;
      case "144p":
        return YoutubePlayerVideoQuality.quality_144p;
      default:
        return YoutubePlayerVideoQuality.auto;
    }
  }
}
