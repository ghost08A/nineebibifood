import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MarketList extends StatefulWidget {
  @override
  State<MarketList> createState() => _MarketListState();
}

class _MarketListState extends State<MarketList> {
  int _selectedIndex = 0;
  List<dynamic> markets = [];
  bool isLoading = true;
  String _title = 'Market';

  @override
  void initState() {
    super.initState();
    fetchMarkets();
  }

  Future<void> fetchMarkets() async {
    try {
      final String category =
          Get.arguments['category'] ?? 'Market'; // ✅ ค่าเริ่มต้นเป็น Market
      print("🔹 Category: $category");

      setState(() {
        _title = category == 'Food' ? 'Restaurants' : 'Markets';
      });

      final response = await http.get(
          Uri.parse('${dotenv.env['BASE_URL']}api/shop/category/$category'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print("✅ Data fetched: $data");

        setState(() {
          markets = data;
          isLoading = false;
        });
      } else {
        print("❌ Error fetching data: ${response.statusCode}");
        showSnackbar('❌ Failed to fetch market data.');
        setState(() => isLoading = false);
      }
    } catch (error) {
      print('❌ Error: $error');
      showSnackbar('❌ Failed to fetch market data.');
      setState(() => isLoading = false);
    }
  }

  void showSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black54,
      colorText: Colors.white,
    );
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
        centerTitle: true,
        title: Text(
          _title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : markets.isEmpty
              ? const Center(child: Text("No markets available"))
              : ListView.separated(
                  itemCount: markets.length,
                  itemBuilder: (context, index) => ListTile(
                    onTap: () {
                      Get.toNamed(
                        '/menu1',
                        arguments: {
                          'id': markets[index]['id'],
                          'shop_name': utf8.decode(
                              markets[index]['name'].toString().codeUnits),
                        },
                      );
                    },
                    leading: Image.network(
                      markets[index]['img'] ?? '',
                      width: 86,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image_not_supported),
                    ),
                    title: Text(
                      utf8.decode(markets[index]['name'].toString().codeUnits),
                    ),
                    subtitle: Text(
                      utf8.decode(
                          markets[index]['description'].toString().codeUnits),
                    ),
                  ),
                  separatorBuilder: (context, index) => const Divider(),
                ),
    );
  }
}
