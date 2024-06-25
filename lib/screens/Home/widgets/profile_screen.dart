import 'package:flutter/material.dart';

class DesktopProfileScreen extends StatelessWidget {
  const DesktopProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black45,
      child: Center(
        child: Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
      ),
    );
  }
}
