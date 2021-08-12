import 'package:flutter/material.dart';
import 'package:youtube_player/youtube_player.dart';
import 'controls/control_bar_widget.dart';
import 'controls/progress_bar_widget.dart';
import 'controls/tool_bar_widget.dart';
import 'custom_slider.dart';

const _duration = Duration(milliseconds: 300);

// ignore_for_file: must_be_immutable, avoid_init_to_null
class YoutubePlayer extends StatefulWidget {
  final YoutubePlayerController controller;
  YoutubePlayer({Key? key, required this.controller}) : super(key: key);
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
  void deactivate() {
    widget.controller.dispose();
    super.deactivate();
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
          child: AspectRatio(
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
                        show: show,
                      ),

                  // control sec
                  widget._controls ??
                      ControlBarwidget(
                        controller: widget.controller,
                        show: show,
                      ),

                  // bottom buffer, progress, thumb and shit
                  widget._progress ??
                      ProgressSecWidget(
                        show: show,
                        animeController: _animeController,
                        controller: widget.controller,
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
