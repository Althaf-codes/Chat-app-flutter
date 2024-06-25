// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:chatappp_socketio/models/chat_model.dart';

class MessageInfoModel {
  Chat chatdetails;
  bool isGroupChat;
  String lastOfflineAt;
  MessageInfoModel({
    required this.chatdetails,
    required this.isGroupChat,
    required this.lastOfflineAt,
  });
}

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'socketMethods': socketMethods.toMap(),
//       'chatdetails': chatdetails.toMap(),
//       'isGroupChat': isGroupChat,
//       'lastOfflineAt': lastOfflineAt,
//     };
//   }

//   factory MessageInfoModel.fromMap(Map<String, dynamic> map) {
//     return MessageInfoModel(
//       socketMethods:
//           SocketMethods.fromMap(map['socketMethods'] as Map<String, dynamic>),
//       chatdetails: Chat.fromMap(map['chatdetails'] as Map<String, dynamic>),
//       isGroupChat: map['isGroupChat'] as bool,
//       lastOfflineAt: map['lastOfflineAt'] as String,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory MessageInfoModel.fromJson(String source) =>
//       MessageInfoModel.fromMap(json.decode(source) as Map<String, dynamic>);
// }
