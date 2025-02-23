import 'package:flutter/material.dart';

class Login1 extends StatefulWidget {
  @override
  _Login1State createState() => _Login1State();
}

class _Login1State extends State<Login1> {
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
                fontWeight: FontWeight.bold, // ทำให้ข้อความหนาขึ้น
                fontSize: 50, // ขนาดของฟอนต์
                color: Colors.orange, // สีของข้อความ
                letterSpacing: 2, // ระยะห่างระหว่างตัวอักษร
                shadows: [
                  Shadow(
                    blurRadius: 5, // ความเบลอของเงา
                    color: Colors.black.withOpacity(0.5), // สีของเงา
                    offset: Offset(2, 2), // ตำแหน่งของเงา
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12), // มุมมน
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

                  // email
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),

                  // pass
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),

                  // ปุ่ม Login
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/homenine');
                      },
                      child: const Text('Login',
                          style: TextStyle(color: Colors.white, fontSize: 18)),
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

                  // Text signup nakub
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/signUp');
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
