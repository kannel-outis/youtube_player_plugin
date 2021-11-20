import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:youtube_player/youtube_player.dart';

class Testingpage2 extends StatefulWidget {
  const Testingpage2({Key? key}) : super(key: key);

  @override
  _Testingpage2State createState() => _Testingpage2State();
}

class _Testingpage2State extends State<Testingpage2> {
  YoutubePlayerController? _controller;
  String quality = "240p";
  static const String youtubeLink =
      "https://www.youtube.com/watch?v=BS3HgiHPYcs";
  bool load = true;
  @override
  void initState() {
    super.initState();
    // _controller = YoutubePlayerController.link(
    //     youtubeLink: youtubeLink,
    //     quality: YoutubePlayerVideoQuality.quality_144p)
    //   ..initController();
    _controller = YoutubePlayerController.link(
        // youtubeLink: "https://www.youtube.com/watch?v=$videoId",
        // youtubeLink: "https://www.youtube.com/watch?v=WxBN4w4bk-c",
        youtubeLink: "/storage/emulated/0/testing.webm",
        quality: YoutubePlayerVideoQuality.quality_144p);
    // https://www.youtube.com/watch?v=X3Ai6osw3Mk
    // https://www.youtube.com/watch?v=r64_50ELf58
  }

  String videoId = "BS3HgiHPYcs";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(),
        body: Column(
          children: [
            YoutubePlayer(
              controller: _controller!,
              // controller: YoutubePlayerController.link(
              //     youtubeLink: "https://www.youtube.com/watch?v=$videoId",
              //     quality: YoutubePlayerVideoQuality.quality_144p),
              // size: const Size(20, 20),
              // hideProgressThumb: true,
              completelyHideProgressBar: false,
              toolBarMinimizeAction: () {
                log("Something Happened");
              },
              onVideoQualityChange: (quality) {
                log(quality.qualityToString);
              },
            ),
            // const SizedBox(
            //   height: 70,
            // ),
            TextButton(
              onPressed: () {
                if (videoId == "BS3HgiHPYcs") {
                  videoId = "x10xQV8Yei4";
                } else {
                  videoId = "BS3HgiHPYcs";
                }
                setState(() {});
              },
              child: const Center(
                child: Text("dispos or init controller"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
