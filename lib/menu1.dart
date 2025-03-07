import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Menu1 extends StatefulWidget {
  @override
  State<Menu1> createState() => _Menu1State();
}

// ✅ โมเดลสำหรับเก็บข้อมูลเมนูอาหาร
class MenuItem {
  final int id; // ✅ เพิ่ม ID ของเมนู
  final String name;
  final double price;
  final String img; // ✅ ต้องไม่เป็น null
  int quantity;

  MenuItem({
    required this.id,
    required this.name,
    required this.price,
    required this.img, // ✅ ตรวจสอบให้แน่ใจว่ามีค่า
    this.quantity = 0,
  });
}

class _Menu1State extends State<Menu1> {
  List<MenuItem> _menuItems = [];
  bool _loading = true;
  int shopId = 0;
  String shopName = "shop";
  @override
  void initState() {
    super.initState();
    shopId = Get.arguments['id'] ?? 0; // ✅ รับค่า `id` จาก `homenine`
    //shopName = utf8.decode(args['shop_name'].toString().codeUnits);
    shopName = utf8.decode(
        Get.arguments['shop_name'].toString().codeUnits); // ✅ รับชื่อร้าน
    if (shopId != 0) {
      _fetchMenuData();
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _fetchMenuData() async {
    try {
      final response = await http
          .get(Uri.parse('${dotenv.env['BASE_URL']}api/shop/menu/$shopId'));

      print("📌 API Response: ${response.body}"); // ✅ Debug API Response

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        setState(() {
          _menuItems = data.map((item) {
            return MenuItem(
              id: item['id'],
              name: item['name'],
              price: double.parse(item['price'].toString()),
              img: item['img'] ??
                  'https://via.placeholder.com/150', // ✅ ถ้าไม่มี URL ใช้ Placeholder
            );
          }).toList();
          _loading = false;
        });
      } else {
        throw Exception("Failed to load menu");
      }
    } catch (error) {
      print("❌ Error fetching menu: $error");
      setState(() {
        _loading = false;
      });
    }
  }

  double get totalPrice {
    return _menuItems.fold(
        0, (sum, item) => sum + (item.price * item.quantity));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$shopName')),

      // ✅ ตรวจสอบว่ากำลังโหลดข้อมูลอยู่หรือไม่
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _menuItems.isEmpty
              ? Center(child: Text("ไม่มีเมนูอาหาร"))
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    itemCount: _menuItems.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 คอลัมน์
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                      childAspectRatio: 3 / 4, // กำหนดอัตราส่วนของแต่ละการ์ด
                    ),
                    itemBuilder: (context, index) {
                      final item = _menuItems[index];
                      return Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // ✅ แสดงรูปภาพจาก API
                              Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey[200], // สีพื้นหลังขณะโหลด
                                  image: DecorationImage(
                                    image: NetworkImage(item.img),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),

                              /*Expanded( // ✅ ขยายให้เต็มพื้นที่ที่เหลือ
      child: Text(
        item.name,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ), */
                              Expanded(
                                child: Text(
                                  utf8.decode(item.name
                                      .toString()
                                      .codeUnits), // ✅ ไม่ต้องใช้ utf8.decode() ถ้า API ส่งมาถูกต้อง
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                  'ราคา: ${item.price.toStringAsFixed(2)} บาท'),
                              const Spacer(),

                              // ✅ ปุ่มเพิ่มลดจำนวนอาหาร
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon:
                                        const Icon(Icons.remove_circle_outline),
                                    onPressed: () {
                                      setState(() {
                                        if (item.quantity > 0) {
                                          item.quantity--;
                                        }
                                      });
                                    },
                                  ),
                                  Text(item.quantity.toString()),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    onPressed: () {
                                      setState(() {
                                        item.quantity++;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

      // ✅ แถบด้านล่างแสดงยอดรวมและปุ่ม "ชำระเงิน"
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        height: 60,
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: Text(
                'รวม: ${totalPrice.toStringAsFixed(2)} บาท',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // ✅ ดึงเมนูที่มีจำนวนมากกว่า 0
                final selectedItems = _menuItems
                    .where((item) => item.quantity > 0)
                    .map((item) => {
                          "id": item.id, // ✅ ID ของเมนู
                          "name": item.name,
                          "price": item.price,
                          "quantity": item.quantity
                        })
                    .toList();

                if (selectedItems.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('กรุณาเลือกเมนูก่อนชำระเงิน')),
                  );
                  return;
                }

                // ✅ ส่งข้อมูลไป `/orderDetail`
                Get.toNamed('/orderDetail',
                    arguments: {"shop_name": shopName, "items": selectedItems});
              },
              child: const Text('ชำระเงิน'),
            ),
          ],
        ),
      ),
    );
  }
}
