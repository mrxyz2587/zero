import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:zero_fin/screens/reels_screen.dart';

class VideoPlayerSearch extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerSearch({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerSearchState createState() => _VideoPlayerSearchState();
}

class _VideoPlayerSearchState extends State<VideoPlayerSearch> {
  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(
      widget.videoUrl,
    )..initialize().then((value) {
        videoPlayerController.play();
        videoPlayerController.setVolume(0);
        videoPlayerController.setLooping(true);
      });
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ReelsScreen()));
      },
      child: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          color: Color(0xFFF6F6F6),
        ),
        child: VideoPlayer(videoPlayerController),
      ),
    );
  }
}
