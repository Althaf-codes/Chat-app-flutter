import 'package:chatappp_socketio/models/chat_model.dart';
import 'package:chatappp_socketio/models/message_model.dart';
import 'package:chatappp_socketio/models/user_model.dart';
import 'package:chatappp_socketio/services/auth_service.dart';
import 'package:chatappp_socketio/services/message_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

class ChatProvider extends ChangeNotifier {
  List<Chat> _allchats = [];

  List<Chat> get allChats => _allchats;
  List<Message> _allmessages = [];
  List<Message> _allUnreadMessages = [];

  List<Message> get allMessages => _allmessages;
  List<Message> get allUnreadMessage => _allUnreadMessages;

  void addNewChat({required Chat newChat}) {
    if (_allchats.any((element) => element.id == newChat.id)) {
      return;
    } else {
      _allchats.insert(0, newChat);
      notifyListeners();
    }
  }

  void updateallChats(List<Chat> allchats) {
    _allchats = allchats;
    notifyListeners();
  }

  void updateSingleChat({required Chat newChat}) {
    _allchats.where((element) => element.id == newChat.id);
  }

  void addNewGroupMember({required Chat chat}) {
    if (_allchats.any((element) => element.id == chat.id)) {
      //user already exist in group

      if (_allmessages.isNotEmpty && _allmessages[0].chatId == chat.id) {
        //checks if the user viewing the same chat room
        if (_allmessages.any(
            (element) => element.messageId == chat.lastMessage.messageId)) {
          //if message already exist
          return;
        } else {
          //message updated
          _allmessages.addAll(_allUnreadMessages);
          _allUnreadMessages = [];

          _allmessages.add(chat.lastMessage);

          //also updating the chat
          int indexOfChatToUpdate =
              _allchats.indexWhere((element) => element.id == chat.id);

          if (indexOfChatToUpdate != -1) {
            Chat updatedchat = _allchats[indexOfChatToUpdate]
                .copyWith(lastMessage: chat.lastMessage);

            _allchats.removeAt(indexOfChatToUpdate);
            _allchats.insert(0, updatedchat);
          }
        }
      } else {
        //need to fill
        int indexOfChatToUpdate =
            _allchats.indexWhere((element) => element.id == chat.id);
        print("the index is ${indexOfChatToUpdate.toString()}");
        if (indexOfChatToUpdate != -1) {
          Chat updatedchat = _allchats[indexOfChatToUpdate].copyWith(
            lastMessage: chat.lastMessage,
          );
          Chat updatedChatCount = updatedchat.copyWith(
              unReadMessageCount: updatedchat.unReadMessageCount + 1);

          // _allchats[indexOfChatToUpdate]
          //     .copyWith(unReadMessageCount: updatedchat.unReadMessageCount + 1);

          _allchats.removeAt(indexOfChatToUpdate);
          _allchats.insert(0, updatedChatCount);
        }
      }
      notifyListeners();
    } else {
      // if the user not in group he we'll be the one who got added.
      // so we update only the chat
      Chat newchat = chat.copyWith(
          lastMessage: Message(
              messageId: chat.lastMessage.messageId,
              chatId: chat.lastMessage.chatId,
              content: "You were Added",
              attachments: chat.lastMessage.attachments,
              sender: chat.lastMessage.sender,
              createdAt: chat.lastMessage.createdAt,
              isCommonMessage: chat.lastMessage.isCommonMessage,
              readBy: chat.lastMessage.readBy),
          unReadMessageCount: chat.unReadMessageCount++);

      _allchats.insert(0, newchat);
      notifyListeners();
    }

    // int indexOfChatToUpdate =
    //     _allchats.indexWhere((element) => element.id == chat.id);
    // if (indexOfChatToUpdate != -1) {
    //   if (_allchats.any((element) => element.id == chat.id)) {
    //     //if user already in group
    //     if (_allmessages.isNotEmpty && _allmessages[0].chatId == chat.id) {
    //       //checks if the user viewing the same chat room
    //       if (_allmessages.any(
    //           (element) => element.messageId == chat.lastMessage.messageId)) {
    //         return;
    //       } else {
    //         _allmessages.add(chat.lastMessage);
    //       }
    //     }
    //     Chat updatedchat = _allchats[indexOfChatToUpdate]
    //         .copyWith(lastMessage: chat.lastMessage);

    //     _allchats.removeAt(indexOfChatToUpdate);
    //     _allchats.insert(0, updatedchat);
    //     notifyListeners();
    //   } else {
    //     //the user is the member who got added
    //     Chat updatedchat = _allchats[indexOfChatToUpdate].copyWith(
    //         lastMessage: Message(
    //             messageId: chat.lastMessage.messageId,
    //             chatId: chat.lastMessage.chatId,
    //             content: "You were Added",
    //             attachments: chat.lastMessage.attachments,
    //             sender: chat.lastMessage.sender,
    //             createdAt: chat.lastMessage.createdAt));

    //     _allchats.insert(0, chat);
    //     notifyListeners();
    //   }
    // }
  }

