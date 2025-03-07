import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nineebibifood/app_controller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Login1 extends StatefulWidget {
  @override
  _Login1State createState() => _Login1State();
}

class _Login1State extends State<Login1> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;

  final appController = Get.find<AppController>(); // ✅ ใช้ GetX Controller

  Future<void> _signIn() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showSnackbar('❌ Please enter email and password.');
      return;
    }
    setState(() => _loading = true);

    try {
      // ✅ ส่งข้อมูลไปที่ API
      final response = await http.post(
        Uri.parse('${dotenv.env['BASE_URL']}api/auth/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": _emailController.text.trim(),
          "password": _passwordController.text,
        }),
      );

      print("📌 API Response: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['token'] != null) {
        final token = data['token'];

        // ✅ บันทึก Token ลง SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        print("✅ Login Successful: Token = $token");

        _showSnackbar('✅ Login Successful!');

        // ✅ เปลี่ยนหน้าไป `Homenine` โดยใช้ `GetX`
        Get.offNamed('/homenine');
      } else {
        _showSnackbar('❌ Invalid email or password.');
      }
    } catch (error) {
      print('Error during login: $error');
      _showSnackbar('❌ Failed to login.');
    } finally {
      setState(() => _loading = false);
    }
  }

  void _showSnackbar(String message) {
    Get.snackbar('Login Status', message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black54,
        colorText: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "NINEBIBIFOOD",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 50,
                color: Colors.orange,
                letterSpacing: 2,
                shadows: [
                  Shadow(
                    blurRadius: 5,
                    color: Colors.black.withOpacity(0.5),
                    offset: Offset(2, 2),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Login",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 30,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 30),

                  // ✅ Email
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),

                  // ✅ Password
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),

                  // ✅ ปุ่ม Login
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _signIn,
                      child: _loading
                          ? CircularProgressIndicator(color: Colors.white)
                          : const Text('Login',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // ✅ ไปหน้า Sign Up
                  GestureDetector(
                    onTap: () {
                      Get.toNamed('/signUp'); // ✅ ใช้ GetX
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "Sign up",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // ✅ ปุ่ม "Skip" ไปหน้า `Homenine`
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      onPressed: () {
                        Get.offNamed('/homenine'); // ✅ ข้าม Login
                      },
                      child: const Text(
                        "Continue as Guest", // ✅ เปลี่ยนจาก "Skip" เป็น "Continue as Guest"
                        style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 100, 102, 103)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
