import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  String? id;
  String? senderId;
  String? email;
  String? name;
  String? receiverimage;
  RxString chatRoomId = "".obs;

  TextEditingController chatMsg = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      id = Get.arguments["id"];
      email = Get.arguments["email"];
      receiverimage = Get.arguments["image"];
      name = Get.arguments["name"];
    }
    senderId = FirebaseAuth.instance.currentUser?.uid ?? "";
    chatRoomId.value = "$senderId-$id";
    print(chatRoomId.value);
  }
}
