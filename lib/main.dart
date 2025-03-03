import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nineebibifood/app_controller.dart';
import 'package:nineebibifood/app_controller.dart'; // ✅ แก้ Import ให้ถูกต้อง
import 'package:nineebibifood/auth.dart';
import 'package:nineebibifood/detail.dart';
import 'package:nineebibifood/history.dart';
import 'package:nineebibifood/homenine.dart';
import 'package:nineebibifood/login1.dart';
import 'package:nineebibifood/market_list.dart';
import 'package:nineebibifood/menu1.dart';
import 'package:nineebibifood/orderDetail.dart';
import 'package:nineebibifood/payment.dart';
import 'package:nineebibifood/profile.dart';

import 'package:nineebibifood/signUp.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nineebibifood/store_list.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
      url: dotenv.env['APIURL']!, anonKey: dotenv.env['APIKEY']!);

  // ✅ ใช้ Get.put() เพื่อสร้าง Controller
  Get.put(AppController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final appController = Get.find<AppController>();

    // ✅ ป้องกัน null ก่อนใช้ `setUserId()`
    if (user?.id != null) {
      appController.setUserId(user!.id);
    }

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Colors.blue),
        useMaterial3: true,
      ),
      // ✅ แก้ `initialRoute` ให้ตรงกับที่มีใน `getPages`
      initialRoute: user == null ? '/login' : '/homenine',

      getPages: [
        GetPage(name: '/menu1', page: () => Menu1()),
        GetPage(name: '/market_list', page: () => MarketList()),
        GetPage(name: '/auth', page: () => AuthScreen()),
        GetPage(name: '/homenine', page: () => Homenine()),
        GetPage(name: '/store_list', page: () => StoreList()),
        GetPage(name: '/detail', page: () => Detail()),
        GetPage(name: '/payment', page: () => Payment()),
        GetPage(name: '/orderDetail', page: () => Orderdetail()),
        GetPage(name: '/login', page: () => Login1()),
        GetPage(name: '/signUp', page: () => Signup()),
        GetPage(name: '/profile', page: () => Profile()),
        GetPage(name: '/history', page: () => History()),
      ],
    );
  }
}
