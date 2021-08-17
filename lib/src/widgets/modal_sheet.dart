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

  final List<YoutubePlayerVideoQuality> _listOfQualities = [
    YoutubePlayerVideoQuality.auto,
    YoutubePlayerVideoQuality.quality_144p,
    YoutubePlayerVideoQuality.quality_240p,
    YoutubePlayerVideoQuality.quality_480p,
    YoutubePlayerVideoQuality.quality_720p,
    YoutubePlayerVideoQuality.quality_1080p,
  ];

  @override
  Widget build(BuildContext context) {
    final plusHeight = Utils.blockHeight > 550 ? 250 : 150;
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      height: Utils.blockHeight * 21 + (plusHeight * scaleAnimation.value),
      margin: Utils.blockWidth * 100 > 550
          ? EdgeInsets.symmetric(horizontal: Utils.blockWidth * 10)
          : const EdgeInsets.all(0),
      child: PageView(
        controller: _pageController,
        children: [
          Container(
            padding: EdgeInsets.all(Utils.blockWidth * 5),
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
            padding: EdgeInsets.only(
                right: Utils.blockWidth * 5,
                bottom: Utils.blockWidth * 5,
                top: Utils.blockWidth * 5),

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
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: SizedBox(
                        height: Utils.blockHeight * 3,
                        width: double.infinity,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.arrow_back,
                            size: Utils.blockWidth * 4,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ..._listOfQualities.map(
                    (e) => InkWell(
                      onTap: () {
                        if (widget.controller != null) {
                          widget.controller!.videoQualityChange(
                            youtubeLink: widget.controller!.youtubeLink,
                            quality: e,
                          );
                        }
                        Navigator.pop(context);
                      },
                      child: SizedBox(
                        height: Utils.blockHeight * 15 / 3,
                        width: double.infinity,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 50,
                                child: e == widget.controller!.value.quality
                                    ? Icon(
                                        Icons.done,
                                        size: Utils.blockWidth * 4,
                                      )
                                    : const SizedBox(),
                              ),
                              Text(
                                e.qualityToString,
                                style:
                                    TextStyle(fontSize: Utils.blockWidth * 3),
                              ),
                            ],
                          ),
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
      height: (Utils.blockHeight * 15) / 3,
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
