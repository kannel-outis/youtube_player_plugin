import 'package:flutter/material.dart';
import 'package:youtube_player/src/utils/utils.dart';
import 'package:youtube_player/src/utils/youtube_player_colors.dart';
import 'package:youtube_player/youtube_player.dart';

class ControlBarwidget extends StatefulWidget {
  final YoutubePlayerController controller;
  final bool show;
  final YoutubePlayerColors? colors;

  const ControlBarwidget(
      {Key? key, required this.controller, this.show = false, this.colors})
      : super(key: key);

  @override
  _ControlBarwidgetState createState() => _ControlBarwidgetState();
}

class _ControlBarwidgetState extends State<ControlBarwidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anime;
  bool? _show;

  bool? shouldPlay;
  @override
  void initState() {
    super.initState();
    _show = widget.show;
    shouldPlay = widget.controller.value.youtubePlayerStatus ==
        YoutubePlayerStatus.initialized;
    setState(() => {});

    _anime = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void didUpdateWidget(covariant ControlBarwidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    shouldPlay = widget.controller.value.youtubePlayerStatus ==
        YoutubePlayerStatus.paused;
    setState(() => {});

    if (widget.controller.value.youtubePlayerStatus ==
        YoutubePlayerStatus.ended) _anime.reverse();

    if (oldWidget.show != widget.show) {
      _show = widget.show;
      setState(() => {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return _show != null && _show!
        ? Container(
            // color: Colors.pink,
            width: Utils.blockWidth * 50,
            constraints: BoxConstraints(
              maxWidth: Utils.blockWidth * 60 > 350 ? 300 : 200,
              // minWidth: 250,
            ),
            child: Center(
              child: InkWell(
                onTap: () {
                  return;
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        widget.controller.seekTo(
                          Duration(
                            milliseconds: (widget.controller.value.position
                                        .inMilliseconds -
                                    const Duration(seconds: 10).inMilliseconds)
                                .round(),
                          ),
                        );
                      },
                      child: Center(
                        child: SizedBox(
                          child: Icon(
                            Icons.replay_10_outlined,
                            size: Utils.blockWidth * 8 > 50
                                ? 50
                                : Utils.blockWidth * 8,
                            color: widget.colors!.iconsColor,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (widget.controller.value.youtubePlayerStatus ==
                                YoutubePlayerStatus.initialized ||
                            widget.controller.value.youtubePlayerStatus ==
                                YoutubePlayerStatus.paused) {
                          _anime.forward();
                          widget.controller.play();
                        } else if (widget
                                .controller.value.youtubePlayerStatus ==
                            YoutubePlayerStatus.playing) {
                          _anime.reverse();
                          widget.controller.pause();
                        }
                      },
                      child: Center(
                        child: SizedBox(
                          child: widget.controller.value.buffering == true ||
                                  widget.controller.value.youtubePlayerStatus ==
                                      YoutubePlayerStatus.notInitialized
                              ? SizedBox(
                                  height: Utils.blockWidth * 10,
                                  width: Utils.blockWidth * 10,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.white),
                                  ),
                                )
                              : AnimatedIcon(
                                  progress: _anime,
                                  icon: AnimatedIcons.play_pause,
                                  color: widget.colors!.iconsColor,
                                  size: Utils.blockWidth * 10 > 55
                                      ? 55
                                      : Utils.blockWidth * 10,
                                ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        widget.controller.seekTo(
                          Duration(
                            milliseconds: (widget.controller.value.position
                                        .inMilliseconds +
                                    const Duration(seconds: 10).inMilliseconds)
                                .round(),
                          ),
                        );
                      },
                      child: Center(
                        child: SizedBox(
                          child: Icon(
                            Icons.forward_10_outlined,
                            size: Utils.blockWidth * 8 > 50
                                ? 50
                                : Utils.blockWidth * 8,
                            color: widget.colors!.iconsColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : const SizedBox();
  }
}
