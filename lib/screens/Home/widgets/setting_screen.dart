import 'package:flutter/material.dart';

class DesktopSettingScreen extends StatelessWidget {
  const DesktopSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black45,
      child: Center(
        child: Text(
          'Setting ',
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
      ),
    );
  }
}
