import 'package:flutter/material.dart';
import 'catalog_product.dart'; // ตรวจสอบ path ให้ถูกต้องตามโปรเจคของคุณ
import 'catalog_market.dart'; // ตรวจสอบ path ให้ถูกต้องตามโปรเจคของคุณ

class Homenine extends StatefulWidget {
  const Homenine({super.key});

  @override
  State<Homenine> createState() => _HomenineState();
}

class _HomenineState extends State<Homenine> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Welcome',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      // SingleChildScrollView เพื่อรองรับการเลื่อนหน้าจอในแนวตั้ง
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ปุ่ม Restaurant กับ Market แบบเดิม
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
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            const SizedBox(height: 5),
                            IconButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, '/restaurant_list');
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
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            const SizedBox(height: 5),
                            IconButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/market_list');
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
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: CatalogProduct.items.length,
                  itemBuilder: (context, index) {
                    final product = CatalogProduct.items[index];
                    // ใช้ InkWell เพื่อให้ Card ตอบสนองการกด
                    return InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/menu1',
                          arguments: product,
                        );
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
                                    product.imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Text(
                                  product.title,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
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
              ),
              const SizedBox(height: 20),
              // Featured Market Section
              const Text(
                "Featured Market",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: CatalogMarket.items.length,
                  itemBuilder: (context, index) {
                    final market = CatalogMarket.items[index];
                    // ใช้ InkWell เพื่อให้ Card ตอบสนองการกดในส่วน Market
                    return InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/menu1',
                          arguments: market,
                        );
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
                                    market.imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Text(
                                  market.title,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
