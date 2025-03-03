import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MarketList extends StatefulWidget {
  @override
  State<MarketList> createState() => _MarketListState();
}

class _MarketListState extends State<MarketList> {
  int _selectedIndex = 0;
  final SupabaseClient supabase = Supabase.instance.client;

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
      final userId = Get.arguments['userId'] ?? '';
      String category = 'Market';

      // ✅ รับค่าจาก `Get.arguments`
      if (Get.arguments['category'] == 'Market') {
        category = Get.arguments['category'] ?? 'Market';
      } else if (Get.arguments['category'] == 'Food') {
        category = Get.arguments['category'] ?? 'Food';
      }

      if (userId.isEmpty) {
        showSnackbar('❌ User ID is missing.');
        return;
      }
      if (userId.isEmpty) {
        showSnackbar('❌ User ID is missing.');
        return;
      }

      // ✅ อัปเดต `_title` ตาม `category`
      setState(() {
        _title = category == 'Food' ? 'Restaurants' : 'Markets';
      });

      final response =
          await supabase.from('shop').select().eq('category', category);

      if (response != null && response is List) {
        setState(() {
          markets = response;
          isLoading = false;
        });
      }
    } catch (error) {
      print('Error fetching market data: $error');
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
          "${_title}",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                await supabase.auth.signOut();
                Get.offAllNamed('/login');
              },
              icon: const Icon(Icons.logout))
        ],
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
                        arguments: {'id': markets[index]['id']},
                      );
                    },
                    leading: Image.network(
                      markets[index]['img'] ?? '',
                      width: 86,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image_not_supported),
                    ),
                    title: Text(markets[index]['name'] ?? 'Unknown'),
                    subtitle: Text(markets[index]['description'] ?? ''),
                  ),
                  separatorBuilder: (context, index) => const Divider(),
                ),
    );
  }
}
