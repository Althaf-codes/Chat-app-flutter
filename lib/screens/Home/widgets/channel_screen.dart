import 'package:flutter/material.dart';

class DesktopChannelScreen extends StatelessWidget {
  const DesktopChannelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black45,
      child: Center(
        child: Text(
          'Channels',
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
      ),
    );
  }
}
