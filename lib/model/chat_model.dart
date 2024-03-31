// To parse this JSON data, do
//
//     final chatModel = chatModelFromJson(jsonString);

import 'dart:convert';

List<ChatModel> chatModelFromJson(String str) => List<ChatModel>.from(json.decode(str).map((x) => ChatModel.fromJson(x)));

String chatModelToJson(List<ChatModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChatModel {
  String? message;
  String? senderId;
  String? senderEmail;
  String? time;

  ChatModel({
    this.message,
    this.senderId,
    this.senderEmail,
    this.time,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
    message: json["message"],
    senderId: json["senderId"],
    senderEmail: json["senderEmail"],
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "senderId": senderId,
    "senderEmail": senderEmail,
    "time": time,
  };
}
