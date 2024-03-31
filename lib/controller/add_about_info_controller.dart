import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../main.dart';

class AddAboutInfoController extends GetxController {

  XFile? xFile;

  final picker = ImagePicker();

  TextEditingController name = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController email = TextEditingController();

  void addcameraimage() async{
    final pickedfile = await picker.pickImage(source: ImageSource.camera);
    if(pickedfile!=null){
      xFile = pickedfile;
      image.value = xFile!.path;
    }
  }

  void addcameragallery() async{
    final pickedfile = await picker.pickImage(source: ImageSource.gallery);
    if(pickedfile!=null){
      xFile = pickedfile;
      image.value = xFile!.path;
    }
  }
}
