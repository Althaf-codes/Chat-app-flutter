import 'package:chatappp_socketio/models/chat_model.dart';
import 'package:chatappp_socketio/models/message_info_model.dart';
import 'package:chatappp_socketio/resources/socket_methods.dart';
import 'package:chatappp_socketio/screens/Chat/message_screen.dart';
import 'package:chatappp_socketio/screens/Home/widgets/desktop_appbar.dart';
import 'package:chatappp_socketio/screens/Home/widgets/desktop_searchbar.dart';
import 'package:chatappp_socketio/services/auth_service.dart';
import 'package:chatappp_socketio/services/chat_provider.dart';
import 'package:chatappp_socketio/services/message_info_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DesktopChatScreen extends StatefulWidget {
  const DesktopChatScreen({super.key});

  @override
  State<DesktopChatScreen> createState() => _DesktopChatScreenState();
}

class _DesktopChatScreenState extends State<DesktopChatScreen> {
  late ScrollController scrollController;
  // late IO.Socket socket;

  String _uidString() {
    final String uid =
        Provider.of<AuthMethods>(context, listen: false).user.uid;
    return uid;
  }

  late SocketMethods _socketMethods;
  @override
  void initState() {
    print("initstate in Desktopchatscreen is called");
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print("didchangedependency in Desktopchatscreen is called");

    final uid = _uidString();
    _socketMethods = SocketMethods(uid: uid);
    _socketMethods.getsocketClient();

    _socketMethods.getallChats(context);

    _initalllisteners(context);
    super.didChangeDependencies();
  }

