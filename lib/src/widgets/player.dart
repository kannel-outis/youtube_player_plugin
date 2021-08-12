import 'package:flutter/material.dart';
import 'package:youtube_player/src/controller.dart';
import 'package:youtube_player/src/utils/utils.dart';

class Player extends StatefulWidget {
  final YoutubePlayerController controller;
  const Player(this.controller, {Key? key}) : super(key: key);
  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  int? _textureId;
  void setS() => setState(() {});

  void _listener() {
    print(widget.controller.value.position);
    print(widget.controller.value.duration);
    print(widget.controller.value.youtubePlayerStatus);
    print(widget.controller.value.percentageBuffered);
    print(
        "${widget.controller.value.buffering}:::::::: :::::::::::::::::::::::::::::");
    if (!mounted) return;
    if (widget.controller.textureId != _textureId) {
      _textureId = widget.controller.textureId;
      setS();
    }
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      _textureId = widget.controller.textureId;
      setS();
      widget.controller.addListener(_listener);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (mounted) Utils.calculateBlockHeightAndWidth(context);
  }

  @override
  void didUpdateWidget(covariant Player oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.controller.removeListener(_listener);
    _textureId = widget.controller.textureId;
    widget.controller.addListener(_listener);
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return _textureId != null ? Texture(textureId: _textureId!) : Container();
  }
}
