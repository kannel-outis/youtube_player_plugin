import 'package:flutter/material.dart';
import 'package:youtube_player/src/utils/utils.dart';
import 'package:youtube_player/youtube_player.dart';

class ModalSheet extends StatefulWidget {
  final YoutubePlayerController? controller;
  const ModalSheet({Key? key, this.controller}) : super(key: key);

  @override
  _ModalSheetState createState() => _ModalSheetState();
}

class _ModalSheetState extends State<ModalSheet>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> scaleAnimation;
  late final PageController _pageController;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 100),
        reverseDuration: const Duration(milliseconds: 100))
      ..addListener(() {
        if (mounted) setState(() {});
      });
    _pageController = PageController();
    scaleAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    super.initState();
  }

  final Map<String, YoutubePlayerVideoQuality> _qualityMap = {
    "Auto": YoutubePlayerVideoQuality.auto,
    "144": YoutubePlayerVideoQuality.quality_144p,
    "240": YoutubePlayerVideoQuality.quality_240p,
    "480": YoutubePlayerVideoQuality.quality_480p,
    "720": YoutubePlayerVideoQuality.quality_720p,
    "1080": YoutubePlayerVideoQuality.quality_1080p,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      height: 200 + (175 * scaleAnimation.value),
      margin: EdgeInsets.symmetric(horizontal: Utils.blockWidth * 10),
      child: PageView(
        controller: _pageController,
        children: [
          Container(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    _controller.forward();
                    _pageController.animateToPage(1,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut);
                  },
                  child: buildModalTile("Quality", Icons.settings_outlined,
                      widget.controller!.value.quality.qualityToString),
                ),
                buildModalTile(
                    "Caption", Icons.closed_caption_outlined, "Unavailable"),
                buildModalTile("Playback Speed",
                    Icons.slow_motion_video_outlined, "Normal"),
              ],
            ),
          ),
          Container(
            // color: Colors.black,
            padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),

            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      _controller.reverse();
                      _pageController.animateToPage(0,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut);
                    },
                    child: const SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(Icons.arrow_back),
                      ),
                    ),
                  ),
                  ..._qualityMap.entries.toList().map(
                        (e) => InkWell(
                          onTap: () {
                            if (widget.controller != null) {
                              widget.controller!.videoQualityChange(
                                youtubeLink: widget.controller!.youtubeLink,
                                quality: e.value,
                              );
                            }
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.only(left: 20),
                            height: 50,
                            width: double.infinity,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(e.key),
                            ),
                          ),
                        ),
                      ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildModalTile(String title, IconData icon, String label) {
    return SizedBox(
      height: 150 / 3,
      width: double.infinity,
      child: Row(
        children: [
          Icon(
            icon,
            size: Utils.blockWidth * 4,
          ),
          const SizedBox(width: 15),
          Text(
            title,
            style: TextStyle(fontSize: Utils.blockWidth * 3),
          ),
          const SizedBox(width: 10),
          Container(
            height: 5,
            width: 5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style:
                TextStyle(color: Colors.grey, fontSize: Utils.blockWidth * 2.5),
          )
        ],
      ),
    );
  }
}
