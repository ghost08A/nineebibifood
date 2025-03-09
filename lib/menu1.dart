import 'package:auto_size_text/auto_size_text.dart';
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
    shopName = Get.arguments['shop_name']; // ✅ รับชื่อร้าน
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

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // ✅ เช็ค `mounted` ก่อน `setState()`
        if (mounted) {
          setState(() {
            _menuItems = data
                .map((item) => MenuItem(
                      id: item['id'],
                      name: item['name'],
                      price: double.parse(item['price'].toString()),
                      img: item['img'],
                    ))
                .toList();
            _loading = false;
          });
        }
      } else {
        throw Exception("Failed to load menu");
      }
    } catch (error) {
      print("❌ Error fetching menu: $error");

      // ✅ เช็ค `mounted` ก่อน `setState()`
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  double get totalPrice {
    return _menuItems.fold(
        0, (sum, item) => sum + (item.price * item.quantity));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(utf8.decode(shopName.toString().codeUnits))),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _menuItems.isEmpty
              ? Center(child: Text("ไม่มีเมนูอาหาร"))
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GridView.builder(
                    itemCount: _menuItems.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                      childAspectRatio: 3 / 5,
                    ),
                    itemBuilder: (context, index) {
                      final item = _menuItems[index];
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              spreadRadius: 2,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // ✅ ใช้ Stack เพื่อรองรับ Placeholder Loading
                            Stack(
                              children: [
                                Container(
                                  height: 110,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey[200],
                                  ),
                                  child: const Center(
                                    child:
                                        CircularProgressIndicator(), // 🔄 แสดง Loading ตอนโหลดรูป
                                  ),
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    item.img,
                                    width: double.infinity,
                                    height: 110,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        height: 110,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.grey[200],
                                        ),
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    },
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                      height: 110,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey[300],
                                      ),
                                      child: const Center(
                                        child: Icon(Icons.broken_image,
                                            size: 40, color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // ✅ ใช้ Expanded ป้องกัน Bottom Overflow
                            Expanded(
                              child: Column(
                                children: [
                                  // ✅ ป้องกันข้อความล้น
                                  AutoSizeText(
                                    utf8.decode(item.name.toString().codeUnits),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 4),

                                  Text(
                                    'ราคา: ${item.price.toStringAsFixed(2)} บาท',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey[700]),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8),

                            // ✅ ปรับขนาดปุ่มให้สวยขึ้น
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                        Icons.remove_circle_outline,
                                        color: Colors.blue),
                                    onPressed: () {
                                      setState(() {
                                        if (item.quantity > 0) {
                                          item.quantity--;
                                        }
                                      });
                                    },
                                  ),
                                  Text(
                                    item.quantity.toString(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline,
                                        color: Colors.blue),
                                    onPressed: () {
                                      setState(() {
                                        item.quantity++;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black12, blurRadius: 6, offset: Offset(0, -2)),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'รวม: ${totalPrice.toStringAsFixed(2)} บาท',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final selectedItems = _menuItems
                    .where((item) => item.quantity > 0)
                    .map((item) => {
                          "id": item.id,
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

                Get.toNamed('/orderDetail',
                    arguments: {"shop_name": shopName, "items": selectedItems});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              child: const Text('ชำระเงิน'),
            ),
          ],
        ),
      ),
    );
  }
}
