import 'package:flutter/material.dart';

class DesktopStatusScreen extends StatelessWidget {
  const DesktopStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black45,
      child: Center(
        child: Text(
          'Status',
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
      ),
    );
  }
}