  Future<void> _initalllisteners(BuildContext context) async {
    _socketMethods.getallChatsListener(context);
    // _socketMethods.receiveMessageListener(context);
    _socketMethods.privateChatInvite(context);
    _socketMethods.errorOccuredListener(context);
    _socketMethods.getSearchResult(context);
    _socketMethods.groupCreatedSuccessListeners(context);

    // _socketMethods.groupMemberAddedListener(context);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  String formatTimeAgo(String mongoTimestamp) {
    DateTime convertedDateTime = convertUtcToIst(mongoTimestamp);

    final now = DateTime.now();
    final difference = now.difference(convertedDateTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} sec ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hr ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      // If more than a week, use intl package for more precise time ago
      final formatter = DateFormat.yMMMMd('en_US');
      return 'on ${formatter.format(convertedDateTime)}';
    }
  }

  String formatMongoTimestamp(String mongoTimestamp) {
    DateTime convertedDateTime = convertUtcToIst(mongoTimestamp);
    // DateTime timestamp = DateTime.parse(convertedDateTime);
    DateTime now = DateTime.now();

    if (isSameDay(convertedDateTime, now)) {
      return DateFormat.jm().format(
          convertedDateTime); // DateFormat('HH:mm').format(convertedDateTime);
    } else if (isSameDay(
        convertedDateTime, now.subtract(const Duration(days: 1)))) {
      return 'Yesterday';
    } else {
      return DateFormat('dd/MM/yyyy').format(convertedDateTime);
    }
  }

  DateTime convertUtcToIst(String utcDateTimeString) {
    final utcDateTime = DateTime.parse(utcDateTimeString);
    final istDateTime =
        utcDateTime.toLocal(); // Convert to local timezone (device timezone)

    // Format the IST date-time using intl package
    // final formattedIstDateTime =
    //     DateFormat('yyyy-MM-dd HH:mm:ss').format(istDateTime);
    return istDateTime;
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // initSocket() {
  //   final String uid =
  //       Provider.of<AuthMethods>(context, listen: false).user.uid;
  //   print("the uid is ${uid}");

  //   socket = IO.io(
  //       "http://localhost:8080",
  //       OptionBuilder()
  //           .setTransports(['websocket'])
  //           .disableAutoConnect()
  //           .setAuth({'authorization': uid})
  //           .build());

  //   socket.connect();
  //   socket.onConnect((_) {
  //     print('Connection established');
  //   });

  //   socket.onDisconnect((_) => print('Connection Disconnected'));
  //   socket.onConnectError((err) => print(err));
  //   socket.onError((err) => print(err));
  // }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<AuthMethods>(context).user;
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            const DesktopChatAppBar(),
            const DesktopSearchBar(),
            Consumer<ChatProvider>(builder:
                (BuildContext context, ChatProvider value, Widget? child) {
              return ListView.builder(
                  controller: scrollController,
                  shrinkWrap: true,
                  itemCount: value.allChats.length,
                  itemBuilder: (BuildContext context, int index) {
                    Chat chat = value.allChats[index];
                    String formattedDate =
                        formatMongoTimestamp(chat.lastMessage.createdAt);

                    print(
                        "The Last message time is ${chat.lastMessage.createdAt}");
                    return GestureDetector(
                      onTap: () {
                        String lastOfflneAt = chat.members
                            .firstWhere((element) => element.uid != user.uid)
                            .lastOfflineAt
                            .toString();

                        String lastseen = formatTimeAgo(lastOfflneAt);
                        Provider.of<ChatProvider>(context, listen: false)
                            .updateAllMessageInchat(
                                readMessages: [], unreadMessage: []);
                        Provider.of<ChatProvider>(context, listen: false)
                            .updateUnreadMessageToEmpty();

                        Provider.of<MessageInfoProvider>(context, listen: false)
                            .setChatClicked();
//////////////////////////////////////////////////////////

                        _socketMethods.getMessagesFromchat(chatId: chat.id);
                        Provider.of<ChatProvider>(context, listen: false)
                            .updateUnreadMessageCount(chatId: chat.id);

//////////////////////////////////////////////////////////

                        Provider.of<MessageInfoProvider>(context, listen: false)
                            .setMessageInfoModel(
                                messageInfoModel: MessageInfoModel(
                                    chatdetails: chat,
                                    isGroupChat: chat.isGroupChat,
                                    lastOfflineAt: lastseen));

                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => MessageScreen(
                        //               isGroupChat: chat.isGroupChat,
                        //               chatdetails: chat,
                        //               socketclient: _socketMethods,
                        //               lastOfflineAt: lastseen,
                        //             )));
                      },
                      child: Consumer<MessageInfoProvider>(
                          builder: (context, value, child) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            children: [
                              ListTile(
                                tileColor: value
                                            .messageInfoModel.chatdetails.id ==
                                        chat.id
                                    ? const Color.fromARGB(96, 109, 108, 108)
                                    : Colors.transparent,
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      chat.isGroupChat
                                          ? chat.name
                                          : '${chat.members.where((element) => element.uid != user.uid).first.username}',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      formattedDate,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                    )
                                  ],
                                ),
                                leading: !chat.isGroupChat
                                    ? CircleAvatar(
                                        backgroundColor: Colors.green,
                                        backgroundImage: NetworkImage(
                                          chat.members
                                              .where((element) =>
                                                  element.uid != user.uid)
                                              .first
                                              .profilePic!
                                              .url,
                                        ))
                                    // Image.network(chat.members.where((element) => element.uid!=user.uid).first.profilePic.url,)

                                    : CircleAvatar(
                                        backgroundColor: Colors.green,
                                      ),
                                style: ListTileStyle.list,
                                subtitle: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      chat.lastMessage.sender.uid == user.uid
                                          ? "You : ${chat.lastMessage.content}"
                                          : "${chat.lastMessage.sender.username} :${chat.lastMessage.content}",
                                      // ? chat.lastMessage.attachments[0].url
                                      //         .isNotEmpty
                                      //     ? chat.lastMessage.attachments[0]
                                      //                 .mimeType ==
                                      //             "IMAGE"
                                      //         ? "You : 📷 Photo"
                                      //         : chat
                                      //                     .lastMessage
                                      //                     .attachments[0]
                                      //                     .mimeType ==
                                      //                 "VIDEO"
                                      //             ? "You : 🎥 Video"
                                      //             : "You : GIF"
                                      //     : "You : ${chat.lastMessage.content}"
                                      // : chat.lastMessage.attachments[0].url
                                      //         .isNotEmpty
                                      //     ? chat.lastMessage.attachments[0]
                                      //                 .mimeType ==
                                      //             "IMAGE"
                                      //         ? "${chat.lastMessage.sender.username} : 📷 Photo"
                                      //         : chat
                                      //                     .lastMessage
                                      //                     .attachments[0]
                                      //                     .mimeType ==
                                      //                 "VIDEO"
                                      //             ? "${chat.lastMessage.sender.username} : 🎥 Video"
                                      //             : "${chat.lastMessage.sender.username} : GIF"
                                      //     : "${chat.lastMessage.sender.username} :${chat.lastMessage.content}",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                    chat.lastMessage.sender.uid == user.uid
                                        ? const SizedBox.shrink()
                                        : chat.unReadMessageCount == 0
                                            ? const SizedBox.shrink()
                                            : chat.isGroupChat
                                                ? Container(
                                                    height: 20,
                                                    width: 20,
                                                    decoration:
                                                        const BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color:
                                                                Colors.green),
                                                  )
                                                : Container(
                                                    height: 20,
                                                    width: 20,
                                                    decoration:
                                                        const BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color:
                                                                Colors.green),
                                                    child: Center(
                                                      child: Text(
                                                        chat.unReadMessageCount
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                    ),
                                                  )
                                  ],
                                ),
                              ),
                              const Divider(
                                indent: 30,
                                endIndent: 30,
                              )
                            ],
                          ),
                        );
                      }),
                    );
                  });
            }),
          ],
        ),
      ),
    );
  }
}



