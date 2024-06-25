// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chatappp_socketio/screens/Calls/call_screen.dart';
import 'package:chatappp_socketio/screens/Chat/chat_screen.dart';
import 'package:chatappp_socketio/screens/Chat/widgets/change_profile_pic.dart';
import 'package:chatappp_socketio/screens/Chat/widgets/contact_screen.dart';
import 'package:chatappp_socketio/screens/Chat/widgets/create_group_screen.dart';
import 'package:chatappp_socketio/screens/Status/status_screen.dart';
import 'package:chatappp_socketio/services/auth_service.dart';
import 'package:chatappp_socketio/services/user_provider.dart';
import 'package:flutter/material.dart';

import 'package:chatappp_socketio/resources/socket_methods.dart';
import 'package:provider/provider.dart';

class MobileHomeScreen extends StatelessWidget {
  SocketMethods socketMethods;
  MobileHomeScreen({
    Key? key,
    required this.socketMethods,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            // IconButton(
            //     onPressed: () async {
            //       await Provider.of<AuthMethods>(context, listen: false)
            //           .createUser(
            //               context: context,
            //               username: "Althafar",
            //               phoneNumber: user.phoneNumber.toString(),
            //               uid: user.uid.toString());
            //     },
            //     icon: Icon(
            //       Icons.tab,
            //       color: Colors.white,
            //     )),

            // IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
            Consumer<UserProvider>(
              builder: (BuildContext context, value, Widget? child) {
                if (value.user?.profilePic?.url.isNotEmpty != null) {
                  return CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.green,
                    backgroundImage: NetworkImage(value.user!.profilePic!.url),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
            IconButton(
                onPressed: () async {
                  await Provider.of<AuthMethods>(context, listen: false)
                      .signOut();
                },
                icon: const Icon(
                  Icons.logout_outlined,
                  color: Colors.white,
                )),
            PopupMenuButton(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              color: Colors.white,
              iconColor: Colors.white,
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateGroupScreen(
                                    socketMethods: socketMethods)));
                      },
                      child: Text("New group")),
                  PopupMenuItem(
                      onTap: () {
                        // Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ContactScreen(
                                socketclient: socketMethods,
                              ),
                            ));
                      },
                      child: Text("All Contacts")),
                  PopupMenuItem(onTap: () {}, child: Text("Linked devices")),
                  PopupMenuItem(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ProfilePicUpdateScreen()));
                      },
                      child: Text("Update Profile")),
                  PopupMenuItem(onTap: () {}, child: Text("Settings"))
                ];
              },
            ),
          ],
          title: const Text(
            'Whatsapp',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(255, 2, 74, 5),
          bottom: const TabBar(
              indicatorColor: Colors.black,
              indicatorSize: TabBarIndicatorSize.tab,
              isScrollable: false,
              tabs: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Tab(
                    height: 10,
                    child: Icon(
                      Icons.camera_alt_sharp,
                      color: Colors.white,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Tab(
                    child: Text(
                      'Chats',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Tab(
                    child: Text(
                      'Status',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Tab(
                    child: Text(
                      'Calls',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ]),
        ),
        body: const TabBarView(children: [
          Icon(Icons.camera),
          ChatScreen(),
          StatusScreen(),
          CallScreen(),
        ]),
      ),
    );
  }
}
