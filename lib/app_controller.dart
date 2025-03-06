import 'package:get/get.dart';

class AppController extends GetxController {
  var token = ''.obs; // ✅ ใช้เก็บ Token

  void setToken(String? newToken) {
    token.value = newToken ?? ''; // ✅ ถ้า Token เป็น `null` → ตั้งเป็น `''`
  }
}
