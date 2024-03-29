import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player/youtube_player.dart';

class Testingpage2 extends StatefulWidget {
  const Testingpage2({Key? key}) : super(key: key);

  @override
  _Testingpage2State createState() => _Testingpage2State();
}

class _Testingpage2State extends State<Testingpage2> {
  late final YoutubePlayerController _controller;
  String quality = "240p";
  static const String youtubeLink =
      "https://www.youtube.com/watch?v=BS3HgiHPYcs";
  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.link(
        youtubeLink: "https://www.youtube.com/watch?v=X3Ai6osw3Mk",
        quality: YoutubePlayerVideoQuality.quality_144p)
      ..initController();
    // https://www.youtube.com/watch?v=X3Ai6osw3Mk
    // https://www.youtube.com/watch?v=r64_50ELf58
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(),
        body: Column(
          children: [
            // Padding(
            //   padding: EdgeInsets.only(
            //       top: MediaQuery.of(context).orientation == Orientation.portrait
            //           ? MediaQuery.of(context).viewPadding.top
            //           : 0.0),
            // ),
            YoutubePlayer(
              controller: _controller,
              // size: const Size(20, 20),
              hideProgressThumb: true,
              onVideoQualityChange: (quality) {
                log(quality.qualityToString);
              },
            ),
          ],
        ),
      ),
    );
  }
}