  void updateLastMessageInChat({required Chat newChat}) {}

  void removeGroupMember({required User user}) {}

  void updateGroupname({required String newName}) {}

  //dont need now
  void updateMemberDetails({required User user}) {}

  void updateAllMessageInchat(
      {required List<Message> readMessages,
      required List<Message> unreadMessage}) {
    // _allmessages = [];
    _allmessages = readMessages;
    _allUnreadMessages = unreadMessage;
    print(
        "All unreadMessage while opening message scrren is ${_allUnreadMessages}");
    notifyListeners();
  }

  void receiveMessage(
      {required Message newMsg, required BuildContext context}) {
    // if (kIsWeb) {
    //   bool ischatClicked =
    //       Provider.of<MessageInfoProvider>(context).isChatClicked;

    //   if (ischatClicked) {
    //     if (_allmessages.isNotEmpty &&
    //         _allmessages[0].chatId == newMsg.chatId) {
    //       //checks if the user viewing the same chat room
    //       if (_allmessages
    //           .any((element) => element.messageId == newMsg.messageId)) {
    //         return;
    //       } else {
    //         //message updated
    //         _allmessages.addAll(_allUnreadMessages);
    //         _allUnreadMessages = [];
    //         _allmessages.add(newMsg);

    //         //also updating the chat
    //         int indexOfChatToUpdate =
    //             _allchats.indexWhere((element) => element.id == newMsg.chatId);
    //         print("the index is ${indexOfChatToUpdate.toString()}");
    //         if (indexOfChatToUpdate != -1) {
    //           Chat updatedchat =
    //               _allchats[indexOfChatToUpdate].copyWith(lastMessage: newMsg);
    //           _allchats.removeAt(indexOfChatToUpdate);
    //           _allchats.insert(0, updatedchat);

    //           print("/////////////////////////////");
    //           print("/////////////////////////////");
    //           print("The allchat is ${_allchats[0].lastMessage.content}");
    //         }
    //         notifyListeners();
    //       }
    //     } else {
    //       //user must be in other message screen or chat screen
    //       //need to change the chat's lastmessage ,unreadcount and update it's index
    //       int indexOfChatToUpdate =
    //           _allchats.indexWhere((element) => element.id == newMsg.chatId);
    //       print("the index is ${indexOfChatToUpdate.toString()}");
    //       if (indexOfChatToUpdate != -1) {
    //         Chat updatedchat =
    //             _allchats[indexOfChatToUpdate].copyWith(lastMessage: newMsg);

    //         Chat updatedChatCount = updatedchat.copyWith(
    //             unReadMessageCount: updatedchat.unReadMessageCount + 1);

    //         // _allchats[indexOfChatToUpdate]
    //         //     .copyWith(unReadMessageCount: updatedchat.unReadMessageCount++);

    //         _allchats.removeAt(indexOfChatToUpdate);
    //         _allchats.insert(0, updatedChatCount);
    //         final String userUid =
    //             Provider.of<AuthMethods>(context, listen: false).user.uid;

    //         print("/////////////////////////////");
    //         print("/////////////////////////////");
    //         print("The allchat in else is ${_allchats[0].lastMessage.content}");
    //         print(
    //             "The allchat unreadCount in else is ${_allchats[0].unReadMessageCount}");

    //         // if (_allchats[0].lastMessage.sender.uid != userUid) {
    //         //   print("its here");
    //         //someone in the chatroom have messaged lastly
    //         //so if I'm not in that message room , the received msg will be unread by me
    //         //so need to add in _allUnreadMessage

    //         // _allUnreadMessages.add(_allchats[0].lastMessage);
    //         // }
    //         //  else {
    //         //I'm the one who sent the last message
    //         //so there will be no unreadmessages
    //         //don't need to add in _allUnreadMessage
    //         // }

    //         // print("All Unread Messages count are ${_allUnreadMessages.length}");
    //         // print("First Unread Message is ${_allUnreadMessages[0].content} ");
    //       }
    //       notifyListeners();
    //     }
    //   } else {}
    // } else {
    if (_allmessages.isNotEmpty && _allmessages[0].chatId == newMsg.chatId) {
      //checks if the user viewing the same chat room
      if (_allmessages
          .any((element) => element.messageId == newMsg.messageId)) {
        return;
      } else {
        //message updated
        _allmessages.addAll(_allUnreadMessages);
        _allUnreadMessages = [];
        _allmessages.add(newMsg);

        //also updating the chat
        int indexOfChatToUpdate =
            _allchats.indexWhere((element) => element.id == newMsg.chatId);
        print("the index is ${indexOfChatToUpdate.toString()}");
        if (indexOfChatToUpdate != -1) {
          Chat updatedchat =
              _allchats[indexOfChatToUpdate].copyWith(lastMessage: newMsg);
          _allchats.removeAt(indexOfChatToUpdate);
          _allchats.insert(0, updatedchat);

          print("/////////////////////////////");
          print("/////////////////////////////");
          print("The allchat is ${_allchats[0].lastMessage.content}");
        }
        notifyListeners();
      }
    } else {
      //user must be in other message screen or chat screen
      //need to change the chat's lastmessage ,unreadcount and update it's index
      int indexOfChatToUpdate =
          _allchats.indexWhere((element) => element.id == newMsg.chatId);
      print("the index is ${indexOfChatToUpdate.toString()}");
      if (indexOfChatToUpdate != -1) {
        Chat updatedchat =
            _allchats[indexOfChatToUpdate].copyWith(lastMessage: newMsg);

        Chat updatedChatCount = updatedchat.copyWith(
            unReadMessageCount: updatedchat.unReadMessageCount + 1);

        // _allchats[indexOfChatToUpdate]
        //     .copyWith(unReadMessageCount: updatedchat.unReadMessageCount++);

        _allchats.removeAt(indexOfChatToUpdate);
        _allchats.insert(0, updatedChatCount);
        final String userUid =
            Provider.of<AuthMethods>(context, listen: false).user.uid;

        print("/////////////////////////////");
        print("/////////////////////////////");
        print("The allchat in else is ${_allchats[0].lastMessage.content}");
        print(
            "The allchat unreadCount in else is ${_allchats[0].unReadMessageCount}");

        // if (_allchats[0].lastMessage.sender.uid != userUid) {
        //   print("its here");
        //someone in the chatroom have messaged lastly
        //so if I'm not in that message room , the received msg will be unread by me
        //so need to add in _allUnreadMessage

        // _allUnreadMessages.add(_allchats[0].lastMessage);
        // }
        //  else {
        //I'm the one who sent the last message
        //so there will be no unreadmessages
        //don't need to add in _allUnreadMessage
        // }

        // print("All Unread Messages count are ${_allUnreadMessages.length}");
        // print("First Unread Message is ${_allUnreadMessages[0].content} ");
      }
      notifyListeners();
    }
    // }
  }

