import 'package:flutter/material.dart';

void showOTPDialog(
    {required BuildContext context,
    required TextEditingController codeController,
    required VoidCallback onPressed}) {
  showDialog(
      context: context,
      //barrierDismissible: false,
      builder: (context) => AlertDialog(
            title: Text('Enter OTP'),
            content: Container(child: TextField(controller: codeController)),
            actions: [TextButton(onPressed: onPressed, child: Text('Done'))],
          ));
}
