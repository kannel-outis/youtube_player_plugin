import 'package:flutter/material.dart';
import 'package:youtube_player/youtube_player.dart';

class Testingpage2 extends StatefulWidget {
  const Testingpage2({Key? key}) : super(key: key);

  @override
  _Testingpage2State createState() => _Testingpage2State();
}

class _Testingpage2State extends State<Testingpage2> {
  late final YoutubePlayerController _controller;
  String value = "240p";
  static const String youtubeLink =
      "https://www.youtube.com/watch?v=X3Ai6osw3Mk";
  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.link(youtubeLink: youtubeLink);
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
            YoutubePlayer(
              controller: _controller,
              onVisibilityChange: (show) =>
                  print("$show ::::::::::::::::::::::::::"),
            ),
            const SizedBox(
              height: 200,
            ),
            DropdownButton<String>(
              value: value,
              onChanged: (_value) {
                _controller.videoQualityChange(
                    youtubeLink: youtubeLink, quality: _value);
              },
              items: [
                DropdownMenuItem(
                  value: "240p",
                  onTap: () {
                    value = "240p";
                    setState(() {});
                  },
                  child: const Text("240p"),
                ),
                DropdownMenuItem(
                  value: "720p",
                  onTap: () {
                    value = "720p";
                    setState(() {});
                  },
                  child: const Text("720p"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
