import 'package:flutter/material.dart';
import 'catalog_market.dart';

class MarketList extends StatefulWidget {
  const MarketList({super.key});

  @override
  State<MarketList> createState() => _MarketListState();
}

class _MarketListState extends State<MarketList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Market",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: ListView.separated(
        itemCount: CatalogMarket.items.length,
        itemBuilder: (context, index) => ListTile(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/menu1',
              arguments: CatalogMarket.items[index],
            );
          },
          leading: Image.network(
            CatalogMarket.items[index].imageUrl,
            width: 86,
          ),
          title: Text(CatalogMarket.items[index].title),
          subtitle: Text(CatalogMarket.items[index].desc),
        ),
        separatorBuilder: (context, index) => const Divider(),
      ),
    );
  }
}
