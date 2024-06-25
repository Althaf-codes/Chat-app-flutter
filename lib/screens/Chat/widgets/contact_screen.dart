// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chatappp_socketio/constant/constants.dart';
import 'package:chatappp_socketio/resources/socket_methods.dart';
import 'package:flutter/material.dart';

class ContactScreen extends StatelessWidget {
  SocketMethods socketclient;
  ContactScreen({
    Key? key,
    required this.socketclient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: BackButton(
          color: Colors.white,
        ),
        backgroundColor: const Color.fromARGB(255, 2, 74, 5),
        title: const Text(
          'All Contacts',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: dummyusers.length,
        itemBuilder: (context, index) {
          DummyContactUser dummyContactUser = dummyusers[index];
          return GestureDetector(
            onTap: () {
              socketclient.searchOrCreatePrivateChat(
                  phoneNumber: dummyContactUser.phoneNumber);
              // Navigator.pop(context);
            },
            child: ListTile(
              leading: CircleAvatar(backgroundColor: Colors.grey.shade400),
              title: Text(
                dummyContactUser.name,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                dummyContactUser.phoneNumber,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              ),
            ),
          );
        },
      ),
    );
  }
}
