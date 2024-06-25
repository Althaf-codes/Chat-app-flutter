// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:chatappp_socketio/models/chat_model.dart';
import 'package:chatappp_socketio/models/message_model.dart';
import 'package:chatappp_socketio/models/user_model.dart';
import 'package:chatappp_socketio/resources/socketio_client.dart';
import 'package:chatappp_socketio/services/auth_service.dart';
import 'package:chatappp_socketio/services/chat_provider.dart';
import 'package:chatappp_socketio/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketMethods {
  String uid;
  SocketMethods({
    required this.uid,
  });

  //  final _socketClient = SocketClient.instance(uid: uid);

  // Socket get socketClient => _socketClient;

  Socket? _socket;

  getsocketClient() {
    print("the uid here 2 is ${uid}");
    SocketClient socketClient = SocketClient.instance(uid: uid);
    _socket = socketClient.socket!;
  }

  Socket get socketClient => _socket!;

  void fun() {
    print("the Socket Method func called");
    // _socketClient.on('error_occurred');
  }

  void getallChats(BuildContext context) async {
    print('its in getallchats');

    _socket!.emitWithAck('get-allchats', 'nothing', ack: (data) {
      print('///////////////////////////////');
      print('GET ALLCHATS --GOT-DATA , ${data}');
      print('///////////////////////////////');

      final res = jsonDecode(data) as List;

      print("the res is ${res}");

      List<Chat> newChat = res.map((e) => Chat.fromMap(e)).toList();
      Provider.of<ChatProvider>(context, listen: false).updateallChats(newChat);
    });
  }

  void getMessagesFromchat({required String chatId}) {
    print("GET-MESSAGEFROM-CHAT INVOKED");

    _socket!.emit("get-messages", [chatId]);
  }

  void searchOrCreatePrivateChat({required String phoneNumber}) {
    print("SEARCH CHAT INVOKED");
    _socket!.emit('search-user', [phoneNumber]);
  }

  void sendMessage(
      {required String chatId,
      required String content,
      required List<Attachment> attachments,
      required BuildContext context}) {
    print("SEND MESSAGE INVOKED");
    Provider.of<ChatProvider>(context, listen: false).updateMessagesWhileSend();
    print("its coming here");
    _socket!.emit("send-message", [
      chatId,
      content,
      attachments.isNotEmpty
          ? attachments.map((attachment) => attachment.toMap()).toList()
          : [],
    ]);
  }

  void createGroup({required String groupName}) {
    print("CREATE GROUP INVOKED");
    _socket!.emit("create-group", [groupName]);
  }

  void addGroupMember({required String phoneNumber, required String chatId}) {
    print("ADD GROUP MEMBER INVOKED");
    _socket!.emit("add-group-members", [chatId, phoneNumber]);
  }

  void changeOnlineStatus({required bool status}) {
    _socket!.emit('change-online-status', [status]);
  }

  void sendReadByAck(
      {required List<String> unreadMessageIds,
      required String chatId,
      required List<String> senderIds}) {
    print("Sending Message-ReadAck Invoked");
    _socket!.emit(
        'message-readby-ack', [unreadMessageIds, chatId, senderIds.first]);
  }

  //Listeners
  void messageReadListener(BuildContext context) {
    print("Message Read Success Listener Inoked");

    _socket!.on('msg-readed', (data) {
      print("MESSAGE READED LISTENER INVOKED is ${data}");
      final res = jsonDecode(data[0]);
      final User user = User.fromMap(res);
      final chatId = jsonDecode(data[1]) as String;
      final unreadMessageIds = jsonDecode(data[2]) as List;

      Provider.of<ChatProvider>(context, listen: false)
          .notifySenderAboutMessageReaded(
              userWhoReadMsg: user,
              chatId: chatId,
              unreadMessageIds:
                  unreadMessageIds.map((e) => e.toString()).toList());
    });
  }

  void newOnlineUserListener(BuildContext context) {
    print("NEW ONLINE USER SUCCESS LISTENER ");

    _socket!.on('new-online-user', (data) {
      print("NEW ONLINE USER SUCCESS LISTENER DATA IS ${data}");

      final res = jsonDecode(data);

      String userId = res['userId'];
      bool isUserOnline = res['isOnline'];
      String lastOfflineAt = res['lastOfflineAt'];
      List<String> allChatIds =
          List<String>.from(res['allChatIds']).map((e) => e).toList();

      Provider.of<ChatProvider>(context, listen: false)
          .updateNewOnlineUserStatus(
              userId: userId,
              allChatIds: allChatIds,
              isUserOnline: isUserOnline,
              lastOfflineAt: lastOfflineAt);
    });
  }

  void groupMemberAddedListener(BuildContext context) {
    print("GROUP MEMBER ADDED SUCCESS LISTENER");
    _socket!.on("member-added", (chatData) {
      print("the groupMemberAdded data is ${chatData} ");
      final res = jsonDecode(chatData);

      Chat newgroupChat = Chat.fromMap(res);
      List<Chat> allchats =
          Provider.of<ChatProvider>(context, listen: false).allChats;

      if (!allchats.any((element) => element.id == newgroupChat.id)) {
        //if user not in group

        _socket!.emit("member-added-ack", [newgroupChat.id]);
      }
      Provider.of<ChatProvider>(context, listen: false)
          .addNewGroupMember(chat: newgroupChat);
    });
  }

  void groupCreatedSuccessListeners(BuildContext context) {
    print("GROUP CREATED SUCCESS LISTENER INVOKED ");

    _socket!.on("group-created", (chatData) {
      print("the groupChatSuccessListener data is ${chatData}");
      final res = jsonDecode(chatData);
      Chat newgroupChat = Chat.fromMap(res);

      Provider.of<ChatProvider>(context, listen: false)
          .addNewChat(newChat: newgroupChat);
    });
  }

  void receiveMessageListener(BuildContext context) {
    print("Receive message invoked");
    _socket!.on("new-message", (receivedMessage) {
      print("The receivedMessage is ${receivedMessage}");
      final res = jsonDecode(receivedMessage);
      Message message = Message.fromMap(res);

      List<Message> allmsgs =
          Provider.of<ChatProvider>(context, listen: false).allMessages;

      if (message.sender.uid != uid &&
          allmsgs.isNotEmpty &&
          allmsgs[0].chatId == message.chatId) {
        if (allmsgs.any((element) => element.messageId == message.messageId)) {
          return;
        } else {
          _socket!.emit('message-readby-ack', [
            [message.messageId],
            message.chatId,
            [message.sender.id]
          ]);
        }
      }

      Provider.of<ChatProvider>(context, listen: false)
          .receiveMessage(newMsg: message, context: context);

      // ack({"received": true});
    });
  }

  void getMessageListener(BuildContext context) {
    print("GET MESSAGE LISTENER INVOKED");
    _socket!.on("all-messages", (data) {
      final res = jsonDecode(data[0]) as List;
      final unreadres = jsonDecode(data[1]) as List;

      // final readMessages = res[0];
      // final unreadMessages = res[1];
      // print(
      //     'the readMessage type and length is ${readMessages[0].runtimeType} and ${readMessages.length}////////////////////////////////////${readMessages}');
      // print(
      //     'the unreadMessages type and length is ${unreadMessages.runtimeType} and ${unreadMessages.length}');

      // print(
      //     "the first element of unreadMessages runtime type is ${unreadMessages[0].runtimeType}");

      List<Message> allReadMessages =
          res.map((e) => Message.fromMap(e)).toList();

      List<Message> allUnreadMessages =
          unreadres.map((e) => Message.fromMap(e)).toList();

      Provider.of<ChatProvider>(context, listen: false).updateAllMessageInchat(
          readMessages: allReadMessages, unreadMessage: allUnreadMessages);
    });
  }

  void getallChatsListener(BuildContext context) {
    print("its coming in listeners");
    _socket!.on('all-chats', (allchats) {
      print('THE ALL CHATS ARE ${allchats}');
      final res = jsonDecode(allchats) as List;

      print("the res is ${res}");

      List<Chat> newChat = res.map((e) => Chat.fromMap(e)).toList();

      print('All chats ${newChat[0].lastMessage.content}');
      Provider.of<ChatProvider>(context, listen: false).updateallChats(newChat);
    });
  }

  void getSearchResult(BuildContext context) {
    print("getSearchResult Invoked");
    _socket!.on('search-result', (data) {
      print('SEARCH RESULT --GOT-DATA ');

      Chat newChat = Chat.fromJson(data);
      Provider.of<ChatProvider>(context, listen: false)
          .addNewChat(newChat: newChat);
    });
  }

  void privateChatInvite(BuildContext context) {
    print("private-chat-listener invoked");
    _socket!.on('privateChat-invite', (data) {
      print('PRIVATE-CHAT-INVITE --GOT-DATA ');
      Chat newChat = Chat.fromJson(data);

      _socket!.emit("privateChat-invite-ack", [newChat.id]);

      Provider.of<ChatProvider>(context, listen: false)
          .addNewChat(newChat: newChat);
    });
  }

  void errorOccuredListener(BuildContext context) {
    _socket!.on('errorOccurred', (data) {
      showSnackBar(context, data);
    });
  }
}
