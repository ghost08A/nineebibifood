import 'package:flutter/material.dart';

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
        title: Text('Welcome',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
                            Text(
                              "Restaurant",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            SizedBox(height: 5),
                            IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/restaurant_list');
                                },
                                icon: Icon(Icons.fastfood_rounded),
                                iconSize: 40),
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
                            Text(
                              "Market",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            SizedBox(height: 10),
                            IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/restaurant_list');
                                },
                                icon: Icon(Icons.store),
                                iconSize: 40),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
