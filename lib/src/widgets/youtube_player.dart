import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:youtube_player/src/utils/extensions.dart';
import 'package:youtube_player/src/utils/typedef.dart';
import 'package:youtube_player/src/utils/youtube_player_colors.dart';
import 'package:youtube_player/src/widgets/inherited_state.dart';
import 'package:youtube_player/youtube_player.dart';
import 'controls/control_bar_widget.dart';
import 'controls/progress_bar_widget.dart';
import 'controls/tool_bar_widget.dart';
import 'sized_aspect_ratio_widget.dart';

const _duration = Duration(milliseconds: 100);

// ignore_for_file: must_be_immutable, avoid_init_to_null
class YoutubePlayer extends StatefulWidget {
  final YoutubePlayerController controller;
  final Size? size;
  final OnVisibilityChange? onVisibilityChange;
  final OnVideoQualityChange? onVideoQualityChange;

  YoutubePlayer({
    Key? key,
    required this.controller,
    this.onVisibilityChange,
    this.onVideoQualityChange,
    this.size,
    YoutubePlayerColors colors = const YoutubePlayerColors.auto(),
  })  : _colors = colors,
        super(key: key);
  YoutubePlayer.withControls({
    Key? key,
    required this.controller,
    required Widget toolBarControl,
    required Widget controls,
    required Widget progress,
    this.size,
    this.onVisibilityChange,
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
  YoutubePlayerVideoQuality quality = YoutubePlayerVideoQuality.auto;
  Timer? _ticker;
  bool show = true;
  @override
  void initState() {
    super.initState();
    quality = widget.controller.value.quality;
    widget.controller
      ..addListener(_listener)
      ..initController();
    _animeController = AnimationController(
      vsync: this,
      duration: _duration,
    )..addListener(_listener);
    setShowToFalseAfterTimer(12);
  }

  void setShowToFalseAfterTimer(int time) {
    if (show) {
      _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (timer.tick == time) {
          show = false;
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
        show = true;
        setState(() {});
      }
    }
  }

  @override
  void didUpdateWidget(covariant YoutubePlayer oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
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
    return InheritedState(
      show: show,
      controller: widget.controller,
      onVisibilityToggle: (newShowState) {
        show = newShowState;
        widget.onVisibilityChange?.call(show);
      },
      stateChange: (b) {
        show = b;
        setState(() {});
      },
      child: Stack(
        children: [
          SizedAspectRatioWidget(
            aspectRatio: widget.controller.value.aspectRatio,
            additionalSize: widget.size != null
                ? Size(widget.size!.width + 0, widget.size!.height + 30)
                : const Size(0, 30),
            child: Container(
              width: double.infinity,
              color: Colors.black,
              child: Player(widget.controller),
            ),
          ),
          AnimatedOpacity(
            duration: _duration,
            opacity: _animeController.value,
            child: SizedAspectRatioWidget(
              aspectRatio: widget.controller.value.aspectRatio,
              additionalSize: widget.size != null
                  ? Size(widget.size!.width + 0, widget.size!.height + 30)
                  : const Size(0, 30),
              child: Container(
                width: double.infinity,
                color: Colors.black.withOpacity(.3),
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onDoubleTap: () {
              show = false;
              _ticker?.cancel();
              _ticker = null;
              setState(() {});
              print("double Tap");
            },
            onTap: () {
              setState(() {
                if (show) {
                  show = false;
                  _ticker?.cancel();
                  _ticker = null;
                } else {
                  show = true;
                  setShowToFalseAfterTimer(10);
                }
              });
            },
            child: SizedAspectRatioWidget(
              additionalSize: widget.size != null
                  ? Size(widget.size!.width + 0, widget.size!.height + 36)
                  : const Size(0, 36),
              aspectRatio: widget.controller.value.aspectRatio,
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // tool bar
                    widget._toolBarControl ??
                        ToolBarWidget(
                          controller: widget.controller,
                          colors: widget.colors,
                        ),

                    // control sec
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: widget._controls ??
                          ControlBarwidget(
                            controller: widget.controller,
                            colors: widget.colors,
                          ),
                    ),

                    // bottom buffer, progress, thumb and shit
                    widget._progress ??
                        ProgressSecWidget(
                          // show: show,
                          animeController: _animeController,
                          controller: widget.controller,
                          colors: widget.colors,
                        ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
