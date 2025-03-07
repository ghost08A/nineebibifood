import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nineebibifood/app_controller.dart';
import 'package:nineebibifood/authMiddleware.dart';
import 'package:nineebibifood/history.dart';
import 'package:nineebibifood/home.dart';
import 'package:nineebibifood/login.dart';
import 'package:nineebibifood/market_list.dart';
import 'package:nineebibifood/menu1.dart';
import 'package:nineebibifood/orderDetail.dart';
import 'package:nineebibifood/payment.dart';
import 'package:nineebibifood/profile.dart';
import 'package:nineebibifood/signUp.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ✅ ป้องกันปัญหา async ใน main()
  await dotenv.load(fileName: ".env");

  Get.put(AppController()); // ✅ ใช้ GetX Controller
  Get.put(await SharedPreferences.getInstance()); // ✅ ใส่ SharedPreferences

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/homenine',
      getPages: [
        GetPage(name: '/menu1', page: () => Menu1()),
        GetPage(name: '/market_list', page: () => MarketList()),

        GetPage(name: '/homenine', page: () => Homenine()), // ✅ เข้าได้เสมอ
        GetPage(
            name: '/payment',
            page: () => Payment(),
            middlewares: [AuthMiddleware()]), // ✅ ต้องมี Token
        GetPage(
            name: '/orderDetail',
            page: () => Orderdetail(),
            middlewares: [AuthMiddleware()]), // ✅ ต้องมี Token
        GetPage(name: '/login', page: () => Login1()),
        GetPage(name: '/signUp', page: () => Signup()),
        GetPage(
            name: '/profile',
            page: () => Profile(),
            middlewares: [AuthMiddleware()]), // ✅ ต้องมี Token
        GetPage(
            name: '/history',
            page: () => History(),
            middlewares: [AuthMiddleware()]), // ✅ ต้องมี Token
      ],
    );
  }
}
