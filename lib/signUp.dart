import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _loading = false;
  final _supabase = Supabase.instance.client;

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

    try {
      // ✅ สมัครสมาชิกกับ Supabase Authentication
      final AuthResponse response = await _supabase.auth.signUp(
        email: _emailController.text,
        password: _passwordController.text,
      );

      final userId = response.user?.id; // ดึง user ID
      print("User ID: $userId");

      if (userId != null) {
        // ✅ บันทึกข้อมูลลงตาราง `users`
        final data = {
          'id': userId, // ใช้ user ID เป็น primary key
          'email': _emailController.text,
          'name': _usernameController.text,
          'address': _addressController.text,
          'phone': _phoneController.text,
        };

        final insertResponse = await _supabase.from('user').insert(data);

        _showSnackbar('✅ Sign Up Successful! Check your email.');
        Navigator.pop(context); // กลับไปหน้า login
      } else {
        _showSnackbar('❌ Sign Up failed. Please try again.');
      }
    } on AuthException catch (e) {
      _showSnackbar('❌ Error: ${e.message}');
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

              // Gmail
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
                  Navigator.pop(context);
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
