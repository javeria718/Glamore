// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_constructors_in_immutables

import 'package:ecom_app/widgets/appbar_category.dart';
import 'package:ecom_app/widgets/drawer.dart';
import 'package:ecom_app/widgets/products_con.dart';
import 'package:ecom_app/widgets/searchcontainer.dart';
import 'package:flutter/material.dart';

class Watches extends StatefulWidget {
  Watches({super.key});

  @override
  State<Watches> createState() => _WatchesState();
}

class _WatchesState extends State<Watches> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> watchesList = [
    {
      'link': 'assets/images/w1.jpeg',
      'title': 'Smart Watch',
      'price': '\$15.00',
    },
    {
      'link': 'assets/images/w2.jpeg',
      'title': 'Classic Watch',
      'price': '\$20.00',
    },
    {
      'link': 'assets/images/w3.jpeg',
      'title': 'Man Watch',
      'price': '\$15.00',
    },
    {
      'link': 'assets/images/w4.jpeg',
      'title': 'Bonito Watch',
      'price': '\$20.00',
    },
    {
      'link': 'assets/images/w5.jpeg',
      'title': 'Bonito Watch',
      'price': '\$20.00',
    },
    {
      'link': 'assets/images/w6.jpeg',
      'title': 'Bonito Watch',
      'price': '\$20.00',
    },
    {
      'link': 'assets/images/w8.jpeg',
      'title': 'Bonito Watch',
      'price': '\$20.00',
    },
    {
      'link': 'assets/images/w77.jpeg',
      'title': 'Bonito Watch',
      'price': '\$20.00',
    },
  ];

  List<Map<String, String>> filteredList = [];

  @override
  void initState() {
    super.initState();
    filteredList = watchesList; // Initialize with all items
  }

  void _filterProducts(String query) {
    final results = watchesList.where((item) {
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
      appBar: categoryBar(context, 'Watches', Icons.shopping_cart_outlined),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomSearchBar(
              controller: _searchController,
              onChanged: _filterProducts,
              hintText: 'Search Watches',
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
                itemCount: watchesList.length,
                itemBuilder: (context, index) {
                  String link =
                      watchesList[index]['link'] ?? 'assets/default_image.png';
                  String title = watchesList[index]['title'] ?? 'Unknown';
                  String price = watchesList[index]['price'] ?? 'Not Available';
                  return ProductInfo(
                    link: link,
                    title: title,
                    price: price,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
