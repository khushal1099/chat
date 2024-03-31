import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:chat/model/chat_model.dart';
import 'package:chat/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../main.dart';

class FsModel {
  static final FsModel _instance = FsModel._();

  FsModel._();

  factory FsModel() {
    return _instance;
  }

  void addUser(User? user) async{

    File file = File(image.value);
    var readAsBytes = await file.readAsBytes();
    var img = base64Encode(readAsBytes);


    AuthUser authUser = AuthUser(
      name: user?.displayName ?? "",
      number: "",
      email: user?.email ?? "",
      image: img,
      lastMsg: "",
      lastTime: "${DateTime.now()}",
      online: "",
      status: "",
    );

    FirebaseFirestore.instance
        .collection("User")
        .doc(user?.uid ?? "")
        .set(authUser.toJson());
  }

  void chat(String senderId, String receiverId, String senderEmail,
      String receiverEmail, String message, String receiver_name) async {

    var doc1 = await FirebaseFirestore.instance
        .collection("chat")
        .doc("$senderId-$receiverId")
        .get();

    var doc2 = await FirebaseFirestore.instance
        .collection("chat")
        .doc("$receiverId-$senderId")
        .get();

    doc1.reference.set(
      {
        "last_msg": message,
        "sender_email": senderEmail,
        "receiver_email": receiverEmail,
        "senderId": senderId,
        "receiverId": receiverId,
        "receiver_name": receiver_name
      },
    );
    doc2.reference.set(
      {
        "last_msg": message,
        "sender_email": receiverEmail,
        "receiver_email": senderEmail,
        "senderId": receiverId,
        "receiverId": senderId,
        "receiver_name": receiver_name
      },
    );
    doc1.reference
        .collection("messages")
        .doc(DateTime.now().millisecondsSinceEpoch.toString())
        .set(
          ChatModel(
                  message: message,
                  senderEmail: senderEmail,
                  senderId: senderId,
                  time: "${DateTime.now()}")
              .toJson(),
        );
    doc2.reference
        .collection("messages")
        .doc(DateTime.now().millisecondsSinceEpoch.toString())
        .set(
      ChatModel(
          message: message,
          senderEmail: senderEmail,
          senderId: senderId,
          time: "${DateTime.now()}")
          .toJson(),
    );
  }
}
