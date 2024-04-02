import 'package:chat/main.dart';
import 'package:chat/model/chat_model.dart';
import 'package:chat/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FsModel {
  static final FsModel _instance = FsModel._();

  FsModel._();

  factory FsModel() {
    return _instance;
  }

  void addUser(User? user) async {
    AuthUser authUser = AuthUser(
      name: user?.displayName ?? name.text,
      number: number.text,
      email: user?.email ?? "",
      image: "",
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
      String receiverEmail, String message, String receiverName,
      String senderName) async {
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
        "receiver_name": receiverName,
        "sender_name": senderName
      },
    );
    doc2.reference.set(
      {
        "last_msg": message,
        "sender_email": receiverEmail,
        "receiver_email": senderEmail,
        "senderId": receiverId,
        "receiverId": senderId,
        "receiver_name": senderName,
        "sender_name": receiverName
      },
    );
    doc1.reference
        .collection("messages")
        .doc(DateTime
        .now()
        .millisecondsSinceEpoch
        .toString())
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
        .doc(DateTime
        .now()
        .millisecondsSinceEpoch
        .toString())
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
