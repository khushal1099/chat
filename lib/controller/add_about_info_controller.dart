import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../main.dart';

class AddAboutInfoController extends GetxController {

  XFile? xFile;
  RxString image = ''.obs;
  final picker = ImagePicker();

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
