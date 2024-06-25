// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chatappp_socketio/models/chat_model.dart';
import 'package:chatappp_socketio/models/message_model.dart';
import 'package:chatappp_socketio/resources/socket_methods.dart';
import 'package:chatappp_socketio/screens/Chat/widgets/add_group_members.dart';
import 'package:chatappp_socketio/screens/Chat/widgets/image_viewer.dart';
import 'package:chatappp_socketio/screens/Chat/widgets/video_player.dart';
import 'package:chatappp_socketio/screens/Chat/widgets/video_viewer.dart';
import 'package:chatappp_socketio/services/auth_service.dart';
import 'package:chatappp_socketio/services/chat_provider.dart';
import 'package:chatappp_socketio/services/firebase_file_upload_service.dart';
import 'package:chatappp_socketio/utils/gallery_utils.dart';
import 'package:chatappp_socketio/utils/message_enums.dart';
import 'package:chatappp_socketio/utils/responsive_widget.dart';
import 'package:chatappp_socketio/utils/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:uuid/uuid.dart';

class MessageScreen extends StatefulWidget {
  SocketMethods socketclient;
  Chat chatdetails;
  bool isGroupChat;
  String lastOfflineAt;

  MessageScreen({
    Key? key,
    required this.socketclient,
    required this.chatdetails,
    required this.isGroupChat,
    required this.lastOfflineAt,
  }) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  Color green = Color.fromARGB(255, 2, 74, 5);

  FocusNode focusNode = FocusNode();
  final TextEditingController _messageController = TextEditingController();
  ScrollController singlechildScrollController = ScrollController();
  ScrollController readMessageScrollController = ScrollController();

  bool isRecorderInit = false;
  bool isShowEmojiContainer = false;
  bool isRecording = false;
  bool isShowSendButton = false;
  late SocketMethods _socketMethods;
  late String uid;
  String _uidString() {
    final String uid =
        Provider.of<AuthMethods>(context, listen: false).user.uid;
    return uid;
  }

