import 'package:flutter/material.dart';
import 'package:youtube_player/src/utils/utils.dart';
import 'package:youtube_player/src/utils/youtube_player_colors.dart';
import 'package:youtube_player/youtube_player.dart';

import '../custom_slider.dart';

class ProgressSecWidget extends StatefulWidget {
  final YoutubePlayerController controller;
  final bool show;
  final AnimationController? animeController;
  final YoutubePlayerColors? colors;

  const ProgressSecWidget(
      {Key? key,
      required this.controller,
      this.show = false,
      this.animeController,
      this.colors})
      : super(key: key);

  @override
  _ProgressSecWidgetState createState() => _ProgressSecWidgetState();
}

class _ProgressSecWidgetState extends State<ProgressSecWidget> {
  @override
  void initState() {
    super.initState();
    if (widget.show == true) {
      widget.animeController!.forward();
    } else if (widget.show == false) {
      widget.animeController!.reverse();
    }
  }

  @override
  void didUpdateWidget(covariant ProgressSecWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.show != widget.show) {
      if (widget.show == true) {
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
            child: widget.show
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        Text(
                          "${_timerStringRep(widget.controller.value.position.toString())} /",
                          style: TextStyle(
                            fontSize: Utils.blockWidth * 2.5 > 25
                                ? 25
                                : Utils.blockWidth * 2.5,
                            color: Colors.white.withOpacity(.8),
                          ),
                        ),
                        Text(
                          " ${_timerStringRep(widget.controller.value.duration.toString())}",
                          style: TextStyle(
                            fontSize: Utils.blockWidth * 2.5 > 25
                                ? 25
                                : Utils.blockWidth * 2.5,
                            color: Colors.white.withOpacity(.5),
                          ),
                        )
                      ]),
                      Icon(
                        Icons.fullscreen,
                        size: Utils.blockWidth * 3.5 > 30
                            ? 30
                            : Utils.blockWidth * 3.5,
                        color: widget.colors!.iconsColor!.withOpacity(.8),
                      )
                    ],
                  )
                : const SizedBox(),
          ),
          SizedBox(height: Utils.blockHeight * 1.3),
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
              progressBarColor: widget.colors!.progressColor!,
              barColor: widget.colors!.barColor!.withOpacity(.25),
              bufferedColor: widget.colors!.bufferedColor!.withOpacity(.5),
              thumbColor: widget.colors!.thumbColor!,
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
