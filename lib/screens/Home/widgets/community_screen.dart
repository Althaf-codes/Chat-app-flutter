import 'package:flutter/material.dart';

class DesktopCommunityScreen extends StatelessWidget {
  const DesktopCommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black45,
      child: Center(
        child: Text(
          'Community',
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
      ),
    );
  }
}
