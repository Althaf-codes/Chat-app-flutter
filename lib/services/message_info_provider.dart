import 'package:chatappp_socketio/models/chat_model.dart';
import 'package:chatappp_socketio/models/message_info_model.dart';
import 'package:chatappp_socketio/models/message_model.dart';
import 'package:chatappp_socketio/models/user_model.dart';
import 'package:flutter/material.dart';

class MessageInfoProvider extends ChangeNotifier {
  bool _isChatClicked = false;

  MessageInfoModel _messageInfoModel = MessageInfoModel(
      chatdetails: Chat(
          id: '',
          name: '',
          members: [],
          isGroupChat: false,
          lastMessage: Message(
              messageId: '',
              chatId: '',
              content: '',
              attachments: [],
              sender: User(
                  id: '',
                  username: '',
                  phoneNumber: '',
                  uid: '',
                  profilePic: ProfilePic(url: '', localPath: ''),
                  isOnline: false,
                  lastOfflineAt: ''),
              createdAt: '',
              isCommonMessage: false,
              readBy: []),
          admin: '',
          createdAt: '',
          unReadMessageCount: 0),
      isGroupChat: false,
      lastOfflineAt: '');

  void setMessageInfoModel({required MessageInfoModel messageInfoModel}) {
    _messageInfoModel = messageInfoModel;
    notifyListeners();
  }

  void setChatClicked() {
    _isChatClicked = true;
    notifyListeners();
  }

  bool get isChatClicked => _isChatClicked;

  MessageInfoModel get messageInfoModel => _messageInfoModel;
}
