import 'package:flutter/material.dart';

class DesktopStarredScreen extends StatelessWidget {
  const DesktopStarredScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black45,
      child: Center(
        child: Text(
          'Starred Messages',
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
      ),
    );
  }
}
