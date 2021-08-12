import 'package:flutter/material.dart';
import 'package:youtube_player/youtube_player.dart';

class ControlBarwidget extends StatefulWidget {
  final YoutubePlayerController controller;
  final bool show;

  const ControlBarwidget(
      {Key? key, required this.controller, this.show = false})
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
        ? SizedBox(
            width: 320,
            child: Center(
              child: InkWell(
                onTap: () {
                  return;
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                      child: const Center(
                        child: SizedBox(
                          height: 60,
                          width: 60,
                          child: Icon(Icons.replay_10_outlined, size: 40),
                        ),
                      ),
                    ),
                    const SizedBox(width: 70),
                    InkWell(
                      onTap: () {
                        if (widget.controller.value.youtubePlayerStatus ==
                                YoutubePlayerStatus.initialized ||
                            widget.controller.value.youtubePlayerStatus ==
                                YoutubePlayerStatus.paused) {
                          print(shouldPlay);
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
                          height: 60,
                          width: 60,
                          child: widget.controller.value.buffering == true ||
                                  widget.controller.value.youtubePlayerStatus ==
                                      YoutubePlayerStatus.notInitialized
                              ? const CircularProgressIndicator(
                                  strokeWidth: 1,
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                )
                              : AnimatedIcon(
                                  progress: _anime,
                                  icon: AnimatedIcons.play_pause,
                                  size: 50,
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 70),
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
                      child: const Center(
                        child: SizedBox(
                          height: 60,
                          width: 60,
                          child: Icon(Icons.forward_10_outlined, size: 40),
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
