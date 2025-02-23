import 'package:flutter/material.dart';
import 'package:nineebibifood/auth.dart';
import 'package:nineebibifood/detail.dart';
import 'package:nineebibifood/homenine.dart';
import 'package:nineebibifood/login.dart';
import 'package:nineebibifood/login1.dart';
import 'package:nineebibifood/orderDetail.dart';
import 'package:nineebibifood/payment.dart';
import 'package:nineebibifood/restaurant_list.dart';
import 'package:nineebibifood/signUp.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nineebibifood/splash_screen.dart';
import 'package:nineebibifood/store_list.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nineebibifood/admin/adminHome.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
      url: dotenv.env['APIURL']!, anonKey: dotenv.env['APIKEY']!);
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          appBarTheme: AppBarTheme(color: Colors.blue),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/splashScreen': (context) => SplashScreen(),
          '/auth': (context) => AuthScreen(),
          '/login': (context) => Login(),
          '/homenine': (context) => Homenine(),
          '/restaurant_list': (context) => RestaurantList(),
          '/store_list': (context) => StoreList(),
          '/detail': (context) => Detail(),
          '/payment': (context) => Payment(),
          '/orderDetail': (context) => Orderdetail(),
          '/': (context) => Login1(),
          '/signUp': (context) => Signup(),
          '/adminHome': (context) => AdminHome(),
        });
  }
}
