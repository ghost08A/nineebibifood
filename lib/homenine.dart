import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:nineebibifood/app_controller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Homenine extends StatefulWidget {
  @override
  State<Homenine> createState() => _HomenineState();
}

class _HomenineState extends State<Homenine> {
  int _selectedIndex = 0;
  final appController = Get.find<AppController>(); // ✅ ใช้ GetX Controller

  List<dynamic> markets = [];
  List<dynamic> restaurants = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchShopData();
  }

  Future<void> _fetchShopData() async {
    try {
      final response =
          await http.get(Uri.parse('${dotenv.env['BASE_URL']}api/shop'));

      print("API Response: ${response.body}"); // Debug ดูข้อมูล API

      if (response.statusCode == 200) {
        final List<dynamic> shops = json.decode(response.body);

        // แยกข้อมูลร้านอาหารและตลาด
        setState(() {
          restaurants =
              shops.where((shop) => shop['category'] == 'Food').toList();
          markets =
              shops.where((shop) => shop['category'] == 'Market').toList();
          _loading = false;
        });
      } else {
        _showSnackbar('Failed to fetch shop data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching shop data: $error');
      _showSnackbar('❌ Failed to fetch shop data.');
      setState(() => _loading = false);
    }
  }

  void _showSnackbar(String message) {
    Get.snackbar('Error', message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black54,
        colorText: Colors.white);
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
        centerTitle: true,
        title: const Text(
          'Welcome',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator()) // ✅ แสดงโหลดข้อมูล
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              child: Column(
                                children: [
                                  const Text(
                                    "Restaurant",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  const SizedBox(height: 5),
                                  IconButton(
                                    onPressed: () {
                                      Get.toNamed('/market_list',
                                          arguments: {'category': 'Food'});
                                    },
                                    icon: const Icon(Icons.fastfood_rounded),
                                    iconSize: 40,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              child: Column(
                                children: [
                                  const Text(
                                    "Market",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  const SizedBox(height: 5),
                                  IconButton(
                                    onPressed: () {
                                      Get.toNamed('/market_list',
                                          arguments: {'category': 'Market'});
                                    },
                                    icon: const Icon(Icons.store),
                                    iconSize: 40,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Featured Restaurants Section
                    const Text(
                      "Featured Restaurants",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    _buildHorizontalList(restaurants),
                    const SizedBox(height: 20),
                    // Featured Market Section
                    const Text(
                      "Featured Market",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    _buildHorizontalList(markets),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildHorizontalList(List<dynamic> items) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Get.toNamed('/menu1', arguments: {
                'id': items[index]['id'],
                'shop_name': items[index]
                    ['name'], // ✅ ใช้ `items[index]` โดยตรง
              });
            },
            child: Container(
              width: 150,
              margin: const EdgeInsets.only(right: 10),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(10)),
                        child: Image.network(
                          items[index]['img'] ?? '',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(
                        utf8.decode(items[index]['name'].toString().codeUnits),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
