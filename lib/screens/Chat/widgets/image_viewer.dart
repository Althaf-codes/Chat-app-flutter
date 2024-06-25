// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ImageViewer extends StatelessWidget {
  String url;
  String sender;
  ImageViewer({
    Key? key,
    required this.url,
    required this.sender,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.black,
        leading: BackButton(color: Colors.white),
        title: Text(
          sender,
          style: TextStyle(
              color: Colors.white,
              letterSpacing: 1,
              fontWeight: FontWeight.w500,
              fontSize: 14),
        ),
      ),
      body: Center(
          child: Image.network(
        url,
        fit: BoxFit.cover,
        // height: MediaQuery.of(context).size.height * 0.5,
        // width: MediaQuery.of(context).size.width*0.5,
      )),
    );
  }
}