/*
Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            children: [
                              ListTile(
                                tileColor: value
                                            .messageInfoModel.chatdetails.id ==
                                        chat.id
                                    ? const Color.fromARGB(96, 109, 108, 108)
                                    : Colors.transparent,
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      chat.isGroupChat
                                          ? chat.name
                                          : '${chat.members.where((element) => element.uid != user.uid).first.username}',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      formattedDate,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                    )
                                  ],
                                ),
                                leading: !chat.isGroupChat
                                    ? CircleAvatar(
                                        backgroundColor: Colors.green,
                                        backgroundImage: NetworkImage(
                                          chat.members
                                              .where((element) =>
                                                  element.uid != user.uid)
                                              .first
                                              .profilePic!
                                              .url,
                                        ))
                                    // Image.network(chat.members.where((element) => element.uid!=user.uid).first.profilePic.url,)

                                    : CircleAvatar(
                                        backgroundColor: Colors.green,
                                      ),
                                style: ListTileStyle.list,
                                subtitle: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      chat.lastMessage.sender.uid == user.uid
                                          ? chat.lastMessage.attachments[0].url
                                                  .isNotEmpty
                                              ? chat.lastMessage.attachments[0]
                                                          .mimeType ==
                                                      "IMAGE"
                                                  ? "You : 📷 Photo"
                                                  : chat
                                                              .lastMessage
                                                              .attachments[0]
                                                              .mimeType ==
                                                          "VIDEO"
                                                      ? "You : 🎥 Video"
                                                      : "You : GIF"
                                              : "You : ${chat.lastMessage.content}"
                                          : chat.lastMessage.attachments[0].url
                                                  .isNotEmpty
                                              ? chat.lastMessage.attachments[0]
                                                          .mimeType ==
                                                      "IMAGE"
                                                  ? "${chat.lastMessage.sender.username} : 📷 Photo"
                                                  : chat
                                                              .lastMessage
                                                              .attachments[0]
                                                              .mimeType ==
                                                          "VIDEO"
                                                      ? "${chat.lastMessage.sender.username} : 🎥 Video"
                                                      : "${chat.lastMessage.sender.username} : GIF"
                                              : "${chat.lastMessage.sender.username} :${chat.lastMessage.content}",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                    chat.lastMessage.sender.uid == user.uid
                                        ? const SizedBox.shrink()
                                        : chat.unReadMessageCount == 0
                                            ? const SizedBox.shrink()
                                            : chat.isGroupChat
                                                ? Container(
                                                    height: 20,
                                                    width: 20,
                                                    decoration:
                                                        const BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color:
                                                                Colors.green),
                                                  )
                                                : Container(
                                                    height: 20,
                                                    width: 20,
                                                    decoration:
                                                        const BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color:
                                                                Colors.green),
                                                    child: Center(
                                                      child: Text(
                                                        chat.unReadMessageCount
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                    ),
                                                  )
                                  ],
                                ),
                              ),
                              const Divider(
                                indent: 30,
                                endIndent: 30,
                              )
                            ],
                          ),
                        );
                    
                    
                      }),
*/