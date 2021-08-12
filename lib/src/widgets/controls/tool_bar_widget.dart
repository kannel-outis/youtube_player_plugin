import 'package:flutter/material.dart';
import 'package:youtube_player/youtube_player.dart';

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
