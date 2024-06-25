// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:chatappp_socketio/screens/Chat/widgets/video_player.dart';

class VideoViewer extends StatelessWidget {
  String sender;
  String url;
  VideoViewer({
    Key? key,
    required this.sender,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.black,
        title: Text(
          sender,
          style: TextStyle(
              color: Colors.white,
              letterSpacing: 1,
              fontWeight: FontWeight.w500,
              fontSize: 14),
        ),
      ),
      body: Center(child: VideoPlayerItem(videoUrl: url)),
    );
  }
}
