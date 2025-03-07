import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:nineebibifood/app_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int _selectedIndex = 1;
  final _formKey = GlobalKey<FormState>();

  // Controller สำหรับ TextField
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();

  bool _loading = true; // แสดงสถานะโหลดข้อมูล
  String? userId; // เก็บ user ID สำหรับอัปเดตข้อมูล

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // ดึงข้อมูลเมื่อเข้าโปรไฟล์
  }

  // ✅ ดึงข้อมูลผู้ใช้จาก API
  Future<void> _fetchUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString(
        'token',
      ); // ดึง token จาก SharedPreferences

      if (token == null) {
        Get.offAllNamed('/login'); // กลับไปหน้า Login ถ้าไม่มี token
        return;
      }

      final response = await http.get(
        Uri.parse('${dotenv.env['BASE_URL']}api/auth/login'),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          userId = data['id']; // เก็บ user ID
          _emailController.text = data['email'] ?? "";
          _usernameController.text = data['name'] ?? "";
          _addressController.text = data['address'] ?? "";
          _telephoneController.text = data['phone'] ?? "";
          _loading = false;
        });
      } else {
        Get.snackbar(
          "Error",
          "Failed to load profile data",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (error) {
      print("❌ Error fetching user data: $error");
      Get.snackbar(
        "Error",
        "Failed to connect to server",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // ✅ อัปเดตข้อมูลผู้ใช้ไปที่ API
  Future<void> _updateUserData() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        Get.offAllNamed('/login');
        return;
      }

      final updatedData = {
        "id": userId,
        "email": _emailController.text,
        "name": _usernameController.text,
        "address": _addressController.text,
        "phone": _telephoneController.text,
      };

      final response = await http.put(
        Uri.parse('${dotenv.env['BASE_URL']}api/update'),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          "Success",
          "Profile updated successfully!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Error",
          "Failed to update profile",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (error) {
      print("❌ Error updating user data: $error");
      Get.snackbar(
        "Error",
        "Failed to connect to server",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.blue,
        items: const [
          Icon(Icons.home, size: 30),
          Icon(Icons.person, size: 30),
          Icon(Icons.history, size: 30),
        ],
        index: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          if (index == 0) {
            Get.toNamed('/homenine');
          } else if (index == 1) {
            Get.toNamed('/profile');
          } else if (index == 2) {
            Get.toNamed('/history');
          }
        },
      ),
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.blue,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('token'); // ✅ ลบ Token จาก SharedPreferences

              final appController =
                  Get.find<AppController>(); // ✅ ดึง AppController
              appController.setToken(null); // ✅ ล้างค่า Token
              print("🔴 Token removed from SharedPreferences & AppController");

              Get.offAllNamed('/login'); // ✅ กลับไปหน้า Login
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            ) // ✅ แสดงโหลดข้อมูล
          : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // ✅ เปลี่ยนเป็น Icon Profile ไม่มีปุ่มแก้ไข
                            const CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey,
                              child: Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),
                            buildTextField(
                              controller: _emailController,
                              label: 'Email',
                              hint: 'Enter your email',
                              keyboardType: TextInputType.emailAddress,
                              errorMsg: 'กรุณาใส่ Email',
                              readOnly: true,
                            ),
                            const SizedBox(height: 16.0),
                            buildTextField(
                              controller: _usernameController,
                              label: 'Username',
                              hint: 'Enter your username',
                              errorMsg: 'กรุณาใส่ Username',
                            ),
                            const SizedBox(height: 16.0),
                            buildTextField(
                              controller: _addressController,
                              label: 'Address',
                              hint: 'Enter your address',
                              errorMsg: 'กรุณาใส่ Address',
                            ),
                            const SizedBox(height: 16.0),
                            buildTextField(
                              controller: _telephoneController,
                              label: 'Telephone',
                              hint: 'Enter your telephone number',
                              keyboardType: TextInputType.phone,
                              errorMsg: 'กรุณาใส่ Telephone',
                            ),
                            const SizedBox(height: 24.0),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: _updateUserData,
                                child: const Text(
                                  'Save',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    required String errorMsg,
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      keyboardType: keyboardType,
      validator: (value) => value == null || value.isEmpty ? errorMsg : null,
    );
  }
}
