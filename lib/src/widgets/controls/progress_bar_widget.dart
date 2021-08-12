import 'package:flutter/material.dart';
import 'package:youtube_player/youtube_player.dart';

import '../custom_slider.dart';

class ProgressSecWidget extends StatefulWidget {
  final YoutubePlayerController controller;
  final bool show;
  final AnimationController? animeController;

  const ProgressSecWidget(
      {Key? key,
      required this.controller,
      this.show = false,
      this.animeController})
      : super(key: key);

  @override
  _ProgressSecWidgetState createState() => _ProgressSecWidgetState();
}

class _ProgressSecWidgetState extends State<ProgressSecWidget> {
  @override
  void initState() {
    super.initState();
    if (widget.show != null && widget.show == true) {
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
                  )
                : const SizedBox(),
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
