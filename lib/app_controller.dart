import 'package:get/get.dart';

class AppController extends GetxController {
  var userId = ''.obs;

  void setUserId(String id) => userId.value = id;
}
