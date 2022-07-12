import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayer extends StatefulWidget {
  final String vid;
  VideoPlayer({Key? key, required this.vid}) : super(key: key);

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late YoutubePlayerController _controller;

  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.vid,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        forceHD: false,
        enableCaption: true,
      ),
    );

    _controller.toggleFullScreenMode();
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  // ignore: dead_code
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Colors.transparent,
        ),
        body: YoutubePlayerBuilder(
            player: YoutubePlayer(
              controller: _controller,
            ),
            builder: (context, player) {
              return player;
              //some other widgets
            }));
  }
}
