import 'package:flutter/material.dart';
import 'package:youtube_player/youtube_player.dart';
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
  })   : _toolBarControl = toolBarControl,
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
        Container(
          height: 350 - 8.5,
          width: double.infinity,
          color: Colors.black,
          child: Player(widget.controller),
        ),
        AnimatedOpacity(
          duration: _duration,
          opacity: _animeController.value,
          child: Container(
            height: 350 - 8.5,
            width: double.infinity,
            color: Colors.black.withOpacity(.3),
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onDoubleTap: () {
            show = false;
            setState(() {});
          },
          onTap: () {
            setState(() {
              if (show) {
                show = false;
              } else {
                show = true;
              }
            });
          },
          child: SizedBox(
            height: 350,
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
      ],
    );
  }
}

class ToolBarWidget extends StatefulWidget {
  final bool show;
  final YoutubePlayerController? controller;
  const ToolBarWidget({Key? key, this.controller, this.show = false})
      : super(key: key);

  @override
  _ToolBarWidgetState createState() => _ToolBarWidgetState();
}

class _ToolBarWidgetState extends State<ToolBarWidget> {
  bool? _show;

  @override
  void initState() {
    super.initState();
    _show = widget.show;
  }

  @override
  void didUpdateWidget(covariant ToolBarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.show != widget.show) {
      _show = widget.show;
      setState(() => {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return _show != null && _show!
        ? Container(
            height: 35,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.expand_more_outlined),
                SizedBox(
                  width: 70,
                  child: Row(
                    children: const [
                      Icon(Icons.more_vert),
                      Expanded(child: SizedBox()),
                      Icon(
                        Icons.close,
                        size: 20,
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        : const SizedBox(height: 35);
  }
}

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
                          child: AnimatedIcon(
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

class ProgressSecWidget extends StatefulWidget {
  final YoutubePlayerController controller;
  final bool? show;
  final AnimationController? animeController;

  const ProgressSecWidget(
      {Key? key, required this.controller, this.show, this.animeController})
      : super(key: key);

  @override
  _ProgressSecWidgetState createState() => _ProgressSecWidgetState();
}

class _ProgressSecWidgetState extends State<ProgressSecWidget> {
  @override
  void initState() {
    super.initState();
    if (widget.show != null && widget.show! == true) {
      widget.animeController!.forward();
    } else if (widget.show == false) {
      widget.animeController!.reverse();
    }
  }

  @override
  void didUpdateWidget(covariant ProgressSecWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.show! != widget.show) {
      if (widget.show != null && widget.show! == true) {
        widget.animeController!.forward();
      } else if (widget.show == false) {
        widget.animeController!.reverse();
      }

      // if (oldWidget.controller.value.duration !=
      //     widget.controller.value.duration) {
      //   setState(() {});
      // }
    }
  }

  String _timerStringRep(String time) {
    if (time.isEmpty) return "00.00";
    final s = time.split(".");
    s.removeAt(s.length - 1);
    final y = s.join().split(":");
    if (int.tryParse(y.first) != null && int.tryParse(y.first)! > 0) {
      return y.join(":");
    } else {
      y.removeAt(0);
      return y.join(":");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  Text(
                    "${_timerStringRep(widget.controller.value.position.toString())} /",
                    style: const TextStyle(fontSize: 15),
                  ),
                  Text(
                    " ${_timerStringRep(widget.controller.value.duration.toString())}",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white.withOpacity(.5),
                    ),
                  )
                ]),
                Icon(
                  Icons.fullscreen,
                  size: 23,
                  color: Colors.white.withOpacity(.8),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 15,
            child: CustomSliderForPlayer(
              // 15.0
              thumbSize: 15.0 * widget.animeController!.value,
              value: widget.controller.value.duration != const Duration()
                  ? widget.controller.value.position.inMilliseconds /
                      widget.controller.value.duration.inMilliseconds
                  : 0.0,
              bufferedValue: widget.controller.value.duration !=
                      const Duration()
                  ? widget.controller.value.bufferedPosition.inMilliseconds /
                      widget.controller.value.duration.inMilliseconds
                  : 0.0,
              progressBarColor: Colors.red,
              barColor: Colors.white.withOpacity(.25),
              bufferedColor: Colors.white.withOpacity(.5),
              thumbColor: Colors.red,
              seekTo: (value) {
                widget.controller.seekTo(
                  Duration(
                    milliseconds:
                        (widget.controller.value.duration.inMilliseconds *
                                value)
                            .round(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
