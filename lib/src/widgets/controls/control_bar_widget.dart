import 'package:flutter/material.dart';
import 'package:youtube_player/src/utils/utils.dart';
import 'package:youtube_player/src/utils/youtube_player_colors.dart';
import 'package:youtube_player/src/widgets/inherited_state.dart';
import 'package:youtube_player/youtube_player.dart';

class ControlBarwidget extends StatefulWidget {
  final YoutubePlayerController controller;
  final YoutubePlayerColors? colors;

  const ControlBarwidget({Key? key, required this.controller, this.colors})
      : super(key: key);

  @override
  _ControlBarwidgetState createState() => _ControlBarwidgetState();
}

class _ControlBarwidgetState extends State<ControlBarwidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anime;

  bool? shouldPlay;
  @override
  void initState() {
    super.initState();
    shouldPlay = widget.controller.value.youtubePlayerStatus ==
        YoutubePlayerStatus.initialized;
    setState(() => {});

    _anime = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    if (widget.controller.value.youtubePlayerStatus ==
        YoutubePlayerStatus.playing) {
      _anime.forward();
    }
  }

  @override
  void didUpdateWidget(covariant ControlBarwidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    shouldPlay = widget.controller.value.youtubePlayerStatus ==
        YoutubePlayerStatus.paused;
    // setState(() => {});

    if (widget.controller.value.youtubePlayerStatus ==
        YoutubePlayerStatus.ended) _anime.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final _inheritedState = InheritedState.of(context);
    return Expanded(
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (_inheritedState.show)
            Container(
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
                                      const Duration(seconds: 10)
                                          .inMilliseconds)
                                  .round(),
                            ),
                          );
                          if (widget.controller.value.youtubePlayerStatus ==
                              YoutubePlayerStatus.ended) _anime.forward();
                        },
                        child: Center(
                          child: SizedBox(
                            child: Icon(
                              Icons.replay_10_outlined,
                              size: Utils.blockWidth * 7 > 50
                                  ? 50
                                  : Utils.blockWidth * 7,
                              color: widget.colors!.iconsColor,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          child: widget.controller.value.buffering == true ||
                                  widget.controller.value.youtubePlayerStatus ==
                                      YoutubePlayerStatus.notInitialized
                              ? const SizedBox()
                              : widget.controller.value.youtubePlayerStatus !=
                                      YoutubePlayerStatus.ended
                                  ? InkWell(
                                      onTap: () {
                                        if (widget.controller.value
                                                    .youtubePlayerStatus ==
                                                YoutubePlayerStatus
                                                    .initialized ||
                                            widget.controller.value
                                                    .youtubePlayerStatus ==
                                                YoutubePlayerStatus.paused) {
                                          _anime.forward();
                                          widget.controller.play();
                                        } else if (widget.controller.value
                                                .youtubePlayerStatus ==
                                            YoutubePlayerStatus.playing) {
                                          _anime.reverse();
                                          widget.controller.pause();
                                        }
                                      },
                                      child: AnimatedIcon(
                                        progress: _anime,
                                        icon: AnimatedIcons.play_pause,
                                        color: widget.colors!.iconsColor,
                                        size: Utils.blockWidth * 8.5 > 55
                                            ? 55
                                            : Utils.blockWidth * 8.5,
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        widget.controller.seekTo(
                                          Duration(
                                            milliseconds: (const Duration()
                                                    .inMilliseconds)
                                                .round(),
                                          ),
                                        );
                                        _anime.forward();
                                        widget.controller.play();
                                      },
                                      child: Icon(
                                        Icons.replay,
                                        size: Utils.blockWidth * 8.5 > 55
                                            ? 55
                                            : Utils.blockWidth * 8.5,
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
                                      const Duration(seconds: 10)
                                          .inMilliseconds)
                                  .round(),
                            ),
                          );
                        },
                        child: Center(
                          child: SizedBox(
                            child: Icon(
                              Icons.forward_10_outlined,
                              size: Utils.blockWidth * 7 > 50
                                  ? 50
                                  : Utils.blockWidth * 7,
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
          else
            const SizedBox(),
          if (widget.controller.value.buffering == true ||
              widget.controller.value.youtubePlayerStatus ==
                  YoutubePlayerStatus.notInitialized)
            SizedBox(
              height: Utils.blockWidth * _inheritedState.loadingWidth,
              width: Utils.blockWidth * _inheritedState.loadingWidth,
              child: const CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            )
          else
            const SizedBox(),
        ],
      ),
    );
  }
}
