import 'package:flutter/material.dart';
import 'package:youtube_player/youtube_player.dart';

class TestingPage extends StatelessWidget {
  const TestingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => YoutubePlayerMethodCall.doSomethingSilly(
            "https://www.youtube.com/watch?v=X3Ai6osw3Mk", "240p"),
      ),
    );
  }
}