  void sendMessageReadedAck(
      {required List<String> unreadMsgIds,
      required List<String> unreadSenderIds,
      required String chatId}) {
    // if (value.allUnreadMessage.isNotEmpty &&
    //               widget.chatdetails.lastMessage.sender.uid != uid) {
    print("its here");
    // List<Message> _allunreadMsgs =
    //     Provider.of<ChatProvider>(context, listen: false)
    //         .allUnreadMessage;

    // print("the allunreadMsgs is ${_allunreadMsgs}");

    // List<String> unreadMsgIds = _allunreadMsgs
    //     .where((element) => element.sender.uid != uid)
    //     .map((e) => e.messageId)
    //     .toList();

    // print("the unreadMessageIds are ${unreadMsgIds}");

    // List<String> unreadSenderIds = _allunreadMsgs
    //     .where((element) => element.sender.uid != uid)
    //     .map((e) => e.sender.id!)
    //     .toList();
    // print("the unreadSenderIds are ${unreadSenderIds}");

    //send msg-received-ack
    //update unread-message in clientside provider
    // _socketMethods.sendReadByAck(
    //     chatId: chatId,
    //     unreadMessageIds: unreadMsgIds,
    //     senderIds: unreadSenderIds);
    // }
  }

  void notifySenderAboutMessageReaded(
      {required User userWhoReadMsg,
      required String chatId,
      required List<String> unreadMessageIds}) {
    if (_allmessages.isNotEmpty && _allmessages[0].chatId == chatId) {
      //user viewing the same message room
      _allmessages
          .where((element) => unreadMessageIds.contains(element.messageId))
          .forEach((element) {
        element.readBy.add(userWhoReadMsg);
      });
      // print("The all unreadMessage while ACK is ${_allUnreadMessages}");
      notifyListeners();
    }
  }

