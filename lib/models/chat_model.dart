import 'dart:convert';

import 'package:chatappp_socketio/models/message_model.dart';
import 'package:chatappp_socketio/models/user_model.dart';

class Chat {
  String id;
  String name;
  List<User> members;
  bool isGroupChat;
  Message lastMessage;
  String admin;
  String createdAt;
  int unReadMessageCount;

  Chat(
      {required this.id,
      required this.name,
      required this.members,
      required this.isGroupChat,
      required this.lastMessage,
      required this.admin,
      required this.createdAt,
      required this.unReadMessageCount});

  Chat copyWith({
    String? id,
    String? name,
    List<User>? members,
    bool? isGroupChat,
    Message? lastMessage,
    String? admin,
    String? createdAt,
    int? unReadMessageCount,
  }) =>
      Chat(
        id: id ?? this.id,
        name: name ?? this.name,
        members: members ?? this.members,
        isGroupChat: isGroupChat ?? this.isGroupChat,
        lastMessage: lastMessage ?? this.lastMessage,
        admin: admin ?? this.admin,
        createdAt: createdAt ?? this.createdAt,
        unReadMessageCount: unReadMessageCount ?? this.unReadMessageCount,
      );

  factory Chat.fromJson(String str) => Chat.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Chat.fromMap(Map<String, dynamic> json) => Chat(
        id: json["_id"] ?? '',
        name: json["name"] ?? '',
        members: List<User>.from(json["members"].map((x) => User.fromMap(x))),
        isGroupChat: json["isGroupChat"] ?? false,
        lastMessage: Message.fromMap(json["lastMessage"]),
        // ??
        // Message(
        //     messageId: "",
        //     chatId: "",
        //     content: "",
        //     attachments: [],
        //     sender: User(
        //         id: "",
        //         username: "",
        //         phoneNumber: "",
        //         uid: "",
        //         profilePic: ProfilePic(url: "", localPath: "")),
        //     createdAt: ""),
        admin: json["admin"] ?? '',
        createdAt: json["createdAt"] ?? '',
        unReadMessageCount: json["unReadMessageCount"] ?? 0,
      );

  Map<String, dynamic> toMap() => {
        "_id": id,
        "name": name,
        "members": List<dynamic>.from(members.map((x) => x)),
        "isGroupChat": isGroupChat,
        "lastMessage": lastMessage,
        "admin": admin,
        "createdAt": createdAt,
        "unReadMessageCount": unReadMessageCount
      };
}
