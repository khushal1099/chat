import 'package:chat/controller/chat_controller.dart';
import 'package:chat/view/chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UsersPage extends StatelessWidget {
  UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("User")
            .orderBy("last_time", descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          var list = snapshot.data?.docs ?? [];
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              var item = list[index];
              var data = item.data() as Map<String, dynamic>;

              return ListTile(
                onTap: () {
                  Get.to(
                    () => ChatPage(),
                    arguments: {
                      "id": item.id,
                      "email": data["email"],
                      "receiver_name":data["name"],
                    },
                  );
                },
                title: Text(
                  "${data["name"]}",
                  style: TextStyle(fontSize: 30),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
