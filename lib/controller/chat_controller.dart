import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  String? id;
  String? senderId;
  String? email;
  String? receiver_name;
  RxString chatRoomId = "".obs;

  TextEditingController chatMsg = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      id = Get.arguments["id"];
      email = Get.arguments["email"];
      receiver_name = Get.arguments["receiver_name"];
    }
    senderId = FirebaseAuth.instance.currentUser?.uid ?? "";
    chatRoomId.value = "$senderId-$id";
    print(chatRoomId.value);
  }
}
