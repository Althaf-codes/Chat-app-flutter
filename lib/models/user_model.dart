// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class User {
  String? id;
  String? username;
  String? phoneNumber;
  String? uid;
  ProfilePic? profilePic;
  bool isOnline;
  String? lastOfflineAt;

  User({
    required this.id,
    required this.username,
    required this.phoneNumber,
    required this.uid,
    required this.profilePic,
    required this.isOnline,
    required this.lastOfflineAt,
  });

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["_id"] ?? '',
        username: json["username"] ?? '',
        phoneNumber: json["phoneNumber"] ?? '',
        uid: json["uid"] ?? '',
        profilePic: ProfilePic.fromMap(json["profilePic"]),
        isOnline: json["isOnline"] ?? false,
        lastOfflineAt: json["lastOfflineAt"] ?? '',
      );

  Map<String, dynamic> toMap() => {
        "_id": id,
        "username": username,
        "phoneNumber": phoneNumber,
        "uid": uid,
        "profilePic": profilePic?.toMap(),
        "isOnline": isOnline,
        "lastOfflineAt": lastOfflineAt,
      };

  User copyWith(
      {String? id,
      String? username,
      String? phoneNumber,
      String? uid,
      ProfilePic? profilePic,
      bool? isOnline,
      String? lastOfflineAt}) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      uid: uid ?? this.uid,
      profilePic: profilePic ?? this.profilePic,
      isOnline: isOnline ?? this.isOnline,
      lastOfflineAt: lastOfflineAt ?? this.lastOfflineAt,
    );
  }
}

class ProfilePic {
  String url;
  String localPath;

  ProfilePic({
    required this.url,
    required this.localPath,
  });

  factory ProfilePic.fromJson(String str) =>
      ProfilePic.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProfilePic.fromMap(Map<String, dynamic> json) => ProfilePic(
        url: json["url"] ?? '',
        localPath: json["localPath"] ?? '',
      );

  Map<String, dynamic> toMap() => {
        "url": url,
        "localPath": localPath,
      };
}
