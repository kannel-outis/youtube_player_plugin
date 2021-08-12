import 'package:flutter/material.dart';
import 'package:youtube_player/src/utils/utils.dart';
import 'package:youtube_player/src/utils/youtube_player_colors.dart';
import 'package:youtube_player/youtube_player.dart';

class ToolBarWidget extends StatefulWidget {
  final bool show;
  final YoutubePlayerController? controller;
  final YoutubePlayerColors? colors;

  const ToolBarWidget(
      {Key? key, this.controller, this.show = false, this.colors})
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
                Icon(
                  Icons.expand_more_outlined,
                  size:
                      Utils.blockWidth * 4.5 > 35 ? 35 : Utils.blockWidth * 4.5,
                  color: widget.colors!.iconsColor,
                ),
                SizedBox(
                  width: Utils.blockWidth * 15,
                  child: Row(
                    children: [
                      Icon(
                        Icons.more_vert,
                        size: Utils.blockWidth * 4.5 > 35
                            ? 35
                            : Utils.blockWidth * 4.5,
                        color: widget.colors!.iconsColor,
                      ),
                      const Expanded(child: SizedBox()),
                      Icon(
                        Icons.close,
                        size: Utils.blockWidth * 4.5 > 35
                            ? 35
                            : Utils.blockWidth * 4.5,
                        color: widget.colors!.iconsColor,
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
