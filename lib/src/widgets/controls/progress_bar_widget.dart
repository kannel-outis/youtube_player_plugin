import 'package:flutter/material.dart';
import 'package:youtube_player/src/utils/utils.dart';
import 'package:youtube_player/src/utils/youtube_player_colors.dart';
import 'package:youtube_player/src/widgets/inherited_state.dart';
import 'package:youtube_player/youtube_player.dart';

import '../progress_slider.dart';

class ProgressSecWidget extends StatelessWidget {
  final YoutubePlayerController controller;
  final AnimationController? animeController;
  final YoutubePlayerColors? colors;

  const ProgressSecWidget({
    Key? key,
    required this.controller,
    this.animeController,
    this.colors,
  }) : super(key: key);

  void _animateProgress(bool show) {
    if (show == true) {
      animeController!.forward();
    } else if (show == false) {
      animeController!.reverse();
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
    final show = InheritedState.of(context).show;

    _animateProgress(show);
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: show
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        Text(
                          "${_timerStringRep(controller.value.position.toString())} /",
                          style: TextStyle(
                            fontSize: Utils.blockWidth * 2.5 > 25
                                ? 25
                                : Utils.blockWidth * 2.5,
                            color: Colors.white.withOpacity(.8),
                          ),
                        ),
                        Text(
                          " ${_timerStringRep(controller.value.duration.toString())}",
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
                        color: colors!.iconsColor!.withOpacity(.8),
                      )
                    ],
                  )
                : const SizedBox(),
          ),
          SizedBox(height: Utils.blockHeight * 1.3),
          SizedBox(
            height: 15,
            child: ProgressSlider(
              // 15.0
              thumbSize: (Utils.blockHeight * 1.2) * animeController!.value,
              // thumbSize: 15.0 *  animeController!.value,
              value: controller.value.duration != const Duration()
                  ? controller.value.position.inMilliseconds /
                      controller.value.duration.inMilliseconds
                  : 0.0,
              bufferedValue: controller.value.duration != const Duration()
                  ? controller.value.bufferedPosition.inMilliseconds /
                      controller.value.duration.inMilliseconds
                  : 0.0,
              progressBarColor: colors!.progressColor!,
              barColor: colors!.barColor!.withOpacity(.1),
              bufferedColor: colors!.bufferedColor!.withOpacity(.4),
              thumbColor: colors!.thumbColor!,
              seekTo: (value) {
                controller.seekTo(
                  Duration(
                    milliseconds:
                        (controller.value.duration.inMilliseconds * value)
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
