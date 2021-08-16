import 'package:flutter/material.dart';
import 'package:youtube_player/src/utils/utils.dart';
import 'package:youtube_player/src/utils/youtube_player_colors.dart';
import 'package:youtube_player/src/widgets/inherited_state.dart';
import 'package:youtube_player/src/widgets/modal_sheet.dart';
import 'package:youtube_player/youtube_player.dart';

class ToolBarWidget extends StatefulWidget {
  final YoutubePlayerController? controller;
  final YoutubePlayerColors? colors;

  const ToolBarWidget({Key? key, this.controller, this.colors})
      : super(key: key);

  @override
  _ToolBarWidgetState createState() => _ToolBarWidgetState();
}

class _ToolBarWidgetState extends State<ToolBarWidget> {
  bool? _show;

  @override
  void didUpdateWidget(covariant ToolBarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _show = InheritedState.of(context).show;
    return _show != null && _show!
        ? Container(
            // height: 35,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.expand_more_outlined,
                  size: Utils.blockWidth * 4 > 35 ? 35 : Utils.blockWidth * 4,
                  color: widget.colors!.iconsColor,
                ),
                SizedBox(
                  width: Utils.blockWidth * 20,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (context) =>
                                StatefulBuilder(builder: (context, ss) {
                              //   if (widgetcontroller!.value.quality !=
                              //     widget.controller!.value.quality) {
                              //   setState(() {});
                              // }
                              return ModalSheet(
                                controller: widget.controller,
                              );
                            }),
                          );
                        },
                        icon: Icon(
                          Icons.more_vert_outlined,
                          size: Utils.blockWidth * 4 > 35
                              ? 35
                              : Utils.blockWidth * 4,
                          color: widget.colors!.iconsColor,
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      IconButton(
                        onPressed: () {
                          InheritedState.of(context).stateChange?.call(false);
                        },
                        icon: Icon(
                          Icons.close_outlined,
                          size: Utils.blockWidth * 4 > 35
                              ? 35
                              : Utils.blockWidth * 4,
                          color: widget.colors!.iconsColor,
                        ),
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
