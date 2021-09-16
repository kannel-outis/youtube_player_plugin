import 'package:flutter/material.dart';
import 'package:youtube_player/src/utils/utils.dart';

import '../../../youtube_player.dart';
import '../inherited_state.dart';
import '../progress_slider.dart';

class ProgressSliderWidget extends StatelessWidget {
  const ProgressSliderWidget({
    Key? key,
    required this.animeController,
    required this.controller,
    required this.colors,
  }) : super(key: key);

  final AnimationController? animeController;
  final YoutubePlayerController controller;
  final YoutubePlayerColors? colors;

  @override
  Widget build(BuildContext context) {
    final showThumb = InheritedState.of(context).hideProgressThumb;
    return SizedBox(
      height: Utils.blockHeight < 15 ? 15 : Utils.blockHeight,
      // height: 15,
      child: ProgressSlider(
        thumbSize: showThumb ? 0 : Utils.blockHeight * animeController!.value,
        value: controller.value.duration != const Duration()
            ? controller.value.position.inMilliseconds /
                controller.value.duration.inMilliseconds
            : 0.0,
        bufferedValue: controller.value.duration != const Duration()
            ? controller.value.bufferedPosition.inMilliseconds /
                controller.value.duration.inMilliseconds
            : 0.0,
        progressBarColor: colors!.progressColor!,
        barColor: colors!.barColor!,
        bufferedColor: colors!.bufferedColor!,
        thumbColor: colors!.thumbColor!,
        seekTo: (value) {
          controller.seekTo(
            Duration(
              milliseconds:
                  (controller.value.duration.inMilliseconds * value).round(),
            ),
          );
        },
      ),
    );
  }
}
