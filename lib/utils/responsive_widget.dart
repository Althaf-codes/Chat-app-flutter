// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget desktop;
  final Widget mobile;
  // final Widget tablet;

  const Responsive({
    Key? key,
    required this.desktop,
    required this.mobile,
    // required this.tablet,
  }) : super(key: key);

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width <= 900;
  }

  // static bool isTablet(BuildContext context) {
  //   return MediaQuery.of(context).size.width <= 1024 &&
  //       MediaQuery.of(context).size.width > 500;
  // }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width > 900;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    if (size.width > 900) {
      return desktop;
    } else {
      return mobile;
    }
  }
}
