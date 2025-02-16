import 'package:flutter/material.dart';
import 'catalog_product.dart';

class RestaurantList extends StatefulWidget {
  const RestaurantList({super.key});

  @override
  State<RestaurantList> createState() => _RestaurantListState();
}

class _RestaurantListState extends State<RestaurantList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text("Resterants",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))),
      body: ListView.separated(
        itemCount: CatalogProduct.items.length,
        itemBuilder: (context, index) => ListTile(
          leading: Image.network(
            CatalogProduct.items[index].imageUrl,
            width: 86,
          ),
          title: Text(CatalogProduct.items[index].title),
          subtitle: Text(CatalogProduct.items[index].desc),
        ),
        separatorBuilder: (context, index) => Divider(),
      ),
    );
  }
}
