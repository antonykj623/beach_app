import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoItem extends StatefulWidget {

  final String videoUrl;

  const VideoItem({
    super.key,
    required this.videoUrl,
  });

  @override
  State<VideoItem> createState() =>
      _VideoItemState();
}

class _VideoItemState
    extends State<VideoItem> {

  late VideoPlayerController controller;

  @override
  void initState() {

    super.initState();

    controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    )

      ..initialize().then((_) {

        setState(() {});
      });

    controller.setLooping(true);

    controller.play();

    controller.setVolume(0);
  }

  @override
  void dispose() {

    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (!controller.value.isInitialized) {

      return Container(
        color: Colors.black12,
      );
    }

    return SizedBox.expand(

      child: FittedBox(

        fit: BoxFit.cover,

        child: SizedBox(

          width: controller.value.size.width,

          height: controller.value.size.height,

          child: VideoPlayer(controller),
        ),
      ),
    );
  }
}