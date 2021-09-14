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

  const TimeStampAndFullScreenToggleWidget({
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
                            } else {
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
                          },
                          child: Icon(
                            MediaQuery.of(context).orientation ==
                                    Orientation.portrait
                                ? Icons.fullscreen
                                : Icons.fullscreen_exit,
                            size: Utils.blockWidth * 3.5 > 30
                                ? 30
                                : Utils.blockWidth * 3.5,
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
