import 'package:flutter/widgets.dart';
import 'package:youtube_player/src/controller.dart';
import 'package:youtube_player/src/utils/typedef.dart';
import 'package:youtube_player/youtube_player.dart';

class InheritedState extends InheritedWidget {
  final bool show;
  final YoutubePlayerController? controller;
  final OnVisibilityToggle? onVisibilityToggle;
  final Function(bool)? stateChange;

  const InheritedState({
    this.onVisibilityToggle,
    this.show = false,
    this.controller,
    this.stateChange,
    required Widget child,
    Key? key,
  }) : super(child: child, key: key);

  static InheritedState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<InheritedState>()!;

  @override
  bool updateShouldNotify(covariant InheritedState oldWidget) {
    if (show != oldWidget.show) {
      onVisibilityToggle?.call(show);
    }

    return show != oldWidget.show;
  }
}
