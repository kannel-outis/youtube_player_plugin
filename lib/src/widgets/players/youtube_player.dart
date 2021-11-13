import 'dart:async';
import 'package:flutter/material.dart';
import 'package:youtube_player/src/utils/typedef.dart';
import 'package:youtube_player/src/utils/youtube_player_colors.dart';
import 'package:youtube_player/src/widgets/inherited_state.dart';
import 'package:youtube_player/src/widgets/players/full_screen_youtube_player.dart';
import 'package:youtube_player/youtube_player.dart';
import '../controls/control_bar_widget.dart';
import '../controls/progress_bar_widget.dart';
import '../controls/tool_bar_widget.dart';
import '../sized_aspect_ratio_widget.dart';
import '../time_toggle_widget.dart';

const _duration = Duration(milliseconds: 100);

// ignore_for_file: must_be_immutable, avoid_init_to_null
class YoutubePlayer extends StatefulWidget {
  final YoutubePlayerController controller;
  final Size? size;
  final OnVisibilityChange? onVisibilityChange;
  final OnVideoQualityChange? onVideoQualityChange;
  final bool completelyHideProgressBar;
  final Widget? timeStampAndToggleWidget;
  final bool hideProgressThumb;
  final double loadingWidth;
  final bool fullScreenOnRotation;
  final VoidCallback? toolBarMinimizeAction;
  final VoidCallback? next;
  final VoidCallback? prev;
  final VoidCallback? next;
  final VoidCallback? prev;

  YoutubePlayer({
    Key? key,
    required this.controller,
    this.onVisibilityChange,
    this.onVideoQualityChange,
    this.size,
    this.next,
    this.prev,
    this.next,
    this.prev,
    this.fullScreenOnRotation = false,
    this.loadingWidth = 17,
    this.timeStampAndToggleWidget,
    this.completelyHideProgressBar = false,
    this.hideProgressThumb = false,
    this.toolBarMinimizeAction,
    YoutubePlayerColors colors = const YoutubePlayerColors.auto(),
  })  : _colors = colors,
        super(key: key);
  YoutubePlayer.withControls({
    Key? key,
    required this.controller,
    Widget? toolBarControl,
    Widget? controls,
    Widget? progress,
    this.toolBarMinimizeAction,
    this.hideProgressThumb = false,
    this.completelyHideProgressBar = false,
    this.size,
    this.fullScreenOnRotation = false,
    this.loadingWidth = 17,
    this.timeStampAndToggleWidget,
    this.onVisibilityChange,
    this.next,
    this.prev,
    this.next,
    this.prev,
    this.onVideoQualityChange,
  })  : _toolBarControl = toolBarControl,
        _controls = controls,
        _progress = progress,
        super(key: key);
  late Widget? _toolBarControl = null;
  Widget? get toolbarControl => _toolBarControl;
  late Widget? _controls = null;
  Widget? get controls => _controls;
  late Widget? _progress = null;
  Widget? get progress => _progress;
  late YoutubePlayerColors _colors;
  YoutubePlayerColors get colors => _colors;

  @override
  _YoutubePlayerState createState() => _YoutubePlayerState();
}

