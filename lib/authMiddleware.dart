import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    return _checkToken();
  }

  RouteSettings? _checkToken() {
    final prefs =
        Get.find<SharedPreferences>(); // ✅ ใช้ GetX ดึง SharedPreferences
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      return const RouteSettings(name: '/login'); // ✅ ไม่มี Token → ไป Login
    }
    return null; // ✅ มี Token → เข้าได้
  }
}
