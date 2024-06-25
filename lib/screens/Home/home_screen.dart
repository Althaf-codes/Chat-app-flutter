import 'package:chatappp_socketio/resources/socket_methods.dart';
import 'package:chatappp_socketio/screens/Home/desktop_home_screen.dart';
import 'package:chatappp_socketio/screens/Home/mobile_home_screen.dart';
import 'package:chatappp_socketio/services/auth_service.dart';
import 'package:chatappp_socketio/utils/responsive_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  late SocketMethods _socketMethods;

  User _uidString() {
    final User uid = Provider.of<AuthMethods>(context, listen: false).user;
    return uid;
  }

  @override
  void initState() {
    print("initstate in homescreen is called");
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeDependencies() {
    print("didchangedependency in homescreen is called");
    final user = _uidString();
    _socketMethods = SocketMethods(uid: user.uid);
    _socketMethods.getsocketClient();
    _socketMethods.getallChats(context);
    _socketMethods.groupCreatedSuccessListeners(context);
    _socketMethods.groupMemberAddedListener(context);
    _socketMethods.receiveMessageListener(context);
    _socketMethods.getMessageListener(context);
    _socketMethods.newOnlineUserListener(context);
    _socketMethods.messageReadListener(context);

    print("the phoneNumber is ${user.phoneNumber.toString()}");

    Future.delayed(Duration.zero).then((value) => {
          Provider.of<AuthMethods>(context, listen: false).getUser(
              context: context, phoneNumber: user.phoneNumber.toString())
        });
    super.didChangeDependencies();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        _socketMethods.changeOnlineStatus(status: true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        _socketMethods.changeOnlineStatus(status: false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // final User user = Provider.of<AuthMethods>(context).user;

    return Responsive(
        desktop: DesktopHomeScreen(
          socketMethods: _socketMethods,
        ),
        mobile: MobileHomeScreen(socketMethods: _socketMethods));

    // DefaultTabController(
    //   length: 4,
    //   initialIndex: 1,
    //   child: Scaffold(
    //     appBar: AppBar(
    //       actions: [
    //         // IconButton(
    //         //     onPressed: () async {
    //         //       await Provider.of<AuthMethods>(context, listen: false)
    //         //           .createUser(
    //         //               context: context,
    //         //               username: "Althafar",
    //         //               phoneNumber: user.phoneNumber.toString(),
    //         //               uid: user.uid.toString());
    //         //     },
    //         //     icon: Icon(
    //         //       Icons.tab,
    //         //       color: Colors.white,
    //         //     )),

    //         // IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
    //         Consumer<UserProvider>(
    //           builder: (BuildContext context, value, Widget? child) {
    //             if (value.user?.profilePic?.url.isNotEmpty != null) {
    //               return CircleAvatar(
    //                 radius: 15,
    //                 backgroundColor: Colors.green,
    //                 backgroundImage: NetworkImage(value.user!.profilePic!.url),
    //               );
    //             } else {
    //               return const SizedBox.shrink();
    //             }
    //           },
    //         ),
    //         IconButton(
    //             onPressed: () async {
    //               await Provider.of<AuthMethods>(context, listen: false)
    //                   .signOut();
    //             },
    //             icon: const Icon(
    //               Icons.logout_outlined,
    //               color: Colors.white,
    //             )),
    //         PopupMenuButton(
    //           icon: const Icon(
    //             Icons.more_vert,
    //             color: Colors.white,
    //           ),
    //           color: Colors.white,
    //           iconColor: Colors.white,
    //           itemBuilder: (context) {
    //             return [
    //               PopupMenuItem(
    //                   onTap: () {
    //                     Navigator.push(
    //                         context,
    //                         MaterialPageRoute(
    //                             builder: (context) => CreateGroupScreen(
    //                                 socketMethods: _socketMethods)));
    //                   },
    //                   child: Text("New group")),
    //               PopupMenuItem(
    //                   onTap: () {
    //                     // Navigator.pop(context);
    //                     Navigator.push(
    //                         context,
    //                         MaterialPageRoute(
    //                           builder: (context) => ContactScreen(
    //                             socketclient: _socketMethods,
    //                           ),
    //                         ));
    //                   },
    //                   child: Text("All Contacts")),
    //               PopupMenuItem(onTap: () {}, child: Text("Linked devices")),
    //               PopupMenuItem(
    //                   onTap: () {
    //                     Navigator.push(
    //                         context,
    //                         MaterialPageRoute(
    //                             builder: (context) =>
    //                                 const ProfilePicUpdateScreen()));
    //                   },
    //                   child: Text("Update Profile")),
    //               PopupMenuItem(onTap: () {}, child: Text("Settings"))
    //             ];
    //           },
    //         ),
    //       ],
    //       title: const Text(
    //         'Whatsapp',
    //         style: TextStyle(color: Colors.white),
    //       ),
    //       backgroundColor: const Color.fromARGB(255, 2, 74, 5),
    //       bottom: const TabBar(
    //           indicatorColor: Colors.black,
    //           indicatorSize: TabBarIndicatorSize.tab,
    //           isScrollable: false,
    //           tabs: [
    //             Align(
    //               alignment: Alignment.centerLeft,
    //               child: Tab(
    //                 height: 10,
    //                 child: Icon(
    //                   Icons.camera_alt_sharp,
    //                   color: Colors.white,
    //                 ),
    //               ),
    //             ),
    //             Align(
    //               alignment: Alignment.centerLeft,
    //               child: Tab(
    //                 child: Text(
    //                   'Chats',
    //                   style: TextStyle(
    //                       color: Colors.white,
    //                       fontSize: 15,
    //                       letterSpacing: 1,
    //                       fontWeight: FontWeight.w600),
    //                 ),
    //               ),
    //             ),
    //             Align(
    //               alignment: Alignment.centerLeft,
    //               child: Tab(
    //                 child: Text(
    //                   'Status',
    //                   style: TextStyle(
    //                       color: Colors.white,
    //                       fontSize: 15,
    //                       letterSpacing: 1,
    //                       fontWeight: FontWeight.w600),
    //                 ),
    //               ),
    //             ),
    //             Align(
    //               alignment: Alignment.centerLeft,
    //               child: Tab(
    //                 child: Text(
    //                   'Calls',
    //                   style: TextStyle(
    //                       color: Colors.white,
    //                       fontSize: 15,
    //                       letterSpacing: 1,
    //                       fontWeight: FontWeight.w600),
    //                 ),
    //               ),
    //             ),
    //           ]),
    //     ),
    //     body: const TabBarView(children: [
    //       Icon(Icons.camera),
    //       ChatScreen(),
    //       StatusScreen(),
    //       CallScreen(),
    //     ]),
    //   ),
    // );
  }
}