  CommonFirebaseStorageRepository firebaseStorageRepository =
      CommonFirebaseStorageRepository(
          firebaseStorage: FirebaseStorage.instance);
  @override
  void initState() {
    uid = _uidString();

    _socketMethods = SocketMethods(uid: uid);
    _socketMethods.getsocketClient();
    print('THE CHATDETAIL ID ${widget.chatdetails.id}');
    // if (Responsive.isMobile(context)) {
    //   _socketMethods.getMessagesFromchat(chatId: widget.chatdetails.id);
    // }

    print("initstate in messagescreen is called");

    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   print("didchangedependency in message screen is called");
  //   Future.delayed(Duration.zero).then((value) {
  //     Provider.of<ChatProvider>(context, listen: false)
  //         .updateUnreadMessageCount(chatId: widget.chatdetails.id);
  //   });

  //   // _initializeListeners(context);

  //   super.didChangeDependencies();
  // }

  Future<void> _initializeListeners(BuildContext context) async {
    // _socketMethods.getMessageListener(context);
    // _socketMethods.receiveMessageListener(context);
    setState(() {});
    // _socketMethods.groupMemberAddedListener(context);
  }

  @override
  void dispose() {
    _messageController.dispose();
    singlechildScrollController.dispose();
    readMessageScrollController.dispose();

    super.dispose();
  }

  void sendTextMessage({
    required String chatId,
    required String content,
    required List<Attachment> attachments,
  }) {
    _socketMethods.sendMessage(
      chatId: chatId,
      content: content,
      attachments: attachments,
      context: context,
    );
    setState(() {
      _messageController.text = '';
    });
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
    } else if (isSameDay(convertedDateTime, now.subtract(Duration(days: 1)))) {
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

  void selectImage({
    required String chatId,
    required String content,
  }) async {
    XFile? image = await pickImageFromGallery(context);

    print('Image path is ${image?.path.toString()} ');
    if (image != null) {
      var messageId = const Uuid().v1();
      if (context.mounted) {
        String url = await firebaseStorageRepository.storeFileToFirebase(
            ref: "chat/${chatId}/${uid}/${messageId}",
            file: image,
            context: context);
        print("The url is ${url}");
        print('The MessageEnum ${MessageEnum.image.toString()}');
        _socketMethods.sendMessage(
            chatId: chatId,
            content: content,
            attachments: [
              Attachment(url: url, localPath: image.path, mimeType: 'IMAGE')
            ],
            context: context);
      }
    } else {
      if (context.mounted) {
        showSnackBar(context, "No Image is selected");
      }
    }
  }

  void selectVideo({
    required String chatId,
    required String content,
  }) async {
    XFile? video = await pickVideoFromGallery(context);
    if (video != null) {
      var messageId = const Uuid().v1();
      if (context.mounted) {
        String url = await firebaseStorageRepository.storeFileToFirebase(
            ref: "chat/${chatId}/${uid}/${messageId}",
            file: video,
            context: context);
        print("The url is ${url}");
        print('The MessageEnum ${MessageEnum.image.toString()}');
        _socketMethods.sendMessage(
            chatId: chatId,
            content: content,
            attachments: [
              Attachment(url: url, localPath: video.path, mimeType: 'VIDEO')
            ],
            context: context);
      }
    } else {
      if (context.mounted) {
        showSnackBar(context, "No Video is selected");
      }
    }
  }

  void selectFiles({
    required String chatId,
    required String content,
  }) async {
    XFile? doc = await pickFiles(context);
    if (doc != null) {
      var messageId = const Uuid().v1();
      if (context.mounted) {
        String url = await firebaseStorageRepository.storeFileToFirebase(
            ref: "chat/${chatId}/${uid}/${messageId}",
            file: doc,
            context: context);
        print("The url is ${url}");
        print('The MessageEnum ${MessageEnum.image.toString()}');
        _socketMethods.sendMessage(
            chatId: chatId,
            content: content,
            attachments: [
              Attachment(url: url, localPath: doc.path, mimeType: 'OTHER_FILES')
            ],
            context: context);
      }
    } else {
      if (context.mounted) {
        showSnackBar(context, "No File is selected");
      }
    }
  }

  // void selectGIF() async {
  //   final gif = await pickGIF(context);
  //   if (gif != null) {
  //     ref.read(chatControllerProvider).sendGIFMessage(
  //           context,
  //           gif.url,
  //           widget.recieverUserId,
  //           widget.isGroupChat,
  //         );
  //   }
  // }

  void hideEmojiContainer() {
    setState(() {
      isShowEmojiContainer = false;
    });
  }

  void showEmojiContainer() {
    setState(() {
      isShowEmojiContainer = true;
    });
  }

  void showKeyboard() => focusNode.requestFocus();
  void hideKeyboard() => focusNode.unfocus();

  void toggleEmojiKeyboardContainer() {
    if (isShowEmojiContainer) {
      showKeyboard();
      hideEmojiContainer();
    } else {
      hideKeyboard();
      showEmojiContainer();
    }
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<AuthMethods>(context).user;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Responsive.isDesktop(context)
            ? const SizedBox.shrink()
            : BackButton(
                onPressed: () {
                  Provider.of<ChatProvider>(context, listen: false)
                      .updateAllMessageInchat(
                          readMessages: [], unreadMessage: []);
                  Provider.of<ChatProvider>(context, listen: false)
                      .updateUnreadMessageToEmpty();

                  Navigator.pop(context);
                },
                color: Colors.white,
              ),
        backgroundColor: green,
        title: Column(
          children: [
            Text(
              widget.chatdetails.isGroupChat
                  ? widget.chatdetails.name
                  : widget.chatdetails.members
                      .firstWhere((element) => element.uid != user.uid)
                      .username
                      .toString(),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            ),
            Consumer<ChatProvider>(
              builder:
                  (BuildContext context, ChatProvider value, Widget? child) {
                String lastseen = formatTimeAgo(value.allChats
                    .where((element) => element.id == widget.chatdetails.id)
                    .first
                    .members
                    .where((element) => element.uid != user.uid)
                    .first
                    .lastOfflineAt
                    .toString());

                return Text(
                  widget.chatdetails.isGroupChat
                      ? ''
                      : value.allChats
                              .where((element) =>
                                  element.id == widget.chatdetails.id)
                              .first
                              .members
                              .where((element) => element.uid != user.uid)
                              .first
                              .isOnline
                          ? 'Online'
                          : 'last seen: ${lastseen}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                );
              },
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          !widget.isGroupChat
              ? IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.video_call,
                    color: Colors.white,
                  ),
                )
              : IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddGroupMemberScreen(
                            socketMethods: widget.socketclient,
                            chatId: widget.chatdetails.id,
                          ),
                        ));
                  },
                  icon: const Icon(
                    Icons.group_add,
                    color: Colors.white,
                  ),
                ),
          !widget.isGroupChat
              ? IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.call,
                    color: Colors.white,
                  ),
                )
              : const SizedBox(),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
          ),
        ],
      ),
      //was wrapped with singlechildscrollview with a scroll controller and therr was no expanded widget below
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder:
                  (BuildContext context, ChatProvider value, Widget? child) {
                print('//////////');
                print(
                    "The unreadMs in message screen is ${value.allUnreadMessage.length}");
                print('//////////');
                print('Change notifier Changed');

                print("==================================================");
                print(
                    "THE CHECK CONDITION IS EMPTY ${value.allMessages.isEmpty}");
                print('The chatId is ${widget.chatdetails.id}');
                print("==================================================");

                if (value.allUnreadMessage.isNotEmpty &&
                    widget.chatdetails.lastMessage.sender.uid != uid) {
                  print("its here");
                  List<Message> _allunreadMsgs =
                      Provider.of<ChatProvider>(context, listen: false)
                          .allUnreadMessage;

                  print("the allunreadMsgs is ${_allunreadMsgs}");

                  List<String> unreadMsgIds = _allunreadMsgs
                      .where((element) => element.sender.uid != uid)
                      .map((e) => e.messageId)
                      .toList();

                  print("the unreadMessageIds are ${unreadMsgIds}");

                  List<String> unreadSenderIds = _allunreadMsgs
                      .where((element) => element.sender.uid != uid)
                      .map((e) => e.sender.id!)
                      .toList();
                  print("the unreadSenderIds are ${unreadSenderIds}");

                  //send msg-received-ack
                  //update unread-message in clientside provider
                  _socketMethods.sendReadByAck(
                      chatId: widget.chatdetails.id,
                      unreadMessageIds: unreadMsgIds,
                      senderIds: [unreadSenderIds.last]);
                }

                SchedulerBinding.instance.addPostFrameCallback((_) {
                  if (readMessageScrollController.positions.isNotEmpty) {
                    readMessageScrollController.jumpTo(
                        readMessageScrollController.position.maxScrollExtent);
                  }
                });

                return Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            "assets/whatsapp_message_background.jpg",
                          ),
                          fit: BoxFit.cover)),
                  child: value.allMessages.isEmpty
                      ? const Center(
                          child: Text(
                            'loading...',
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                        )
                      : ListView(
                          controller: readMessageScrollController,
                          shrinkWrap: true,
                          children: [
                            ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: value.allMessages.length,
                                itemBuilder: (context, index) {
                                  Message message = value.allMessages[index];
                                  if (message.isCommonMessage) {
                                    return Align(
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8,
                                              left: 50,
                                              bottom: 8,
                                              right: 8),
                                          child: Container(
                                            // height: 50,
                                            // width: 100,
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                                color: Color.fromARGB(
                                                    255, 113, 156, 230),
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            child: Text(
                                              message.content,
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ));
                                  } else {
                                    if (message.sender.uid == user.uid) {
                                      String formattedDate =
                                          formatMongoTimestamp(
                                              message.createdAt);

                                      return sentMessage(
                                          context: context,
                                          message: message.content,
                                          sentAt: formattedDate,
                                          isSeen: message.readBy.isNotEmpty,
                                          attachments: message.attachments);
                                    } else {
                                      return Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8,
                                                left: 8,
                                                bottom: 8,
                                                right: 50),
                                            child: Container(
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.green),
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    message.sender.username
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  message.attachments
                                                              .isNotEmpty &&
                                                          message.attachments[0]
                                                              .url.isNotEmpty
                                                      ? Column(
                                                          children: [
                                                            ...message
                                                                .attachments
                                                                .map(
                                                                    (e) => e.mimeType ==
                                                                            "VIDEO"
                                                                        ? InkWell(
                                                                            onTap:
                                                                                () {
                                                                              Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                      builder: (context) => VideoViewer(
                                                                                            url: e.url,
                                                                                            sender: 'You',
                                                                                          )));
                                                                            },
                                                                            child:
                                                                                VideoPlayerItem(videoUrl: e.url))
                                                                        : e.mimeType == "IMAGE"
                                                                            ? InkWell(
                                                                                onTap: () {
                                                                                  Navigator.push(
                                                                                      context,
                                                                                      MaterialPageRoute(
                                                                                          builder: (context) => ImageViewer(
                                                                                                url: e.url,
                                                                                                sender: 'You',
                                                                                              )));
                                                                                },
                                                                                child: Image.network(e.url))
                                                                            : Image.network(e.url)
                                                                    // : e.mimeType == MessageEnum.image
                                                                    //     ? CachedNetworkImage(imageUrl: e.url)
                                                                    //     : CachedNetworkImage(imageUrl: e.url),
                                                                    )
                                                                .toList(),
                                                            SizedBox(
                                                              height: 3,
                                                            ),
                                                            Text(
                                                              message.content,
                                                              // textAlign: TextAlign.start,
                                                              style: TextStyle(
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.045,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            )
                                                          ],
                                                        )
                                                      : Text(
                                                          "${message.content}"),
                                                ],
                                              ),
                                            ),
                                          ));
                                    }
                                  }
                                }),
                            value.allUnreadMessage.isNotEmpty
                                ? Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8,
                                          left: 50,
                                          bottom: 8,
                                          right: 8),
                                      child: Container(
                                        // height: 50,
                                        // width: 100,
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 113, 156, 230),
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: Text(
                                          "Unread Messages",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ))
                                : const SizedBox.shrink(),
                            value.allUnreadMessage.isNotEmpty
                                ? ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: value.allUnreadMessage.length,
                                    itemBuilder: (context, index) {
                                      Message message =
                                          value.allUnreadMessage[index];
                                      return Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8,
                                                left: 8,
                                                bottom: 8,
                                                right: 50),
                                            child: Container(
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.green),
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    message.sender.username
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text("${message.content}"),
                                                ],
                                              ),
                                            ),
                                          ));
                                    })
                                : const SizedBox.shrink(),
                          ],
                        ),
                );
              },
            ),
          ),

          //TextFeild Part

          Column(
            children: [
              Container(
                // height: 500,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        focusNode: focusNode,
                        controller: _messageController,
                        onChanged: (val) {
                          if (val.isNotEmpty) {
                            setState(() {
                              isShowSendButton = true;
                            });
                          } else {
                            setState(() {
                              isShowSendButton = false;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: SizedBox(
                              width: 100,
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: toggleEmojiKeyboardContainer,
                                    icon: const Icon(
                                      Icons.emoji_emotions,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.gif,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          suffixIcon: SizedBox(
                            width: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    selectImage(
                                        chatId: widget.chatdetails.id,
                                        content:
                                            _messageController.text.isNotEmpty
                                                ? _messageController.text
                                                : '');
                                  },
                                  icon: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.grey,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    selectVideo(
                                        chatId: widget.chatdetails.id,
                                        content:
                                            _messageController.text.isNotEmpty
                                                ? _messageController.text
                                                : "");
                                    // selectFiles(
                                    //     chatId: widget.chatdetails.id,
                                    //     content:
                                    //         _messageController.text.isNotEmpty
                                    //             ? _messageController.text
                                    //             : "📁 File");
                                  },
                                  icon: const Icon(
                                    Icons.attach_file,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          hintText: 'Type a message!',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: const BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(10),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 8,
                        right: 2,
                        left: 2,
                      ),
                      child: CircleAvatar(
                        backgroundColor: const Color(0xFF128C7E),
                        radius: 25,
                        child: GestureDetector(
                          child: Icon(
                            isShowSendButton
                                ? Icons.send
                                : isRecording
                                    ? Icons.close
                                    : Icons.mic,
                            color: Colors.white,
                          ),
                          onTap: () {
                            sendTextMessage(
                                chatId: widget.chatdetails.id,
                                content: _messageController.text,
                                attachments: []);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              isShowEmojiContainer
                  ? SizedBox(
                      height: 310,
                      child: EmojiPicker(
                        onEmojiSelected: ((category, emoji) {
                          setState(() {
                            _messageController.text =
                                _messageController.text + emoji.emoji;
                          });

                          if (!isShowSendButton) {
                            setState(() {
                              isShowSendButton = true;
                            });
                          }
                        }),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ],
      ),
    );
  }

  Row sentMessage({
    required BuildContext context,
    required String message,
    required String sentAt,
    required bool isSeen,
    required List<Attachment> attachments,
  }) {
    // Attachment attachment = attachments[0];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.02,
              vertical: MediaQuery.of(context).size.width * 0.004,
            ),
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.015,
                right: MediaQuery.of(context).size.width * 0.015,
                top: MediaQuery.of(context).size.width * 0.015),
            alignment: Alignment.centerRight,
            width: MediaQuery.of(context).size.width * 0.6,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.4,
                minWidth: MediaQuery.of(context).size.width * 0.05,
              ),
              decoration: BoxDecoration(
                  color: Color(0xffDCF8C6),
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Wrap(
                verticalDirection: VerticalDirection.down,
                alignment: WrapAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.only(bottom: 10
                        // Responsive.isDesktop(context)
                        // ? MediaQuery.of(context).size.height * 0.0005
                        // : MediaQuery.of(context).size.height * 0.005,
                        ),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.5,
                    ),
                    child: attachments.isNotEmpty &&
                            attachments[0].url.isNotEmpty
                        ? Column(
                            children: [
                              ...attachments
                                  .map((e) => e.mimeType == "VIDEO"
                                          ? InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            VideoViewer(
                                                              url: e.url,
                                                              sender: 'You',
                                                            )));
                                              },
                                              child: SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.3,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.3,
                                                child: VideoPlayerItem(
                                                    videoUrl: e.url),
                                              ))
                                          : e.mimeType == "IMAGE"
                                              ? InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    ImageViewer(
                                                                      url:
                                                                          e.url,
                                                                      sender:
                                                                          'You',
                                                                    )));
                                                  },
                                                  child: SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.3,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.3,
                                                      child:
                                                          Image.network(e.url)))
                                              : SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.3,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.3,
                                                  child: Image.network(e.url))
                                      // : e.mimeType == MessageEnum.image
                                      //     ? CachedNetworkImage(imageUrl: e.url)
                                      //     : CachedNetworkImage(imageUrl: e.url),
                                      )
                                  .toList(),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                message,
                                // textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize:
                                      Responsive.isDesktop(context) ? 15 : 12,
                                  // MediaQuery.of(context).size.width * 0.045,
                                  color: Colors.black,
                                ),
                              )
                            ],
                          )
                        : Text(
                            message,
                            style: TextStyle(
                              fontSize: Responsive.isDesktop(context) ? 15 : 12,
                              color: Colors.black,
                            ),
                          ),
                  ),
                  Container(
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.006,
                      left: MediaQuery.of(context).size.width * 0.015,
                    ),

                    //alignment: Alignment.bottomRight,
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.20,
                    ),
                    child: Text(
                      sentAt,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: Responsive.isDesktop(context) ? 12 : 8),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.006),
                    child: Icon(
                      isSeen ? Icons.done_all : Icons.check,
                      size: MediaQuery.of(context).size.width * 0.015,
                      color: isSeen ? Colors.blue : Colors.white,
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}