  // void addNewMessage({required Message newMsg}) {
  //   if (_allmessages.isNotEmpty && _allmessages[0].chatId == newMsg.chatId) {
  //     //checks if the user viewing the same chat room

  //      if (_allmessages
  //         .any((element) => element.messageId == newMsg.messageId)) {
  //       return;
  //     }

  //   }
  // }
  // notifyListeners();

  //  check if the current chatscreen == newMsg screen. if yes add new msg to allmessages like below. or else just update the allchat

  //   if (_allmessages.any((element) => element.messageId == newMsg.messageId)) {
  //     return;
  //   } else {
  //     if (_allmessages.isNotEmpty && _allmessages[0].chatId == newMsg.chatId) {
  //       //checks if the message is  received in the same chatroom
  //       _allmessages.add(newMsg);
  //     }
  //     // _allmessages.add(newMsg);
  //     //   Chat chatToUpdate = _allchats.where((element) => element.id==newMsg.chatId).first;
  //     //   print("THE CHAT TO UPDATE IS ${chatToUpdate}");
  //     //   Chat updatedChat = chatToUpdate.lastMessage.;
  //     //  _allchats.insert(0, )

  //     int indexOfChatToUpdate =
  //         _allchats.indexWhere((element) => element.id == newMsg.chatId);
  //     if (indexOfChatToUpdate != -1) {
  //       Chat updatedchat =
  //           _allchats[indexOfChatToUpdate].copyWith(lastMessage: newMsg);

  //       _allchats.removeAt(indexOfChatToUpdate);
  //       _allchats.insert(0, updatedchat);
  //       notifyListeners();
  //     }
  //   }

  //   //after adding a message also update the last message and notify other users

  void updateNewOnlineUserStatus(
      {required String userId,
      required List<String> allChatIds,
      required bool isUserOnline,
      required String lastOfflineAt}) {
    _allchats.where((chat) => allChatIds.contains(chat.id)).forEach((element) {
      element.members = element.members.map((user) {
        if (user.id == userId) {
          return user.copyWith(
              isOnline: isUserOnline, lastOfflineAt: lastOfflineAt);
        } else {
          return user;
        }
      }).toList();

      // .where((user) => user.id == userId)
      // .forEach((filteredUser) {
      //   filteredUser = filteredUser.copyWith(isOnline: isUserOnline);
      // });

      notifyListeners();
    });
  }

  void updateUnreadMessageCount({required String chatId}) {
    // _allchats
    //     .where((element) => element.id == chatId)
    //     .first
    //     .copyWith(unReadMessageCount: 0);

    final chatToUpdate =
        _allchats.firstWhere((element) => element.id == chatId);
    final updatedChat = chatToUpdate.copyWith(unReadMessageCount: 0);

    _allchats[_allchats.indexOf(chatToUpdate)] = updatedChat;
    notifyListeners();
  }

//while entering the message screen or scrolling the unreadmessage to max extent or some time(delay) after entering the message screen
//or while leaving the mesage screen, all the unreadmessage needs to be cleared
//here just cleared it while leaving the messagescreen
  void updateUnreadMessageToEmpty() {
    _allUnreadMessages = [];
    notifyListeners();
  }

// //need this when getting unread msgs values from backend
//   void updateUnreadMsgToRead() {}

  void updateMessagesWhileSend() {
    _allmessages.addAll(allUnreadMessage);

    _allUnreadMessages = [];
    notifyListeners();
  }

  // void updateSendMessage({required Message message}) {
  //   _allmessages.add(message);
  //   notifyListeners();
  // }
}
