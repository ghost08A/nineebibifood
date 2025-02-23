import 'package:flutter/material.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildHeader(context),
            buildMenuItems(context),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) => Material(
        color: Colors.blue.shade700,
        child: InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 20,
              bottom: 24,
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 52,
                  backgroundImage: NetworkImage(
                      "https://cdn-icons-png.flaticon.com/128/7542/7542190.png"),
                ),
                const Text(
                  "Voramate Phothong",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                const Text(
                  "voramate@example.com",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                )
              ],
            ),
          ),
        ),
      );

  Widget buildMenuItems(BuildContext context) => Column(
        children: [
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Admin Home'),
            onTap: () {
              Navigator.pushNamed(context, '/adminHome');
            },
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pushNamed(context, '/dashboard');
            },
          ),
          const Divider(color: Colors.grey),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {},
          ),
        ],
      );
}
