import 'dart:io';
import 'package:chat/controller/edit_profile_controller.dart';
import 'package:chat/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class EditProfile extends StatelessWidget {
  final EditProfileController controller = Get.put(EditProfileController());

  EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          height: MediaQuery.sizeOf(context).height * 0.44,
          width: MediaQuery.sizeOf(context).width * 0.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35),
            color: Colors.grey,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Obx(
                  () => Stack(
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.white,
                        backgroundImage: controller.image.value.isNotEmpty
                            ? FileImage(File(controller.image.value))
                            : null,
                      ),
                      Positioned(
                        left: 0,
                        bottom: 0,
                        child: IconButton(
                          onPressed: () {
                            controller.addcameragallery();
                          },
                          icon: Icon(Icons.photo),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: IconButton(
                          onPressed: () {
                            controller.addcameraimage();
                          },
                          icon: Icon(Icons.camera_alt),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: controller.name,
                    decoration: InputDecoration(
                      hintText: "Enter your name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: controller.number,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      hintText: "Enter your number",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    AuthUser user = AuthUser(
                      image: controller.image.toString(),
                      name: controller.name.text,
                      email: FirebaseAuth.instance.currentUser?.email,
                      number: controller.number.text,
                      lastTime: DateTime.now().toString(),
                    );
                    try {
                      await FirebaseFirestore.instance
                          .collection("User")
                          .doc(FirebaseAuth.instance.currentUser?.uid ?? "")
                          .update(user.toJson());
                      // Show a success Snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Profile updated successfully!'),
                          duration: Duration(seconds: 2), // Optional duration
                        ),
                      );
                    } catch (error) {
                      // Show an error Snackbar if update fails
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to update profile: $error'),
                          duration: Duration(seconds: 2), // Optional duration
                        ),
                      );
                    }
                  },
                  child: Text("Edit"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
