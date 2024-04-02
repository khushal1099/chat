import 'dart:io';
import 'package:chat/view/chat_page.dart';
import 'package:chat/view/edit_profile_page.dart';
import 'package:chat/view/loginpage.dart';
import 'package:chat/view/users_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var cu = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    FirebaseFirestore.instance.collection("User").get().then((value) {
      return (value) {};
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("User")
            .doc(cu?.uid ?? "")
            .snapshots(),
        builder: (context, snapshot) {
          var data = snapshot.data?.data() as Map<String, dynamic>?;
          print("data=>$data");

          return NavigationDrawer(
            children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundImage: FileImage(File("${data?["image"]}")),
                ),
                accountEmail: Text(cu?.email ?? ""),
                accountName:
                    cu != null && cu!.providerData[0].providerId == 'google.com'
                        ? Text(cu?.displayName ?? "")
                        : Text("${data?["name"]}"),
              ),
              ListTile(
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  await GoogleSignIn().signOut();
                  Get.offAll(
                    LoginPage(),
                  );
                },
                title: Text("Logout"),
              ),
              ListTile(
                onTap: () {
                  Get.to(() => EditProfile());
                },
                title: Text("Edit profile"),
                trailing: Icon(Icons.edit),
              )
            ],
          );
        },
      ),
      appBar: AppBar(
        title: Text("HomePage"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("chat")
            .where("sender_email",
                isEqualTo:
                    FirebaseAuth.instance.currentUser?.email ?? "")
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
                  var uid = FirebaseAuth.instance.currentUser?.uid ?? "";
                  String id = (uid == data["receiverId"])
                      ? data["senderId"]
                      : data["receiverId"];
                  String email = (uid == data["receiverId"])
                      ? data["sender_email"]
                      : data["receiver_email"];
                  String name = (uid == data["receiverId"])
                      ? data["sender_name"]
                      : data["receiver_name"];
                  Get.to(
                    () => ChatPage(),
                    arguments: {
                      "id": id,
                      "email": email,
                      "name": name,
                      "roomId": item.id,
                    },
                  );
                },
                title: Text("${data["receiver_name"]}"),
                subtitle: Text("${data["last_msg"]}"),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => UsersPage());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
