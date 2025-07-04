import 'package:ecom_app/view/categories/bags.dart';
import 'package:ecom_app/view/categories/clothes.dart';
import 'package:ecom_app/view/categories/jewelery.dart';
import 'package:ecom_app/view/categories/shoes.dart';
import 'package:ecom_app/view/categories/watches.dart';
import 'package:flutter/material.dart';
import 'package:ecom_app/view/cart/addcart.dart';
import 'package:ecom_app/auth/login.dart';
import 'package:ecom_app/Singleton/singleton.dart';

Widget appDrawer(BuildContext context) {
  final user = UserSingleton().userModel;

  return Drawer(
    child: Column(
      children: [
        Container(
          color: Colors.teal,
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage('assets/images/panda.jpg'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.name ?? 'Guest User',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      user?.email ?? 'email@example.com',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.white,
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 6),
              children: [
                _drawerItem(
                  context: context,
                  title: 'Dresses',
                  leadingIcon: Icons.category,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Clothes()),
                    );
                  },
                ),
                _drawerItem(
                  context: context,
                  title: 'Watches',
                  leadingIcon: Icons.category,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Watches()),
                    );
                  },
                ),
                _drawerItem(
                  context: context,
                  title: 'Shoes',
                  leadingIcon: Icons.category,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Shoes()),
                    );
                  },
                ),
                _drawerItem(
                  context: context,
                  title: 'Bags',
                  leadingIcon: Icons.category,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Bags()),
                    );
                  },
                ),
                _drawerItem(
                  context: context,
                  title: 'Jewellery',
                  leadingIcon: Icons.category,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Jewelery()),
                    );
                  },
                ),
                _drawerItem(
                  context: context,
                  title: 'Your Cart',
                  leadingIcon: Icons.shopping_cart_outlined,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddToCart()),
                    );
                  },
                ),
                const SizedBox(height: 100),
                const Divider(color: Colors.black),
                _drawerItem(
                  context: context,
                  title: 'Logout',
                  leadingIcon: Icons.logout,
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => LoginPage()));
                  },
                ),
              ],
            ),
          ),
        )
      ],
    ),
  );
}

/// 🔁 Reusable ListTile builder with black text and icons
Widget _drawerItem({
  required BuildContext context,
  required String title,
  required IconData leadingIcon,
  required VoidCallback onTap,
}) {
  return ListTile(
    onTap: onTap,
    leading: Icon(leadingIcon, color: Colors.black),
    title: Text(
      title,
      style: const TextStyle(color: Colors.black),
    ),
    trailing: const Icon(Icons.navigate_next, color: Colors.black),
  );
}
