import 'dart:convert';

import 'package:chatappp_socketio/models/user_model.dart';

class Message {
  String messageId;
  String chatId;
  String content;
  List<Attachment> attachments;
  User sender;
  String createdAt;
  bool isCommonMessage;
  List<User> readBy;

  Message({
    required this.messageId,
    required this.chatId,
    required this.content,
    required this.attachments,
    required this.sender,
    required this.createdAt,
    required this.isCommonMessage,
    required this.readBy,
  });

  Message copyWith({
    String? messageId,
    String? chatId,
    String? content,
    List<Attachment>? attachments,
    User? sender,
    String? createdAt,
    bool? isCommonMessage,
    List<User>? readBy,
  }) =>
      Message(
          messageId: messageId ?? this.messageId,
          chatId: chatId ?? this.chatId,
          content: content ?? this.content,
          attachments: attachments ?? this.attachments,
          sender: sender ?? this.sender,
          createdAt: createdAt ?? this.createdAt,
          isCommonMessage: isCommonMessage ?? this.isCommonMessage,
          readBy: readBy ?? this.readBy);

  factory Message.fromJson(String str) => Message.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Message.fromMap(Map<String, dynamic> json) => Message(
      messageId: json["_id"],
      chatId: json["chatId"] ?? '',
      content: json["content"] ?? '',
      attachments: List<Attachment>.from(
              json["attachments"].map((x) => Attachment.fromMap(x))).toList() ??
          [],
      sender: User.fromMap(json["sender"]),
      createdAt: json["createdAt"] ?? '',
      isCommonMessage: json["isCommonMessage"] ?? false,
      readBy: (json["readBy"] as List<dynamic>?)
              ?.map((x) => User.fromMap(x as Map<String, dynamic>))
              .toList() ??
          []

      // List<User>.from(json["readBy"] ?? [].map((x) => User.fromMap(x)))
      //     .toList()
      );

  Map<String, dynamic> toMap() => {
        "_id": messageId,
        "chatId": chatId,
        "content": content,
        "attachments": List<dynamic>.from(attachments.map((x) => x.toMap())),
        "sender": sender,
        "createdAt": createdAt,
        "isCommonMessage": isCommonMessage,
        "readBy": List<dynamic>.from(readBy.map((x) => x))
      };
}

class Attachment {
  String url;
  String localPath;
  String mimeType;

  Attachment({
    required this.url,
    required this.localPath,
    required this.mimeType,
  });

  Attachment copyWith({
    String? url,
    String? localPath,
    String? mimeType,
  }) =>
      Attachment(
        url: url ?? this.url,
        localPath: localPath ?? this.localPath,
        mimeType: mimeType ?? this.mimeType,
      );

  factory Attachment.fromJson(String str) =>
      Attachment.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Attachment.fromMap(Map<String, dynamic> json) => Attachment(
        url: json["url"] ?? '',
        localPath: json["localPath"] ?? '',
        mimeType: json["mimeType"] ?? '',
      );

  Map<String, dynamic> toMap() => {
        "url": url,
        "localPath": localPath,
        "mimeType": mimeType,
      };
}
