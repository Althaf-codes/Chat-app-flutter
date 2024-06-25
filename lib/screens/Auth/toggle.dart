import 'package:chatappp_socketio/screens/Auth/signin_screen.dart';
import 'package:chatappp_socketio/screens/Auth/signup_screen.dart';
import 'package:flutter/material.dart';

class Toggle extends StatefulWidget {
  const Toggle({Key? key}) : super(key: key);

  @override
  State<Toggle> createState() => _AuthState();

  static String _route = '/toggle';

  static get route => _route;
}

class _AuthState extends State<Toggle> {
  bool showSignUp = true;

  void toggleview() {
    setState(() {
      showSignUp = !showSignUp;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignUp) {
      return SignUpScreen(toggleView: toggleview);
    } else {
      return SigninScreen(toggleView: toggleview);
    }
  }
}
