import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  int _selectedIndex = 2;

  final List<Map<String, dynamic>> orderHistory = [
    {
      "restaurant": "Pizza Hub",
      "items": [
        {"name": "Pepperoni Pizza", "price": 200, "quantity": 1},
        {"name": "Coke", "price": 50, "quantity": 1},
        {"name": "Garlic Bread", "price": 100, "quantity": 1},
      ],
      "date": "Feb 22, 2025"
    },
    {
      "restaurant": "Burger King",
      "items": [
        {"name": "Cheese Burger", "price": 150, "quantity": 1},
        {"name": "Fries", "price": 80, "quantity": 1},
        {"name": "Iced Tea", "price": 60, "quantity": 1},
      ],
      "date": "Feb 20, 2025"
    },
  ];

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
        automaticallyImplyLeading: false,
        title: Text("Order History"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: orderHistory.length,
        itemBuilder: (context, index) {
          final order = orderHistory[index];

          // ✅ คำนวณราคารวมจากรายการสินค้า
          double totalPrice = order["items"].fold(0.0, (sum, item) {
            return sum +
                (item["price"].toDouble() * item["quantity"].toDouble());
          });

          return Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ ชื่อร้าน
                  Text(
                    order["restaurant"],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),

                  // ✅ วันที่สั่งอาหาร
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.grey[700]),
                      SizedBox(width: 5),
                      Text(
                        " ${order["date"]}",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  // ✅ รายละเอียดสินค้า
                  Column(
                    children: order["items"].map<Widget>((item) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${item["quantity"]}x ${item["name"]}"),
                            Text("${item["price"]} ฿"),
                          ],
                        ),
                      );
                    }).toList(),
                  ),

                  Divider(),

                  // ✅ ราคารวมทั้งหมด
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${totalPrice.toStringAsFixed(2)} ฿", // ✅ แสดงผลราคา 2 ตำแหน่ง
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
