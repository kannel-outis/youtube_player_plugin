import 'package:flutter/material.dart';
import 'package:youtube_player/src/utils/utils.dart';

import '../../../youtube_player.dart';
import '../inherited_state.dart';
import '../progress_slider.dart';

class ProgressSliderWidget extends StatefulWidget {
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
  _ProgressSliderWidgetState createState() => _ProgressSliderWidgetState();
}

class _ProgressSliderWidgetState extends State<ProgressSliderWidget> {
  // ignore: use_late_for_private_fields_and_variables
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant ProgressSliderWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller.videoId != widget.controller.videoId) {
      _controller = widget.controller;
    }
  }

  @override
  Widget build(BuildContext context) {
    final showThumb = InheritedState.of(context).hideProgressThumb;
    return SizedBox(
      height: Utils.blockHeight < 15 ? 15 : Utils.blockHeight,
      // height: 15,
      child: ProgressSlider(
        thumbSize:
            showThumb ? 0 : Utils.blockHeight * widget.animeController!.value,
        value: _controller!.value.duration != const Duration()
            ? _controller!.value.position.inMilliseconds /
                _controller!.value.duration.inMilliseconds
            : 0.0,
        bufferedValue: _controller!.value.duration != const Duration()
            ? _controller!.value.bufferedPosition.inMilliseconds /
                _controller!.value.duration.inMilliseconds
            : 0.0,
        progressBarColor: widget.colors!.progressColor!,
        barColor: widget.colors!.barColor!,
        bufferedColor: widget.colors!.bufferedColor!,
        thumbColor: widget.colors!.thumbColor!,
        seekTo: (value) {
          _controller!.seekTo(
            Duration(
              milliseconds:
                  (_controller!.value.duration.inMilliseconds * value).round(),
            ),
          );
        },
      ),
    );
  }
}
