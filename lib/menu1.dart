import 'package:flutter/material.dart';
import 'orderDetail.dart';

class Menu1 extends StatefulWidget {
  const Menu1({super.key});

  @override
  State<Menu1> createState() => _Menu1State();
}

// โมเดลสำหรับเก็บข้อมูลเมนูอาหาร
class MenuItem {
  final String name;
  final double price;
  int quantity;

  MenuItem({
    required this.name,
    required this.price,
    this.quantity = 0,
  });
}

class _Menu1State extends State<Menu1> {
  // กำหนดรายการเมนูอาหาร 6 รายการ
  final List<MenuItem> _menuItems = [
    MenuItem(name: 'เมนู 1', price: 100.0),
    MenuItem(name: 'เมนู 2', price: 120.0),
    MenuItem(name: 'เมนู 3', price: 150.0),
    MenuItem(name: 'เมนู 4', price: 99.0),
    MenuItem(name: 'เมนู 5', price: 89.0),
    MenuItem(name: 'เมนู 6', price: 75.0),
  ];

  // ฟังก์ชันคำนวณราคารวมทั้งหมด
  double get totalPrice {
    double sum = 0;
    for (var item in _menuItems) {
      sum += item.price * item.quantity;
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายการอาหาร'),
      ),
      // ใช้ GridView.builder เพื่อแสดงเมนูเรียงเป็นสองคอลัมน์
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: _menuItems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                    // Image placeholder (ช่องสำหรับรูปภาพ)
                    Container(
                      height: 80,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('ราคา: ${item.price.toStringAsFixed(2)} บาท'),
                    const Spacer(),
                    // ปุ่มเพิ่มลดจำนวนอาหาร
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
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
      // แถบด้านล่างแสดงยอดรวมและปุ่ม "ชำระเงิน"
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        height: 60,
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: Text(
                'รวม: ${totalPrice.toStringAsFixed(2)} บาท',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/orderDetail');
                // เมื่อกดปุ่ม "ชำระเงิน" จะแสดง SnackBar แจ้งเตือน
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('กดชำระเงินแล้ว'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              child: const Text('ชำระเงิน'),
            ),
          ],
        ),
      ),
    );
  }
}
