import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileController extends GetxController {

  RxString image = ''.obs;
  final picker = ImagePicker();
  var cu = FirebaseAuth.instance.currentUser;

  void addcameraimage() async {
    final pickedfile = await picker.pickImage(source: ImageSource.camera);
    if (pickedfile != null) {
      image.value = pickedfile.path;
      var readAsBytes = await pickedfile.readAsBytes();
      var base64encode = base64Encode(readAsBytes);
      FirebaseFirestore.instance.collection("User").doc(cu?.uid ?? "").update(
        {
          "image": base64encode,
        },
      );
    }
  }

  void addcameragallery() async {
    final pickedfile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedfile != null) {
      image.value = pickedfile.path;
      var readAsBytes = await pickedfile.readAsBytes();
      var base64encode = base64Encode(readAsBytes);

      FirebaseFirestore.instance.collection("User").doc(cu?.uid ?? "").update(
        {
          "image": base64encode,
        },
      );
    }
  }
}
