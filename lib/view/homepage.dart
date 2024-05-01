import 'dart:convert';
import 'dart:typed_data';
import 'package:chat/view/chat_page.dart';
import 'package:chat/view/edit_profile_page.dart';
import 'package:chat/view/loginpage.dart';
import 'package:chat/view/splash_screen.dart';
import 'package:chat/view/users_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../controller/theme_controller.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ThemeController controller = Get.put(ThemeController());
  var cu = FirebaseAuth.instance.currentUser;
  var sname;

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
            // backgroundColor: Colors.black,
            children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: cu != null &&
                        cu!.providerData.isNotEmpty &&
                        cu!.providerData[0].providerId == 'google.com'
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(data?["image"] ?? ""),
                        radius: 30, // Adjust the radius as needed
                      )
                    : data?["image"] != null
                        ? StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("User")
                                .doc(cu?.uid ?? "")
                                .snapshots(),
                            builder: (context, snapshot) {
                              var img = (snapshot.data?.data()
                                  as Map<String, dynamic>?)?["image"];
                              Uint8List? decodeimg;
                              if (img != null) {
                                decodeimg = base64Decode(img);
                              }
                              return CircleAvatar(
                                backgroundImage: decodeimg != null
                                    ? MemoryImage(decodeimg)
                                    : null,
                                radius: 30, // Adjust the radius as needed
                              );
                            })
                        : CircleAvatar(
                            child: Icon(Icons.account_circle),
                            radius: 30, // Adjust the radius as needed
                          ),
                accountEmail: Text(cu?.email ?? ""),
                accountName:
                    cu != null && cu!.providerData[0].providerId == 'google.com'
                        ? Text(cu?.displayName ?? "")
                        : Text(
                            "${data?["name"]}",
                          ),
              ),
              ListTile(
                onTap: () {
                  Get.to(() => EditProfile());
                },
                title: Text(
                  "Edit profile",
                  // style: TextStyle(color: Colors.white),
                ),
                trailing: Icon(
                  Icons.edit,
                  // color: Colors.white,
                ),
              ),
              Obx(
                () => ListTile(
                  onTap: () {
                    controller.toggleTheme();
                  },
                  title: controller.isDarkMode.value
                      ? Text(
                          "Light Mode",
                          // style: TextStyle(color: Colors.white),
                        )
                      : Text(
                          "Dark Mode",
                          // style: TextStyle(color: Colors.white),
                        ),
                  trailing: GetBuilder<ThemeController>(
                    builder: (ThemeController) {
                      return Obx(
                        () => AnimatedSwitcher(
                          duration: Duration(milliseconds: 200),
                          child: controller.isDarkMode.value
                              ? Icon(
                                  Icons.wb_sunny,
                                  // color: Colors.white,
                                  key: Key('light_icon'),
                                )
                              : Icon(
                                  Icons.nightlight_round,
                                  // color: Colors.white,
                                  key: Key('dark_icon'),
                                ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              ListTile(
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  await GoogleSignIn().signOut();
                  Get.offAll(
                    LoginPage(),
                  );
                },
                title: Text(
                  "Logout",
                  // style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      ),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Chats"),
        backgroundColor: Colors.transparent,
        // foregroundColor: Colors.white,
        centerTitle: true,
      ),
      // backgroundColor: Colors.black,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("chat")
            .where("sender_email",
                isEqualTo: FirebaseAuth.instance.currentUser?.email ?? "")
            .snapshots(),
        builder: (context, snapshot) {
          var list = snapshot.data?.docs ?? [];
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              var item = list[index];
              var data = item.data() as Map<String, dynamic>;
              return GestureDetector(
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Confirm Deletion'),
                        content:
                            Text('Are you sure you want to delete this user?'),
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
                              FirebaseFirestore.instance
                                  .collection('chat')
                                  .doc(item.id)
                                  .delete();
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
                    onTap: () async {
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
                      String image = (uid == data["receiverId"])
                          ? data["sender_image"]
                          : data["receiver_image"];
                      Get.to(
                        () => ChatPage(),
                        arguments: {
                          "id": id,
                          "email": email,
                          "name": name,
                          "image": image,
                          "roomId": item.id,
                        },
                      );
                    },
                    // leading: CircleAvatar(
                    //   radius: 30,
                    //   backgroundImage: data["receiver_image"] != null
                    //       ? MemoryImage(base64Decode(data["receiver_image"]))
                    //       : null,
                    // ),
                    leading: GestureDetector(
                      onLongPressStart: (_) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return CircleAvatar(
                              radius: 30,
                              backgroundImage: data["receiver_image"] != null
                                  ? MemoryImage(base64Decode(data["receiver_image"]))
                                  : null,
                            );
                          },
                        );
                      },
                      onLongPressEnd: (_) {
                        Navigator.of(context).pop(); // Dismiss the AlertDialog
                      },
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: data["receiver_image"] != null
                            ? MemoryImage(base64Decode(data["receiver_image"]))
                            : null,
                      ),
                    ),
                    title: Text(
                      "${data["receiver_name"]}",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      "${data["last_msg"]}",
                    ),
                    trailing: IconButton(
                      onPressed: () {
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
                        String image = (uid == data["receiverId"])
                            ? data["sender_image"]
                            : data["receiver_image"];
                        Get.to(
                          () => ChatPage(),
                          transition: Transition.cupertinoDialog,
                          duration: Duration(milliseconds: 500),
                          arguments: {
                            "id": id,
                            "email": email,
                            "name": name,
                            "image": image,
                            "roomId": item.id,
                          },
                        );
                      },
                      icon: Icon(
                        Icons.chat,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(
            UsersPage(),
            transition: Transition.cupertinoDialog, // Set the transition animation
            duration: Duration(milliseconds: 500), // Set the animation duration
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
