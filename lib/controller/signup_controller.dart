import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class SignupController extends GetxController {

  var passwordVisible = true.obs;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  void toggle() {
    passwordVisible.value = !passwordVisible.value;
  }

}