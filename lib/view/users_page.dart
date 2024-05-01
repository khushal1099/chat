import 'dart:convert';
import 'package:chat/view/chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UsersPage extends StatelessWidget {
  UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_sharp,
          ),
        ),
        title: Text(
          "Users",
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("User")
            .orderBy("last_time", descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          var list = snapshot.data?.docs ?? [];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                var item = list[index];
                var data = item.data() as Map<String, dynamic>;
                return GestureDetector(
                  onLongPress: () {
                    // Show alert dialog to confirm deletion
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Confirm Deletion'),
                          content: Text('Are you sure you want to delete this user?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                // Perform deletion
                                FirebaseFirestore.instance.collection('User').doc(item.id).delete();
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Card(
                    child: ListTile(
                      onTap: () {
                        Get.to(
                              () => ChatPage(),
                          transition: Transition.cupertinoDialog,
                          duration: Duration(milliseconds: 500),
                          arguments: {
                            "id": item.id,
                            "email": data["email"],
                            "name": data["name"],
                            "image": data["image"],
                          },
                        );
                      },
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: data["image"] != null
                            ? MemoryImage(base64Decode(data["image"]))
                            : null,
                      ),
                      title: Text(
                        "${data["name"]}",
                        style: TextStyle(fontSize: 30),
                      ),
                      subtitle: Text(
                        "${data["nickname"]}",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
