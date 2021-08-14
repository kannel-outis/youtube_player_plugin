import 'package:flutter/material.dart';
import 'package:youtube_player/src/utils/utils.dart';
import 'package:youtube_player/src/utils/youtube_player_colors.dart';
import 'package:youtube_player/youtube_player.dart';
import 'controls/control_bar_widget.dart';
import 'controls/progress_bar_widget.dart';
import 'sized_aspect_ratio_widget.dart';
import 'controls/tool_bar_widget.dart';

const _duration = Duration(milliseconds: 300);

// ignore_for_file: must_be_immutable, avoid_init_to_null
class YoutubePlayer extends StatefulWidget {
  final YoutubePlayerController controller;

  YoutubePlayer({
    Key? key,
    required this.controller,
    YoutubePlayerColors colors = const YoutubePlayerColors.auto(),
  })  : _colors = colors,
        super(key: key);
  YoutubePlayer.withControls({
    Key? key,
    required this.controller,
    required Widget toolBarControl,
    required Widget controls,
    required Widget progress,
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
  bool show = true;
  @override
  void initState() {
    super.initState();
    widget.controller
      ..addListener(_listener)
      ..initController();
    _animeController = AnimationController(
      vsync: this,
      duration: _duration,
    )..addListener(_listener);

    _animeController.forward();
  }

  void _listener() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: widget.controller.value.aspectRatio,
          child: Container(
            width: double.infinity,
            color: Colors.black,
            child: Player(widget.controller),
          ),
        ),
        AnimatedOpacity(
          duration: _duration,
          opacity: _animeController.value,
          child: AspectRatio(
            aspectRatio: widget.controller.value.aspectRatio,
            child: Container(
              width: double.infinity,
              color: Colors.black.withOpacity(.3),
            ),
          ),
        ),
        GestureDetector(
          // behavior: HitTestBehavior.opaque,
          // onDoubleTap: () {
          //   show = false;
          //   setState(() {});
          // },
          // onTap: () {
          //   setState(() {
          //     if (show) {
          //       show = false;
          //     } else {
          //       show = true;
          //     }
          //   });
          // },
          child: SizedAspectRatioWidget(
            additionalSize: const Size(0, 6),
            aspectRatio: widget.controller.value.aspectRatio,
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // tool bar
                  widget._toolBarControl ??
                      Container(
                        padding: const EdgeInsets.only(top: 10),
                        child: ToolBarWidget(
                          controller: widget.controller,
                          show: show,
                          colors: widget.colors,
                        ),
                      ),

                  // control sec
                  widget._controls ??
                      ControlBarwidget(
                        controller: widget.controller,
                        show: show,
                        colors: widget.colors,
                      ),

                  // bottom buffer, progress, thumb and shit
                  widget._progress ??
                      ProgressSecWidget(
                        show: show,
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
    );
  }
}
