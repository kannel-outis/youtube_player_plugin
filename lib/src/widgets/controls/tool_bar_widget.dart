import 'package:flutter/material.dart';
import 'package:youtube_player/src/utils/utils.dart';
import 'package:youtube_player/src/utils/youtube_player_colors.dart';
import 'package:youtube_player/src/widgets/inherited_state.dart';
import 'package:youtube_player/src/widgets/modal_sheet.dart';
import 'package:youtube_player/youtube_player.dart';

class ToolBarWidget extends StatefulWidget {
  final YoutubePlayerController? controller;
  final YoutubePlayerColors? colors;
  final VoidCallback? onPressed;

  const ToolBarWidget({Key? key, this.controller, this.colors, this.onPressed})
      : super(key: key);

  @override
  _ToolBarWidgetState createState() => _ToolBarWidgetState();
}

class _ToolBarWidgetState extends State<ToolBarWidget> {
  bool? _show;

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
                IconButton(
                  onPressed: widget.onPressed,
                  icon: Icon(
                    Icons.expand_more_outlined,
                    size: Utils.blockWidth * 4 > 35 ? 35 : Utils.blockWidth * 4,
                    color: widget.colors!.iconsColor,
                  ),
                ),
                SizedBox(
                  width: Utils.blockWidth * 20,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          await showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (context) => ModalSheet(
                                    controller: widget.controller,
                                  ));
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
                      InkWell(
                        onTap: () {
                          InheritedState.of(context).stateChange?.call(false);
                        },
                        child: Icon(
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
