import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player/src/utils/utils.dart';
import 'package:youtube_player/src/utils/youtube_player_colors.dart';
import 'package:youtube_player/src/widgets/inherited_state.dart';
import 'package:youtube_player/youtube_player.dart';

class TimeStampAndFullScreenToggleWidget extends StatelessWidget {
  final YoutubePlayerController controller;
  final AnimationController? animeController;
  final YoutubePlayerColors? colors;
  final Function(bool)? onOrientationToggle;

  const TimeStampAndFullScreenToggleWidget({
    Key? key,
    required this.controller,
    this.animeController,
    this.colors,
    this.onOrientationToggle,
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
    return Expanded(
      child: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (show)
              Expanded(
                child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: Utils.blockWidth * 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
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
                        InkWell(
                          onTap: () {
                            if (MediaQuery.of(context).orientation ==
                                Orientation.portrait) {
                              SystemChrome.setEnabledSystemUIOverlays([]);
                              SystemChrome.setPreferredOrientations([
                                DeviceOrientation.landscapeLeft,
                                DeviceOrientation.landscapeRight,
                              ]);
                              // full(context, controller);
                            } else {
                              controller.isFullscreen = false;
                              SystemChrome.setEnabledSystemUIOverlays(
                                  SystemUiOverlay.values);
                              SystemChrome.setPreferredOrientations(
                                const [
                                  DeviceOrientation.portraitUp,
                                  DeviceOrientation.portraitDown,
                                  DeviceOrientation.landscapeLeft,
                                  DeviceOrientation.landscapeRight,
                                ],
                              );
                            }
                            onOrientationToggle?.call(
                                MediaQuery.of(context).orientation ==
                                    Orientation.portrait);
                          },
                          child: Icon(
                            MediaQuery.of(context).orientation ==
                                    Orientation.portrait
                                ? Icons.fullscreen
                                : Icons.fullscreen_exit,
                            size: Utils.blockWidth * 4 > 40
                                ? 40
                                : Utils.blockWidth * 4,
                            color: colors!.iconsColor!.withOpacity(.8),
                          ),
                          // color: colors!.iconsColor!.withOpacity(.8),
                        )
                      ],
                    )),
              )
            else
              const SizedBox(
                height: 36,
              ),
            // SizedBox(height: Utils.blockWidth * 1.3),
          ],
        ),
      ),
    );
  }
}
