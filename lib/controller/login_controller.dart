import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class LoginController extends GetxController {
  var passwordVisible = true.obs;
  var isLoading = false.obs;

  void toggle() {
    passwordVisible.value = !passwordVisible.value;
  }

  void setLoading(bool value) {
    isLoading(value);
  }
}