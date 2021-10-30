import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player/youtube_player.dart';

const audioLink =
    " https://r2---sn-huoob-5c8e.googlevideo.com/videoplayback?expire=1631632506&ei=GmhAYfTxGMegxN8P79uB4A4&ip=102.91.4.220&id=o-AF5IZhlFlC6gLM95hag6VFgYfk3GIkXsrWrBywvbSdAZ&itag=139&source=youtube&requiressl=yes&mh=DZ&mm=31%2C29&mn=sn-huoob-5c8e%2Csn-avn7ln7l&ms=au%2Crdu&mv=m&mvi=2&pl=24&gcr=ng&initcwndbps=111250&vprv=1&mime=audio%2Fmp4&gir=yes&clen=1688169&dur=276.735&lmt=1630754402373963&mt=1631610529&fvip=2&keepalive=yes&fexp=24001373%2C24007246&c=ANDROID&txp=5532434&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cgcr%2Cvprv%2Cmime%2Cgir%2Cclen%2Cdur%2Clmt&sig=AOq0QJ8wRQIhAOKx03wq7wqkofQEIEdYvxcoltLvNEldTygSeVg5wz5HAiAhEgRBBhVec2XyNEAHIgu-OLdyqxm5PlgBD2Aw2iBuyg%3D%3D&lsparams=mh%2Cmm%2Cmn%2Cms%2Cmv%2Cmvi%2Cpl%2Cinitcwndbps&lsig=AG3C_xAwRQIhAM0rGQkA5nGAC5ZxfICnHhchEpgaE1s_PIwtT3z97uAlAiBYPMOdfWP02KDZ1kGkNMrySt2IPQJeraX4a-2dE1h8Jw%3D%3D";
const videoLink =
    "https://r2---sn-huoob-5c8e.googlevideo.com/videoplayback?expire=1631632506&ei=GmhAYfTxGMegxN8P79uB4A4&ip=102.91.4.220&id=o-AF5IZhlFlC6gLM95hag6VFgYfk3GIkXsrWrBywvbSdAZ&itag=160&source=youtube&requiressl=yes&mh=DZ&mm=31%2C29&mn=sn-huoob-5c8e%2Csn-avn7ln7l&ms=au%2Crdu&mv=m&mvi=2&pl=24&gcr=ng&initcwndbps=111250&vprv=1&mime=video%2Fmp4&gir=yes&clen=2248050&dur=276.600&lmt=1630755136116787&mt=1631610529&fvip=2&keepalive=yes&fexp=24001373%2C24007246&c=ANDROID&txp=5532434&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cgcr%2Cvprv%2Cmime%2Cgir%2Cclen%2Cdur%2Clmt&sig=AOq0QJ8wRQIhALKehAL-cYQGLpLnmK_DkiIhtD9BRAmMIM2ds3KbqytdAiBZU3QRESVCmIcEYgDvQ5BzNB5mHT56-Fsej788bZ4obQ%3D%3D&lsparams=mh%2Cmm%2Cmn%2Cms%2Cmv%2Cmvi%2Cpl%2Cinitcwndbps&lsig=AG3C_xAwRQIhAM0rGQkA5nGAC5ZxfICnHhchEpgaE1s_PIwtT3z97uAlAiBYPMOdfWP02KDZ1kGkNMrySt2IPQJeraX4a-2dE1h8Jw%3D%3D";

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
        youtubeLink: "https://www.youtube.com/watch?v=$videoId",
        // youtubeLink: "https://www.youtube.com/watch?v=unAqKbKbejg",
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
