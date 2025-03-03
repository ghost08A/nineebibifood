import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int _selectedIndex = 1;
  final _formKey = GlobalKey<FormState>();

  // Controller สำหรับจัดการข้อมูลใน TextFormField
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // กำหนดข้อมูลสมมุติให้กับแต่ละ TextField
    _emailController.text = 'example@example.com';
    _usernameController.text = 'exampleUser';
    _addressController.text = '123 Main Street, City';
    _telephoneController.text = '0123456789';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _addressController.dispose();
    _telephoneController.dispose();
    super.dispose();
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
            Navigator.pushNamed(context, '/homenine');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/profile');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/history');
          }
        },
      ),
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Container(
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
                  key: _formKey, // กำหนด key สำหรับ Form
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // รูปโปรไฟล์แบบวงกลมพร้อมปุ่มเปลี่ยนรูป
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: const NetworkImage(
                                'https://via.placeholder.com/150'),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.deepPurple,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.camera_alt,
                                    color: Colors.white),
                                onPressed: () {
                                  // เพิ่ม logic ในการเปลี่ยนรูปโปรไฟล์ได้ที่นี่
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      buildTextField(
                        controller: _emailController,
                        label: 'Email',
                        hint: 'Enter your email',
                        keyboardType: TextInputType.emailAddress,
                        errorMsg: 'กรุณาใส่ Email',
                        readOnly: true, // ช่อง Email ไม่สามารถแก้ไขได้
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
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: Colors.deepPurple,
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // เพิ่ม logic ในการบันทึกข้อมูลโปรไฟล์ได้ที่นี่
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Profile updated')),
                              );
                            }
                          },
                          child: const Text(
                            'Save',
                            style: TextStyle(fontSize: 16, color: Colors.white),
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
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.deepPurple),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return errorMsg;
        }
        return null;
      },
    );
  }
}
