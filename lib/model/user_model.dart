// To parse this JSON data, do
//
//     final authUser = authUserFromJson(jsonString);

import 'dart:convert';

List<AuthUser> authUserFromJson(String str) => List<AuthUser>.from(json.decode(str).map((x) => AuthUser.fromJson(x)));

String authUserToJson(List<AuthUser> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AuthUser {
  String? name;
  String? number;
  String? lastMsg;
  String? lastTime;
  String? status;
  String? image;
  String? online;
  String? email;

  AuthUser({
    this.name,
    this.number,
    this.lastMsg,
    this.lastTime,
    this.status,
    this.image,
    this.online,
    this.email,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
    name: json["name"],
    number: json["number"],
    lastMsg: json["last_msg"],
    lastTime: json["last_time"],
    status: json["status"],
    image: json["image"],
    online: json["online"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "number": number,
    "last_msg": lastMsg,
    "last_time": lastTime,
    "status": status,
    "image": image,
    "online": online,
    "email": email,
  };
}
