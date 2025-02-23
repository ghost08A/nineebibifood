import 'package:flutter/material.dart';
import '../navigation_drawer.dart' as custom; // นำเข้า NavigationDrawer

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Welcome',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      drawer:
          const custom.NavigationDrawer(), // ใช้ NavigationDrawer ที่แยกออกไป
      body: const Center(
        child: Text(
          "Admin Home Page",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
