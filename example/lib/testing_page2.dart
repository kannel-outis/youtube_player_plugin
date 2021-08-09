import 'package:flutter/material.dart';
import 'package:youtube_player/youtube_player.dart';

class Testingpage2 extends StatefulWidget {
  const Testingpage2({Key? key}) : super(key: key);

  @override
  _Testingpage2State createState() => _Testingpage2State();
}

class _Testingpage2State extends State<Testingpage2> {
  late final YoutubePlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.link(
        youtubeLink: "https://www.youtube.com/watch?v=6_LmSPE5oMc");
    // https://www.youtube.com/watch?v=X3Ai6osw3Mk
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          YoutubePlayer(controller: _controller),
        ],
      ),
    );
  }
}
