// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_constructors_in_immutables

import 'package:ecom_app/widgets/appbar_category.dart';
import 'package:ecom_app/widgets/drawer.dart';
import 'package:ecom_app/widgets/products_con.dart';
import 'package:ecom_app/widgets/searchcontainer.dart';
import 'package:flutter/material.dart';

class Bags extends StatefulWidget {
  Bags({super.key});

  @override
  State<Bags> createState() => _BagsState();
}

class _BagsState extends State<Bags> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, String>> bagsList = [
    {
      'link': 'assets/images/i.jpg',
      'title': 'Hand Bag',
      'price': 'Rs.1500',
    },
    {
      'link': 'assets/images/ii.jpg',
      'title': 'Hand Bag',
      'price': '\$200.00',
    },
    {
      'link': 'assets/images/iii.jpg',
      'title': 'Hand Bag',
      'price': '\$15.00',
    },
    {
      'link': 'assets/images/iv.jpg',
      'title': 'Hand Bag',
      'price': '\$20.00',
    },
    {
      'link': 'assets/images/b8.jpeg',
      'title': 'Hand Bag',
      'price': '\$15.00',
    },
    {
      'link': 'assets/images/b7.jpeg',
      'title': 'Hand Bag',
      'price': '\$20.00',
    },
    {
      'link': 'assets/images/b6.jpeg',
      'title': 'Hand Bag',
      'price': '\$15.00',
    },
    {
      'link': 'assets/images/b5.jpeg',
      'title': 'Hand Bag',
      'price': '\$20.00',
    },
  ];

  List<Map<String, String>> filteredList = [];

  @override
  void initState() {
    super.initState();
    filteredList = bagsList;
  }

  void _filterProducts(String query) {
    final results = bagsList.where((item) {
      final title = item['title']?.toLowerCase() ?? '';
      return title.contains(query.toLowerCase());
    }).toList();
    setState(() {
      filteredList = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(child: appDrawer(context)),
      appBar: categoryBar(context, 'Bags', Icons.shopping_cart_outlined),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomSearchBar(
              controller: _searchController,
              onChanged: _filterProducts,
              hintText: 'Search Bags',
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(), //// So it doesn't scroll inside SingleChildScrollView
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      MediaQuery.of(context).size.width > 600 ? 4 : 2,
                  //  On mobile (<600px), it shows 2 items in a row.
//On bigger screens (>600px), it shows 4 items in a row — responsive!
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.75,
// 0.75 keeps card height balanced with width.
                ),
                itemCount: bagsList.length,
                itemBuilder: (context, index) {
                  String link =
                      bagsList[index]['link'] ?? 'assets/default_image.png';
                  String title = bagsList[index]['title'] ?? 'Unknown';
                  String price = bagsList[index]['price'] ?? 'Not Available';
                  return ProductInfo(
                    link: link,
                    title: title,
                    price: price,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
