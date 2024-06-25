// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';

class VideoPlayerPreview extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerPreview({
    Key? key,
    required this.videoUrl,
  }) : super(key: key);

  @override
  State<VideoPlayerPreview> createState() => _VideoPlayerPreviewState();
}

class _VideoPlayerPreviewState extends State<VideoPlayerPreview> {
  late CachedVideoPlayerController videoPlayerController;
  @override
  void initState() {
    super.initState();
    videoPlayerController = CachedVideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) {
        videoPlayerController.setVolume(1);
      });
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(children: [
          CachedVideoPlayer(videoPlayerController),
        ]));
  }
}

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerItem({
    Key? key,
    required this.videoUrl,
  }) : super(key: key);

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late CachedVideoPlayerController videoPlayerController;
  bool isPlay = false;

  @override
  void initState() {
    super.initState();
    videoPlayerController = CachedVideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) {
        videoPlayerController.setVolume(1);
      });
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          CachedVideoPlayer(videoPlayerController),
          Align(
            alignment: Alignment.center,
            child: IconButton(
              onPressed: () {
                if (isPlay) {
                  videoPlayerController.pause();
                } else {
                  videoPlayerController.play();
                }

                setState(() {
                  isPlay = !isPlay;
                });
              },
              icon: Icon(
                isPlay ? Icons.pause_circle : Icons.play_circle,
              ),
            ),
          ),
          // Align(
          //   alignment: Alignment.bottomLeft,
          //   child: Padding(
          //     padding: const EdgeInsets.all(4.0),
          //     child: Text(
          //       videoPlayerController.value.duration.inSeconds.toString(),
          //       style: TextStyle(
          //           color: Colors.red,
          //           fontSize: 10,
          //           fontWeight: FontWeight.w500,
          //           letterSpacing: 1),
          //     ),
          //   ),
          // ),
          VideoProgressIndicator(
            videoPlayerController,
            allowScrubbing: true,
            colors: VideoProgressColors(
                backgroundColor: Colors.grey,
                playedColor: Colors.green,
                bufferedColor: Colors.black54),
          ),
        ],
      ),
    );
  }
}
