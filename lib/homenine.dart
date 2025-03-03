import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nineebibifood/app_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Homenine extends StatefulWidget {
  @override
  State<Homenine> createState() => _HomenineState();
}

class _HomenineState extends State<Homenine> {
  int _selectedIndex = 0;
  final _supabase = Supabase.instance.client;
  final appController = Get.find<AppController>(); // ✅ ใช้ GetX Controller

  Map<String, dynamic>? userData;
  List<dynamic> markets = [];
  List<dynamic> restaurants = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final userId = appController.userId.value;
      if (userId.isEmpty) {
        _showSnackbar('❌ User ID is missing.');
        return;
      }

      // ✅ ดึงข้อมูลผู้ใช้
      final response = await _supabase
          .from('user')
          .select('name, email, address, phone')
          .eq('id', userId)
          .single();

      // ✅ ดึงข้อมูลร้านค้าและตลาด
      final responseMarket =
          await _supabase.from('shop').select('*').eq('category', 'Market');

      final responseFood =
          await _supabase.from('shop').select('*').eq('category', 'Food');

      if (response != null) {
        setState(() {
          userData = response;
          markets = responseMarket;
          restaurants = responseFood;
          _loading = false;
        });
      }
    } catch (error) {
      print('Error fetching user data: $error');
      _showSnackbar('❌ Failed to fetch user data.');
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
        title: Text(
          'Welcome ${userData?['name'] ?? ''}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                await _supabase.auth.signOut();
                Get.offAllNamed('/login');
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator()) // ✅ แสดงโหลดข้อมูล
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
                                      Get.toNamed('/market_list', arguments: {
                                        'userId': appController.userId.value,
                                        'category': 'Food'
                                      });
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
                                      Get.toNamed('/market_list', arguments: {
                                        'userId': appController.userId.value,
                                        'category': 'Market'
                                      });
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
              Get.toNamed('/menu1', arguments: {'id': items[index]['id']});
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
                        items[index]['name'] ?? '',
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
