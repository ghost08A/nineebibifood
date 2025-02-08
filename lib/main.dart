import 'package:flutter/material.dart';
import 'package:nineebibifood/login.dart';
import 'package:nineebibifood/signUp.dart';

void main() {
  runApp(const MyApp());
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
          '/': (context) => Login(),
          '/signUp': (context) => Signup(),
        });
  }
}
