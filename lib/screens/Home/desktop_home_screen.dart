// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chatappp_socketio/screens/Home/widgets/desktop_chat_screen.dart';
import 'package:chatappp_socketio/services/chat_provider.dart';
import 'package:chatappp_socketio/services/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chatappp_socketio/resources/socket_methods.dart';
import 'package:chatappp_socketio/screens/Chat/message_screen.dart';
import 'package:chatappp_socketio/screens/Home/widgets/channel_screen.dart';
import 'package:chatappp_socketio/screens/Home/widgets/community_screen.dart';
import 'package:chatappp_socketio/screens/Home/widgets/profile_screen.dart';
import 'package:chatappp_socketio/screens/Home/widgets/setting_screen.dart';
import 'package:chatappp_socketio/screens/Home/widgets/starred_screen.dart';
import 'package:chatappp_socketio/screens/Home/widgets/status_screen.dart';
import 'package:chatappp_socketio/services/message_info_provider.dart';

class DesktopHomeScreen extends StatefulWidget {
  SocketMethods socketMethods;
  DesktopHomeScreen({
    Key? key,
    required this.socketMethods,
  }) : super(key: key);

  @override
  State<DesktopHomeScreen> createState() => _DesktopHomeScreenState();
}

class _DesktopHomeScreenState extends State<DesktopHomeScreen> {
  int _currentIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    const List<Widget> _screens = [
      DesktopChatScreen(),
      DesktopCommunityScreen(),
      DesktopStatusScreen(),
      DesktopChannelScreen(),
      DesktopStarredScreen(),
      DesktopSettingScreen(),
      DesktopProfileScreen()
    ];
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 70,
              color: const Color.fromARGB(137, 60, 60, 60),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                        splashColor: _currentIndex == 0
                            ? Colors.grey[400]
                            : Colors.transparent,
                        splashRadius: 20,
                        onPressed: () {
                          setState(() {
                            _currentIndex = 0;
                          });
                        },
                        icon: Icon(
                          Icons.chat,
                          color: Colors.white,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                        focusColor: Colors.red,
                        highlightColor: Colors.green,
                        // splashColor: _currentIndex == 1
                        //     ? Colors.blue
                        //     : Colors.transparent,
                        splashRadius: 40,
                        onPressed: () {
                          setState(() {
                            _currentIndex = 1;
                          });
                        },
                        icon: Icon(
                          Icons.groups_2_outlined,
                          color: Colors.white,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                        splashColor: _currentIndex == 2
                            ? Colors.grey[400]
                            : Colors.transparent,
                        splashRadius: 20,
                        onPressed: () {
                          setState(() {
                            _currentIndex = 2;
                          });
                        },
                        icon: Icon(
                          Icons.hive_rounded,
                          color: Colors.white,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                        splashColor: _currentIndex == 3
                            ? Colors.grey[400]
                            : Colors.transparent,
                        splashRadius: 20,
                        onPressed: () {
                          setState(() {
                            _currentIndex = 3;
                          });
                        },
                        icon: Icon(
                          Icons.wifi_tethering,
                          color: Colors.white,
                        )),
                  ),
                  Divider(
                    color: Colors.white,
                    thickness: 2,
                    indent: 20,
                    endIndent: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                        splashColor: _currentIndex == 4
                            ? Colors.grey[400]
                            : Colors.transparent,
                        splashRadius: 20,
                        onPressed: () {
                          setState(() {
                            _currentIndex = 4;
                          });
                        },
                        icon: Icon(
                          Icons.star_border,
                          color: Colors.white,
                        )),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                        splashColor: _currentIndex == 5
                            ? Colors.grey[400]
                            : Colors.transparent,
                        splashRadius: 20,
                        onPressed: () {
                          setState(() {
                            _currentIndex = 5;
                          });
                        },
                        icon: Icon(
                          Icons.settings,
                          color: Colors.white,
                        )),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: IconButton(
                  //       splashColor: _currentIndex == 6
                  //           ? Colors.grey[400]
                  //           : Colors.transparent,
                  //       splashRadius: 20,
                  //       onPressed: () {},
                  //       icon: Icon(
                  //         Icons.person_2_outlined,
                  //         color: Colors.white,
                  //       )),
                  // ),
                  Consumer<UserProvider>(
                    builder: (BuildContext context, value, Widget? child) {
                      if (value.user?.profilePic?.url.isNotEmpty != null) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _currentIndex = 6;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.green,
                              backgroundImage:
                                  NetworkImage(value.user!.profilePic!.url),
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: _screens[_currentIndex],
            ),

            Consumer<MessageInfoProvider>(
              builder: (context, MessageInfoProvider value, Widget? child) {
                if (!value.isChatClicked) {
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.65,
                    decoration: const BoxDecoration(
                      border: Border(
                        left: BorderSide(color: Colors.black),
                      ),
                      color: const Color.fromARGB(137, 60, 60, 60),
                    ),
                    child: Center(
                      child: Text(
                        'Start Messaging ',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  );
                } else {
                  return Container(
                      width: MediaQuery.of(context).size.width * 0.65,
                      decoration: const BoxDecoration(
                        border: Border(
                          left: BorderSide(color: Colors.black),
                        ),
                        // color: const Color.fromARGB(137, 60, 60, 60),
                      ),
                      child: Consumer<MessageInfoProvider>(builder:
                          (context, MessageInfoProvider value, Widget? child) {
                        return MessageScreen(
                            socketclient: widget.socketMethods,
                            chatdetails: value.messageInfoModel.chatdetails,
                            isGroupChat: value.messageInfoModel.isGroupChat,
                            lastOfflineAt:
                                value.messageInfoModel.lastOfflineAt);
                      }));
                }
              },
            ),
            // Container(
            //   width: MediaQuery.of(context).size.width * 0.65,

            //   decoration: const BoxDecoration(
            //       border: Border(
            //         left: BorderSide(color: Colors.black),
            //       ),
            //       color: Colors.green
            //       // image: DecorationImage(
            //       //   image: AssetImage(
            //       //     "assets/backgroundImage.png",
            //       //   ),
            //       //   fit: BoxFit.cover,
            //       // ),
            //       ),
            //   // child: Column(
            //   //   children: [
            //   //     const ChatAppBar(),
            //   //     const SizedBox(height: 20),
            //   //     Expanded(
            //   //         child: Container(
            //   //       color: Colors.blue,
            //   //     )),
            //   //     Container(
            //   //       height: MediaQuery.of(context).size.height * 0.07,
            //   //       padding: const EdgeInsets.all(10),
            //   //       decoration: const BoxDecoration(
            //   //         border: Border(
            //   //           bottom: BorderSide(color: Colors.black),
            //   //         ),
            //   //         color: Colors.black45,
            //   //       ),
            //   //       child: Row(
            //   //         children: [
            //   //           IconButton(
            //   //             onPressed: () {},
            //   //             icon: const Icon(
            //   //               Icons.emoji_emotions_outlined,
            //   //               color: Colors.grey,
            //   //             ),
            //   //           ),
            //   //           IconButton(
            //   //             onPressed: () {},
            //   //             icon: const Icon(
            //   //               Icons.attach_file,
            //   //               color: Colors.grey,
            //   //             ),
            //   //           ),
            //   //           Expanded(
            //   //             child: Padding(
            //   //               padding: const EdgeInsets.only(
            //   //                 left: 10,
            //   //                 right: 15,
            //   //               ),
            //   //               child: TextField(
            //   //                 decoration: InputDecoration(
            //   //                   filled: true,
            //   //                   fillColor: Colors.black45,
            //   //                   hintText: 'Type a message',
            //   //                   border: OutlineInputBorder(
            //   //                     borderRadius: BorderRadius.circular(20.0),
            //   //                     borderSide: const BorderSide(
            //   //                       width: 0,
            //   //                       style: BorderStyle.none,
            //   //                     ),
            //   //                   ),
            //   //                   contentPadding: const EdgeInsets.only(left: 20),
            //   //                 ),
            //   //               ),
            //   //             ),
            //   //           ),
            //   //           IconButton(
            //   //             onPressed: () {},
            //   //             icon: const Icon(
            //   //               Icons.mic,
            //   //               color: Colors.grey,
            //   //             ),
            //   //           ),
            //   //         ],
            //   //       ),
            //   //     ),
            //   //   ],
            //   // ),
            // ),
          ],
        ),
      ),
    );
  }
}

/*
Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DesktopProfileBar(),
                  DesktopSearchBar(),
                  ChatScreen()
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.75,
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(color: Colors.black),
              ),
              // image: DecorationImage(
              //   image: AssetImage(
              //     "assets/backgroundImage.png",
              //   ),
              //   fit: BoxFit.cover,
              // ),
            ),
            child: Column(
              children: [
                const ChatAppBar(),
                const SizedBox(height: 20),
                Expanded(
                    child: Container(
                  color: Colors.blue,
                )),
                Container(
                  height: MediaQuery.of(context).size.height * 0.07,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.black),
                    ),
                    color: Colors.black45,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.emoji_emotions_outlined,
                          color: Colors.grey,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.attach_file,
                          color: Colors.grey,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 10,
                            right: 15,
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.black45,
                              hintText: 'Type a message',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: const BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              contentPadding: const EdgeInsets.only(left: 20),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.mic,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
  
  
*/
