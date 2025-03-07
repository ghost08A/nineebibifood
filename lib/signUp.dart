import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _loading = false;

  Future<void> _signUp() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      _showSnackbar('❌ Passwords do not match!');
      return;
    }

    if (!_validateEmail(_emailController.text)) {
      _showSnackbar('❌ Invalid email format!');
      return;
    }

    if (!_validatePassword(_passwordController.text)) {
      _showSnackbar('❌ Password must be at least 6 characters!');
      return;
    }

    setState(() => _loading = true);

    final url = Uri.parse("${dotenv.env['BASE_URL']}api/auth/sign_in");

    final Map<String, dynamic> userData = {
      "name": _usernameController.text.trim(),
      "email": _emailController.text.trim(),
      "address": _addressController.text.trim(),
      "phone": _phoneController.text.trim(),
      "password": _passwordController.text,
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(userData),
      );

      print("📌 API Response: ${response.body}");

      if (response.statusCode == 201) {
        _showSnackbar('✅ Sign Up Successful! Please log in.');
        Get.offNamed('/login'); // ✅ กลับไปหน้า Login
      } else {
        final errorMessage =
            jsonDecode(response.body)['message'] ?? 'Sign Up Failed!';
        _showSnackbar('❌ Error: $errorMessage');
      }
    } catch (error) {
      print("❌ Error signing up: $error");
      _showSnackbar('❌ Failed to connect to server.');
    } finally {
      setState(() => _loading = false);
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  bool _validateEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        .hasMatch(email);
  }

  bool _validatePassword(String password) {
    return password.length >= 6;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 350,
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
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Sign Up",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 24),

              // Email
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 12),

              // Username
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),

              // Password
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 12),

              // Confirm Password
              TextField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 12),

              // Address
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),

              // Phone
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 20),

              // ปุ่ม Sign Up
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _signUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _loading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Sign Up',
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),

              SizedBox(height: 20),

              // ไปหน้า Login
              GestureDetector(
                onTap: () {
                  Get.offNamed('/login');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "Login",
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
            ],
          ),
        ),
      ),
    );
  }
}