class _YoutubePlayerState extends State<YoutubePlayer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animeController;
  bool showProgress = true;
  YoutubePlayerVideoQuality quality = YoutubePlayerVideoQuality.auto;
  Timer? _ticker;
  // bool show = true;
  @override
  void initState() {
    super.initState();
    quality = widget.controller.value.quality;
    widget.controller
      ..addListener(_listener)
      ..initPlayer();
    _animeController = AnimationController(
      vsync: this,
      duration: _duration,
    )..addListener(_listener);
    setShowToFalseAfterTimer(12);
  }

  void setShowToFalseAfterTimer(int time) {
    if (widget.controller.controlVisible) {
      _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (timer.tick == time) {
          widget.controller.showControl = false;
          setState(() {});
          _ticker?.cancel();
        }
      });
    }
  }

  int listenerCount = 0;

  void _listener() {
    if (mounted) setState(() {});
    if (quality != widget.controller.value.quality) {
      quality = widget.controller.value.quality;
      widget.onVideoQualityChange?.call(quality);
    } else if (widget.controller.value.youtubePlayerStatus ==
        YoutubePlayerStatus.playing) {
      listenerCount = 0;
    } else if (widget.controller.value.youtubePlayerStatus ==
        YoutubePlayerStatus.ended) {
      listenerCount++;
      if (listenerCount == 1) {
        widget.controller.showControl = true;
      }
    }
  }

  bool isPotrait(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.portrait;

  @override
  void didUpdateWidget(covariant YoutubePlayer oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (oldWidget.completelyHideProgressBar !=
            widget.completelyHideProgressBar ||
        oldWidget.hideProgressThumb != widget.hideProgressThumb ||
        widget.loadingWidth != oldWidget.loadingWidth ||
        widget.fullScreenOnRotation != oldWidget.fullScreenOnRotation) {
      setState(() {});
    }
    if (oldWidget.controller.videoId != widget.controller.videoId) {
      oldWidget.controller.removeListener(_listener);
      oldWidget.controller.dispose();
      widget.controller
        ..addListener(_listener)
        ..initPlayer();
    }
  }

  void _showProgress(BuildContext context) {
    if (!isPotrait(context)) {
      if (widget.controller.controlVisible == true) {
        showProgress = true;
      } else {
        showProgress = false;
      }
    } else {
      showProgress = true;
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _ticker = null;
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.controller.showControl = true;
    _showProgress(context);
    return InheritedState(
      loadingWidth: widget.loadingWidth,
      hideProgressThumb: widget.hideProgressThumb,
      show: widget.controller.controlVisible,
      showProgress: showProgress,
      controller: widget.controller,
      onVisibilityToggle: (newShowState) {
        widget.controller.showControl = newShowState;
        widget.onVisibilityChange?.call(widget.controller.controlVisible);
      },
      stateChange: (b) {
        widget.controller.showControl = b;
        _showProgress(context);
      },
      child: Stack(
        children: [
          //
          SizedAspectRatioWidget(
            aspectRatio: 16 / 9,
            additionalSize: widget.size != null
                ? Size(widget.size!.width, widget.size!.height)
                : const Size(0, 0),
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              color: Colors.black,
              child: AspectRatio(
                aspectRatio: widget.controller.value.aspectRatio,
                child: Player(widget.controller),
              ),
            ),
          ),
          AnimatedOpacity(
            duration: _duration,
            opacity: _animeController.value,
            child: SizedAspectRatioWidget(
              aspectRatio: 16 / 9,
              additionalSize: widget.size != null
                  ? Size(widget.size!.width, widget.size!.height)
                  : const Size(0, 0),
              child: Container(
                width: double.infinity,
                color: Colors.black.withOpacity(.3),
              ),
            ),
          ),
          Column(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onDoubleTap: () {
                  widget.controller.showControl = false;
                  _ticker?.cancel();
                  _ticker = null;
                  _showProgress(context);
                  setState(() {});
                },
                onTap: () {
                  setState(() {
                    if (widget.controller.controlVisible) {
                      widget.controller.showControl = false;
                      _ticker?.cancel();
                      _ticker = null;
                      _showProgress(context);
                    } else {
                      widget.controller.showControl = true;
                      setShowToFalseAfterTimer(10);
                      _showProgress(context);
                    }
                  });
                },
                child: SizedAspectRatioWidget(
                  additionalSize: widget.size != null
                      ? Size(widget.size!.width, widget.size!.height - 8.5)
                      // 8.5 for potrait , 85.5 for landscape
                      : const Size(0, -8.5),
                  aspectRatio: isPotrait(context) ? 16 / 9 : 16 / 7,
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // tool bar
                        Expanded(
                          child: widget._toolBarControl ??
                              ToolBarWidget(
                                onPressed: widget.toolBarMinimizeAction,
                                controller: widget.controller,
                                colors: widget.colors,
                              ),
                        ),

                        // control sec
                        Container(
                          // margin: const EdgeInsets.only(bottom: 20),
                          child: widget._controls ??
                              ControlBarwidget(
                                controller: widget.controller,
                                colors: widget.colors,
                                nextFunction: widget.next,
                                prevFunction: widget.prev,
                                nextFunction: widget.next,
                                prevFunction: widget.prev,
                              ),
                        ),

                        // bottom buffer, progress, thumb and shit

                        widget.timeStampAndToggleWidget ??
                            TimeStampAndFullScreenToggleWidget(
                              // show: show,
                              onOrientationToggle: (isPotrait) {
                                full(
                                  context,
                                  Material(
                                    child: FullScreenYoutubePlayer(
                                      controller: widget.controller,
                                      colors: widget.colors,
                                      onVideoQualityChange:
                                          widget.onVideoQualityChange,
                                      onVisibilityChange:
                                          widget.onVisibilityChange,
                                      timeStampAndToggleWidget:
                                          widget.timeStampAndToggleWidget,
                                      next: widget.next,
                                      prev: widget.prev,
                                      next: widget.next,
                                      prev: widget.prev,
                                    ),
                                  ),
                                );
                              },
                              animeController: _animeController,
                              controller: widget.controller,
                              colors: widget.colors,
                            ),
                      ],
                    ),
                  ),
                ),
              ),
              if (!widget.completelyHideProgressBar ||
                  showProgress && !isPotrait(context))
                widget._progress ??
                    ProgressSliderWidget(
                      animeController: _animeController,
                      colors: widget._colors,
                      controller: widget.controller,
                    )
              else
                const SizedBox(),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> full(BuildContext context, Widget child) async {
  await Navigator.of(context).push(
    PageRouteBuilder(
      opaque: false,
      settings: const RouteSettings(),
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return child;
      },
    ),
  );
}

// class _FullScreenOrientation extends StatelessWidget {
//   final double? height;
//   final double? width;
//   final bool fullScreenOnRotate;
//   // ignore: prefer_const_constructors_in_immutables
//   _FullScreenOrientation(
//       {Key? key,
//       required Widget child,
//       this.width,
//       this.height,
//       required this.fullScreenOnRotate})
//       : _child = child,
//         super(key: key);
//   late final Widget _child;
//   @override
//   Widget build(BuildContext context) {
//     if (!fullScreenOnRotate) {
//       return _child;
//     }
//     if (MediaQuery.of(context).orientation == Orientation.portrait) {
//       SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

//       return _child;
//     } else {
//       SystemChrome.setEnabledSystemUIOverlays([]);
//       return SizedBox(
//         height: height ?? MediaQuery.of(context).size.height,
//         width: width ?? MediaQuery.of(context).size.width,
//         child: _child,
//       );
//     }
//   }
// }
