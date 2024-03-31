import 'package:chat/controller/chat_controller.dart';
import 'package:chat/model/fs_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatPage extends StatelessWidget {
  final ChatController cc = Get.put(ChatController());

  ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cc.receiver_name ?? ""),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("chat")
                    .doc(cc.chatRoomId.value)
                    .collection("messages")
                    .snapshots(),
                builder: (context, snapshot) {
                  List<QueryDocumentSnapshot> data = snapshot.data?.docs ?? [];
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      var item = data[index].data() as Map<String, dynamic>;
                      var isLoginUser = cc.senderId == item["senderId"];
                      return Align(
                        alignment: isLoginUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(isLoginUser ? 20 : 0),
                              bottomLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomRight:
                                  Radius.circular(isLoginUser ? 0 : 20),
                            ),
                          ),
                          child: Text(
                            item["message"],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          TextFormField(
            controller: cc.chatMsg,
            onFieldSubmitted: (value) {
              var cu = FirebaseAuth.instance.currentUser;
              var uid = cu?.uid ?? "";
              FsModel().chat(
                uid,
                cc.id ?? "",
                cu?.email ?? "",
                cc.email ?? "",
                cc.chatMsg.text,
                cc.receiver_name ?? "",
              );
              cc.chatMsg.clear();
            },
            decoration: InputDecoration(
              hintText: "Enter Message",
              suffixIcon: IconButton(
                onPressed: () {
                  var cu = FirebaseAuth.instance.currentUser;
                  var uid = cu?.uid ?? "";
                  print(cu?.email ?? "");
                  print(cc.email ?? "");
                  FsModel().chat(
                    uid,
                    cc.id ?? "",
                    cu?.email ?? "",
                    cc.email ?? "",
                    cc.chatMsg.text,
                    cc.receiver_name ?? "",
                  );
                  cc.chatMsg.clear();
                },
                icon: const Icon(Icons.send),
              ),
              border: const OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
