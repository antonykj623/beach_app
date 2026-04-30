import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String url;

  VideoPlayerWidget({required this.url});

  @override
  _VideoPlayerWidgetState createState() =>
      _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState
    extends State<VideoPlayerWidget> {

  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();

    controller =
    VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return controller.value.isInitialized
        ? AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: Stack(
        alignment: Alignment.center,
        children: [

          VideoPlayer(controller),

          IconButton(
            icon: Icon(
              controller.value.isPlaying
                  ? Icons.pause
                  : Icons.play_arrow,
              color: Colors.white,
              size: 40,
            ),
            onPressed: () {
              setState(() {
                controller.value.isPlaying
                    ? controller.pause()
                    : controller.play();
              });
            },
          )
        ],
      ),
    )
        : Center(child: CircularProgressIndicator());
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}