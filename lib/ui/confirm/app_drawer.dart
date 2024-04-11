import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../orders/order_screen.dart';
import '../products/user_product_screen.dart';
import '../auth/auth_manager.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color.fromARGB(
            255, 101, 112, 235), // Use primary color as background
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 50), // Add space at the top
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Hello Friend!',
                style: TextStyle(
                  color: Colors.white, // White text color
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.5), // Shadow color
                      offset: const Offset(2, 2), // Shadow offset
                      blurRadius: 4, // Shadow blur radius
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 26), // Add space between title and items
            ListTile(
              leading: const Icon(Icons.shop,
                  color: Colors.yellowAccent), // White icon color
              title: const Text('Shop',
                  style:
                      TextStyle(fontSize: 18, color: Colors.lightGreenAccent)),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
            Divider(color: Colors.grey[300], thickness: 1), // Lighter divider
            ListTile(
              leading: const Icon(Icons.payment, color: Colors.yellowAccent),
              title: const Text('Orders',
                  style:
                      TextStyle(fontSize: 18, color: Colors.lightGreenAccent)),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(OrderScreen.routeName);
              },
            ),
            Divider(color: Colors.grey[300], thickness: 1), // Lighter divider
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.yellowAccent),
              title: const Text('Manage Products',
                  style:
                      TextStyle(fontSize: 18, color: Colors.lightGreenAccent)),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(UserProductsScreen.routeName);
              },
            ),
            Divider(color: Colors.grey[300], thickness: 1), // Lighter divider
            ListTile(
              leading: const Icon(Icons.exit_to_app,
                  color: Color.fromARGB(255, 249, 200, 25)),
              title: const Text('Logout',
                  style: TextStyle(
                      fontSize: 18, color: Color.fromARGB(255, 241, 193, 19))),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
                context.read<AuthManager>().logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