/*
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chatappp_socketio/models/chat_model.dart';
import 'package:chatappp_socketio/models/message_model.dart';
import 'package:chatappp_socketio/resources/socket_methods.dart';
import 'package:chatappp_socketio/screens/Chat/widgets/add_group_members.dart';
import 'package:chatappp_socketio/services/auth_service.dart';
import 'package:chatappp_socketio/services/chat_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class MessageScreen extends StatefulWidget {
  SocketMethods socketclient;
  Chat chatdetails;
  bool isGroupChat;

  MessageScreen({
    Key? key,
    required this.socketclient,
    required this.chatdetails,
    required this.isGroupChat,
  }) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  Color green = Color.fromARGB(255, 2, 74, 5);
  ScrollController messageScrollController = ScrollController();
  FocusNode focusNode = FocusNode();
  final TextEditingController _messageController = TextEditingController();

  bool isRecorderInit = false;
  bool isShowEmojiContainer = false;
  bool isRecording = false;
  bool isShowSendButton = false;
  late SocketMethods _socketMethods;

  String _uidString() {
    final String uid =
        Provider.of<AuthMethods>(context, listen: false).user.uid;
    return uid;
  }

  @override
  void initState() {
    final uid = _uidString();
    _socketMethods = SocketMethods(uid: uid);
    _socketMethods.getsocketClient();
    _socketMethods.getMessagesFromchat(chatId: widget.chatdetails.id);

    if (widget.chatdetails.lastMessage.sender.uid != uid) {
      //send msg-received-ack
      //update unread-message in clientside provider
      _socketMethods.sendReadByAck(chatId: widget.chatdetails.id);
    }

    print("initstate in messagescreen is called");

    super.initState();
  }

  @override
  void didChangeDependencies() {
    print("didchangedependency in message screen is called");
    Future.delayed(Duration.zero).then((value) {
      Provider.of<ChatProvider>(context, listen: false)
          .updateUnreadMessageCount(chatId: widget.chatdetails.id);
    });

    // _initializeListeners(context);

    super.didChangeDependencies();
  }

  Future<void> _initializeListeners(BuildContext context) async {
    // _socketMethods.getMessageListener(context);
    // _socketMethods.receiveMessageListener(context);
    // _socketMethods.groupMemberAddedListener(context);
  }

  @override
  void dispose() {
    messageScrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void sendTextMessage({
    required String chatId,
    required String content,
    required Attachment attachment,
  }) {
    _socketMethods.sendMessage(
      chatId: chatId,
      content: content,
      attachment: attachment,
    );
    setState(() {
      _messageController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<AuthMethods>(context).user;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: BackButton(
          onPressed: () {
            Provider.of<ChatProvider>(context, listen: false)
                .updateAllMessageInchat(allmessages: []);

            Navigator.pop(context);
          },
          color: Colors.white,
        ),
        backgroundColor: green,
        title: Column(
          children: [
            Text(
              widget.chatdetails.isGroupChat
                  ? widget.chatdetails.name
                  : widget.chatdetails.members
                      .firstWhere((element) => element.uid != user.uid)
                      .username
                      .toString(),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            ),
            Consumer<ChatProvider>(
              builder:
                  (BuildContext context, ChatProvider value, Widget? child) {
                return Text(
                  widget.chatdetails.isGroupChat
                      ? ''
                      : widget.chatdetails.members
                              .where((element) => element.uid != user.uid)
                              .first
                              .isOnline!
                          ? 'Online'
                          : 'Offline',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                );
              },
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          !widget.isGroupChat
              ? IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.video_call,
                    color: Colors.white,
                  ),
                )
              : IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddGroupMemberScreen(
                            socketMethods: widget.socketclient,
                            chatId: widget.chatdetails.id,
                          ),
                        ));
                  },
                  icon: const Icon(
                    Icons.group_add,
                    color: Colors.white,
                  ),
                ),
          !widget.isGroupChat
              ? IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.call,
                    color: Colors.white,
                  ),
                )
              : const SizedBox(),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Consumer<ChatProvider>(
            builder: (BuildContext context, ChatProvider value, Widget? child) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                messageScrollController
                    .jumpTo(messageScrollController.position.maxScrollExtent);
              });

              return Expanded(
                  child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                          "assets/whatsapp_message_background.jpg",
                        ),
                        fit: BoxFit.cover)),
                child: value.allMessages.isEmpty
                    ? const Center(
                        child: Text(
                          'loading...',
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                      )
                    : ListView.builder(
                        controller: messageScrollController,
                        itemCount: value.allMessages.length,
                        itemBuilder: (context, index) {
                          Message message = value.allMessages[index];
                          if (message.isCommonMessage) {
                            return Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8, left: 50, bottom: 8, right: 8),
                                  child: Container(
                                    // height: 50,
                                    // width: 100,
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 113, 156, 230),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Text(
                                      message.content,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ));
                          } else {
                            if (message.sender.uid == user.uid) {
                              return Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8, left: 50, bottom: 8, right: 8),
                                    child: Container(
                                      // height: 50,
                                      // width: 100,
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Text(
                                        message.content,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ));
                            } else {
                              return Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8, left: 8, bottom: 8, right: 50),
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.green),
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            message.sender.username.toString(),
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text("${message.content}"),
                                        ],
                                      ),
                                    ),
                                  ));
                            }
                          }
                        }),
              ));
            },
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  focusNode: focusNode,
                  controller: _messageController,
                  onChanged: (val) {
                    if (val.isNotEmpty) {
                      setState(() {
                        isShowSendButton = true;
                      });
                    } else {
                      setState(() {
                        isShowSendButton = false;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.emoji_emotions,
                                color: Colors.grey,
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.gif,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    suffixIcon: SizedBox(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.camera_alt,
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
                        ],
                      ),
                    ),
                    hintText: 'Type a message!',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(10),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 8,
                  right: 2,
                  left: 2,
                ),
                child: CircleAvatar(
                  backgroundColor: const Color(0xFF128C7E),
                  radius: 25,
                  child: GestureDetector(
                    child: Icon(
                      isShowSendButton
                          ? Icons.send
                          : isRecording
                              ? Icons.close
                              : Icons.mic,
                      color: Colors.white,
                    ),
                    onTap: () {
                      sendTextMessage(
                        chatId: widget.chatdetails.id,
                        content: _messageController.text,
                        attachment:
                            Attachment(url: '', localPath: '', mimeType: ''),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

*/
