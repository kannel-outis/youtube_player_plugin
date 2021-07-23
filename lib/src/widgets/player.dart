import 'package:flutter/material.dart';
import 'package:youtube_player/src/controller.dart';

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
    print(widget.controller.value.size);
    print(widget.controller.value.duration);
    print(widget.controller.value.youtubePlayerStatus);
    print(widget.controller.value.percentageBuffered);
    if (!mounted) return;
    if (widget.controller.textureId != _textureId) {
      _textureId = widget.controller.textureId;
      setS();
    }
  }

  @override
  void initState() {
    super.initState();
    _textureId = widget.controller.textureId;
    setS();
    widget.controller.addListener(_listener);
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
    widget.controller.removeListener(_listener);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return _textureId != null ? Texture(textureId: _textureId!) : Container();
  }
}
