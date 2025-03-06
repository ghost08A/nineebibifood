import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:promptpay_qrcode_generate/promptpay_qrcode_generate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  late double totalPrice;
  late String shopName;
  late List<Map<String, dynamic>> orderItems;
  late double deliveryPrice;
  late bool ecoOption;
  late String token; // ✅ เพิ่มตัวแปร Token

  @override
  void initState() {
    super.initState();
    _loadToken(); // ✅ โหลด Token ก่อนทำคำขอ

    // ✅ รับข้อมูลจาก `OrderDetail`
    final Map<String, dynamic> args = Get.arguments ?? {};
    shopName = args['shop_name'] ?? "Unknown Shop";
    orderItems = List<Map<String, dynamic>>.from(args['items'] ?? []);
    deliveryPrice = args['delivery_price']?.toDouble() ?? 0.0;
    ecoOption = args['eco_option'] ?? false;
    totalPrice = args['total_price']?.toDouble() ?? 0.0;
  }

  // ✅ โหลด Token จาก SharedPreferences
  Future<void> _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token') ?? "";
    });
  }

  // ✅ ฟังก์ชันบันทึกข้อมูลไปที่ API `/api/history`
  Future<void> _saveOrder() async {
    final url = Uri.parse("http://192.168.2.163:3000/api/history");

    // ✅ ตรวจสอบว่า Token มีค่าหรือไม่
    if (token.isEmpty) {
      Get.snackbar("Error", "Unauthorized: Please login again",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    // ✅ สร้าง JSON ข้อมูลให้ตรงกับที่ต้องการ
    final Map<String, dynamic> orderData = {
      "shop_name": shopName, // ✅ ชื่อร้าน
      "detail": orderItems.map((item) {
        return {
          // utf8.decode(items[index]['name'].toString().codeUnits),
          "name":
              utf8.decode(item['name'].toString().codeUnits), // ✅ ชื่อสินค้า
          "price": item['price'], // ✅ ราคา
          "quantity": item['quantity'], // ✅ จำนวน
        };
      }).toList(),
      "option": deliveryPrice, // ✅ ค่าจัดส่ง
      "eco_option": ecoOption, // ✅ true = รับช้อนส้อม, false = ไม่รับ
    };

    try {
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token", // ✅ เพิ่ม Header Authorization
          "Content-Type": "application/json",
        },
        body: jsonEncode(orderData),
      );

      print("📌 API Response: ${response.body}");

      if (response.statusCode == 201) {
        Get.snackbar("✅ Success", "Order saved successfully",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);

        // ✅ กลับไปหน้าแรก
        Get.offAllNamed('/homenine');
      } else {
        Get.snackbar("❌ Error", "Failed to save order",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (error) {
      print("❌ Error saving order: $error");
      Get.snackbar("❌ Error", "Failed to connect to server",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment - $shopName"), // ✅ แสดงชื่อร้านใน AppBar
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // ✅ แสดง QR Code PromptPay ตามยอดเงินที่ต้องชำระ
            QRCodeGenerate(
              promptPayId: "0655389857",
              amount: totalPrice,
              width: 300,
              height: 300,
            ),

            const SizedBox(height: 20),

            // ✅ แสดงยอดรวมที่ต้องชำระ
            Text(
              "Total Price: ${totalPrice.toStringAsFixed(2)} ฿",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            // ✅ ปุ่มบันทึกข้อมูลลง API
            ElevatedButton(
              onPressed: _saveOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                elevation: 6,
                shadowColor: Colors.greenAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'บันทึกออเดอร์',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 10),

            // ✅ ปุ่มกลับหน้าแรก
            ElevatedButton(
              onPressed: () {
                Get.offAllNamed('/homenine');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                elevation: 6,
                shadowColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'กลับหน้าแรก',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
