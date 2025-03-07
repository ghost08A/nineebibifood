import 'dart:convert';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  int _selectedIndex = 2;
  List<dynamic> orderHistory = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrderHistory();
  }

  String _formatOrderDate(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) {
      return "No Date"; // ✅ ถ้าค่าว่าง ให้แสดงข้อความนี้
    }

    try {
      DateTime dateTime = DateTime.parse(dateTimeString).toLocal();
      return DateFormat('d/M/yyyy HH:mm').format(dateTime);
    } catch (e) {
      print("❌ Error parsing date: $e");
      return "Invalid Date"; // ✅ ถ้าเกิด error ให้แสดงข้อความนี้
    }
  }

  Future<void> fetchOrderHistory() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        print("❌ No token found");
        Get.offAllNamed('/login'); // ✅ ถ้าไม่มี Token ให้กลับไป Login
        return;
      }

      print("✅ Token: $token");

      // ✅ ดึงข้อมูลจาก API
      final response = await http.get(
        Uri.parse("${dotenv.env['BASE_URL']}api/history"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          orderHistory = data;
          isLoading = false;
        });
        print("✅ Order History: $data");
      } else {
        print("❌ Failed to fetch history: ${response.body}");
      }
    } catch (error) {
      print("❌ Error fetching history: $error");
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
        automaticallyImplyLeading: false,
        title: const Text("Order History"),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orderHistory.isEmpty
              ? const Center(child: Text("No orders found"))
              : ListView.builder(
                  itemCount: orderHistory.length,
                  itemBuilder: (context, index) {
                    final order = orderHistory[index];

                    // ✅ ดึงข้อมูลจาก JSON
                    String shopName = order["shop_name"];
                    String orderDate = order["created_at"];
                    List<dynamic> items = order["detail"];

                    // ✅ คำนวณราคารวม
                    double totalPrice = items.fold(0.0, (sum, item) {
                      return sum +
                          (item["price"].toDouble() *
                              item["quantity"].toDouble());
                    });

                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ✅ ชื่อร้าน
                            Text(
                              utf8.decode(shopName.toString().codeUnits),
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),

                            // ✅ วันที่สั่งอาหาร
                            Row(
                              children: [
                                Icon(Icons.calendar_today,
                                    color: Colors.grey[700]),
                                const SizedBox(width: 5),
                                Text(
                                  _formatOrderDate(order["created_at"]),
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            // ✅ รายละเอียดสินค้า
                            Column(
                              children: items.map<Widget>((item) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          "${item["quantity"]}x ${utf8.decode(item["name"].toString().codeUnits)}"),
                                      Text("${item["price"]} ฿"),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),

                            const Divider(),

                            // ✅ ราคารวมทั้งหมด
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Total",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "${totalPrice.toStringAsFixed(2)} ฿",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
